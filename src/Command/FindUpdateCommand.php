<?php

namespace App\Command;

use App\Entity\Find;
use App\Repository\FindRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Attribute\AsCommand;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

#[AsCommand(
    name: 'find:update',
    description: 'Update find records from a CSV or FileMaker XML file',
)]
class FindUpdateCommand extends Command
{
    private EntityManagerInterface $entityManager;
    private FindRepository $findRepository;

    public function __construct(EntityManagerInterface $entityManager, FindRepository $findRepository)
    {
        parent::__construct();
        $this->entityManager = $entityManager;
        $this->findRepository = $findRepository;
    }
    
    private function getDataDirectory(): string
    {
        // Get project directory from kernel
        return dirname(__DIR__, 2) . '/data';
    }

    protected function configure(): void
    {
        $this
            ->addArgument('filename', InputArgument::REQUIRED, 'The filename (CSV or XML) in the /data directory')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Run without actually persisting changes to the database')
            ->addOption('batch-size', 'b', InputOption::VALUE_REQUIRED, 'Number of records to process before flushing', 20)
            ->addOption('set-empty-to-null', null, InputOption::VALUE_NONE, 'Set empty fields in the CSV/XML to null in the database')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        $filename = $input->getArgument('filename');
        $dryRun = $input->getOption('dry-run');
        $batchSize = (int) $input->getOption('batch-size');
        $setEmptyToNull = $input->getOption('set-empty-to-null');

        // Construct full file path
        $filePath = $this->getDataDirectory() . '/' . $filename;

        if (!file_exists($filePath)) {
            $io->error(sprintf('File not found: %s', $filePath));
            return Command::FAILURE;
        }

        $io->title('Find Update Command');
        $io->info(sprintf('Processing file: %s', $filename));
        
        if ($dryRun) {
            $io->warning('DRY RUN MODE - No changes will be persisted');
        }
        
        if ($setEmptyToNull) {
            $io->info('Empty fields will be set to NULL in the database');
        }

        // Determine file type and process accordingly
        $extension = strtolower(pathinfo($filename, PATHINFO_EXTENSION));
        
        try {
            if ($extension === 'csv') {
                $stats = $this->processCsvFile($filePath, $io, $dryRun, $batchSize, $setEmptyToNull);
            } elseif ($extension === 'xml') {
                $stats = $this->processXmlFile($filePath, $io, $dryRun, $batchSize, $setEmptyToNull);
            } else {
                $io->error(sprintf('Unsupported file format: %s. Only CSV and XML files are supported.', $extension));
                return Command::FAILURE;
            }

            // Display statistics
            $io->success('Processing completed!');
            $io->table(
                ['Metric', 'Count'],
                [
                    ['Total records processed', $stats['processed']],
                    ['Records updated', $stats['updated']],
                    ['Records not found', $stats['not_found']],
                    ['Records skipped', $stats['skipped']],
                    ['Errors', $stats['errors']],
                ]
            );

            return Command::SUCCESS;
        } catch (\Exception $e) {
            $io->error(sprintf('An error occurred: %s', $e->getMessage()));
            $io->error($e->getTraceAsString());
            return Command::FAILURE;
        }
    }

    private function processCsvFile(string $filePath, SymfonyStyle $io, bool $dryRun, int $batchSize, bool $setEmptyToNull): array
    {
        $stats = ['processed' => 0, 'updated' => 0, 'not_found' => 0, 'skipped' => 0, 'errors' => 0];
        
        $handle = fopen($filePath, 'r');
        if ($handle === false) {
            throw new \RuntimeException('Unable to open CSV file');
        }

        // Read header row
        $headers = fgetcsv($handle);
        if ($headers === false) {
            fclose($handle);
            throw new \RuntimeException('Unable to read CSV headers');
        }

        // Normalize headers to camelCase
        $headers = array_map(function($header) {
            return $this->normalizeFieldName($header);
        }, $headers);

        // Verify 'id' column exists
        if (!in_array('id', $headers)) {
            fclose($handle);
            throw new \RuntimeException('CSV file must contain an "id" column');
        }

        $io->progressStart();
        $processedInBatch = 0;

        // Process each row
        while (($row = fgetcsv($handle)) !== false) {
            $stats['processed']++;
            
            // Combine headers with row data
            $data = array_combine($headers, $row);
            
            if ($data === false || !isset($data['id']) || trim($data['id']) === '') {
                $io->writeln(sprintf('<comment>Skipping row %d: Invalid data or missing ID</comment>', $stats['processed']));
                $stats['skipped']++;
                continue;
            }

            $findId = (int) $data['id'];
            
            // Validate tm field if present
            if (isset($data['tm']) && trim($data['tm']) !== '' && (!ctype_digit(trim($data['tm'])) || (int) $data['tm'] <= 0)) {
                $io->writeln(sprintf('<comment>Skipping find ID %d: tm value "%s" is not a valid positive integer</comment>', $findId, $data['tm']));
                $stats['skipped']++;
                continue;
            }

            try {
                $result = $this->updateFind($findId, $data, $dryRun, $setEmptyToNull);
                
                if ($result === 'updated') {
                    $stats['updated']++;
                    $processedInBatch++;
                    
                    // Flush in batches for better performance
                    if (!$dryRun && $processedInBatch >= $batchSize) {
                        $this->entityManager->flush();
                        $this->entityManager->clear();
                        $processedInBatch = 0;
                    }
                } elseif ($result === 'not_found') {
                    $io->writeln(sprintf('<comment>Find with ID %d not found in database</comment>', $findId));
                    $stats['not_found']++;
                }
            } catch (\Exception $e) {
                $io->writeln(sprintf('<error>Error updating find ID %d: %s</error>', $findId, $e->getMessage()));
                $stats['errors']++;
            }

            $io->progressAdvance();
        }

        // Final flush
        if (!$dryRun && $processedInBatch > 0) {
            $this->entityManager->flush();
        }

        $io->progressFinish();
        fclose($handle);

        return $stats;
    }

    private function processXmlFile(string $filePath, SymfonyStyle $io, bool $dryRun, int $batchSize, bool $setEmptyToNull): array
    {
        $stats = ['processed' => 0, 'updated' => 0, 'not_found' => 0, 'skipped' => 0, 'errors' => 0];
        
        // Load XML file
        libxml_use_internal_errors(true);
        $xml = simplexml_load_file($filePath);
        
        if ($xml === false) {
            $errors = libxml_get_errors();
            $errorMessages = array_map(function($error) {
                return sprintf('Line %d: %s', $error->line, trim($error->message));
            }, $errors);
            libxml_clear_errors();
            throw new \RuntimeException('Unable to parse XML file: ' . implode(', ', $errorMessages));
        }

        // FileMaker XML structure: FMPXMLRESULT/RESULTSET/ROW/COL
        // Get metadata (field names)
        $metadata = $xml->METADATA ?? $xml->metadata;
        if (!$metadata) {
            throw new \RuntimeException('Invalid FileMaker XML: Missing METADATA section');
        }

        $fieldNames = [];
        foreach ($metadata->FIELD ?? $metadata->field as $field) {
            $fieldNames[] = $this->normalizeFieldName((string) $field['NAME'] ?? (string) $field['name']);
        }

        // Verify 'id' field exists
        if (!in_array('id', $fieldNames)) {
            throw new \RuntimeException('XML file must contain an "id" field');
        }

        // Process each record
        $resultset = $xml->RESULTSET ?? $xml->resultset;
        if (!$resultset) {
            throw new \RuntimeException('Invalid FileMaker XML: Missing RESULTSET section');
        }

        $io->progressStart();
        $processedInBatch = 0;

        foreach ($resultset->ROW ?? $resultset->row as $row) {
            $stats['processed']++;
            
            $data = [];
            $colIndex = 0;
            
            foreach ($row->COL ?? $row->col as $col) {
                if (isset($fieldNames[$colIndex])) {
                    $fieldName = $fieldNames[$colIndex];
                    $value = (string) ($col->DATA ?? $col->data ?? '');
                    $data[$fieldName] = $value;
                }
                $colIndex++;
            }

            if (!isset($data['id']) || trim($data['id']) === '') {
                $io->writeln(sprintf('<comment>Skipping row %d: Missing ID</comment>', $stats['processed']));
                $stats['skipped']++;
                continue;
            }

            $findId = (int) $data['id'];
            
            // Validate tm field if present
            if (isset($data['tm']) && trim($data['tm']) !== '') {
                // Check for special values
                if (stripos($data['tm'], 'SKIPPED') !== false || stripos($data['tm'], 'NOT FOUND') !== false) {
                    $io->writeln(sprintf('<comment>Skipping find ID %d: Marked as skipped/not found</comment>', $findId));
                    $stats['skipped']++;
                    continue;
                }
                
                // Check if tm is a valid positive integer
                if (!ctype_digit(trim($data['tm'])) || (int) $data['tm'] <= 0) {
                    $io->writeln(sprintf('<comment>Skipping find ID %d: tm value "%s" is not a valid positive integer</comment>', $findId, $data['tm']));
                    $stats['skipped']++;
                    continue;
                }
            }

            try {
                $result = $this->updateFind($findId, $data, $dryRun, $setEmptyToNull);
                
                if ($result === 'updated') {
                    $stats['updated']++;
                    $processedInBatch++;
                    
                    if (!$dryRun && $processedInBatch >= $batchSize) {
                        $this->entityManager->flush();
                        $this->entityManager->clear();
                        $processedInBatch = 0;
                    }
                } elseif ($result === 'not_found') {
                    $io->writeln(sprintf('<comment>Find with ID %d not found in database</comment>', $findId));
                    $stats['not_found']++;
                }
            } catch (\Exception $e) {
                $io->writeln(sprintf('<error>Error updating find ID %d: %s</error>', $findId, $e->getMessage()));
                $stats['errors']++;
            }

            $io->progressAdvance();
        }

        // Final flush
        if (!$dryRun && $processedInBatch > 0) {
            $this->entityManager->flush();
        }

        $io->progressFinish();

        return $stats;
    }

    private function updateFind(int $findId, array $data, bool $dryRun, bool $setEmptyToNull): string
    {
        $find = $this->findRepository->find($findId);
        
        if (!$find) {
            return 'not_found';
        }

        $updatedFields = 0;
        
        // Update fields based on data
        foreach ($data as $fieldName => $value) {
            // Skip the ID field itself
            if ($fieldName === 'id') {
                continue;
            }

            // Check if field name ends with + (append mode)
            $appendMode = false;
            $actualFieldName = $fieldName;
            if (substr($fieldName, -1) === '+') {
                $appendMode = true;
                $actualFieldName = substr($fieldName, 0, -1);
            }

            $isEmpty = ($value === null || trim($value) === '');
            
            // Skip empty values unless setEmptyToNull is enabled
            if ($isEmpty && !$setEmptyToNull) {
                continue;
            }

            // Convert field name to setter/getter methods
            $setterMethod = 'set' . ucfirst($actualFieldName);
            $getterMethod = 'get' . ucfirst($actualFieldName);
            
            if (method_exists($find, $setterMethod)) {
                // Handle type conversions
                if ($isEmpty && $setEmptyToNull) {
                    // Set to null
                    $find->$setterMethod(null);
                } else {
                    if ($appendMode && method_exists($find, $getterMethod)) {
                        // Append mode: get existing value and append new value if not already present
                        $existingValue = $find->$getterMethod();
                        $newValue = $this->appendValue($existingValue, $value);
                        $find->$setterMethod($newValue);
                    } else {
                        // Replace mode: convert and set value
                        $convertedValue = $this->convertValue($actualFieldName, $value);
                        $find->$setterMethod($convertedValue);
                    }
                }
                $updatedFields++;
            }
        }

        if (!$dryRun && $updatedFields > 0) {
            $this->entityManager->persist($find);
        }

        return 'updated';
    }

    private function normalizeFieldName(string $fieldName): string
    {
        // Convert field name to camelCase
        // Example: "inventory_number" -> "inventoryNumber"
        // Example: "tm" -> "tm"
        // Example: "special_publication_notes" -> "specialPublicationNotes"
        
        $fieldName = trim($fieldName);
        
        // Handle snake_case
        if (strpos($fieldName, '_') !== false) {
            $parts = explode('_', $fieldName);
            $camelCase = array_shift($parts);
            foreach ($parts as $part) {
                $camelCase .= ucfirst(strtolower($part));
            }
            return $camelCase;
        }
        
        return lcfirst($fieldName);
    }

    private function convertValue(string $fieldName, string $value)
    {
        // Handle special conversions based on field name
        switch ($fieldName) {
            case 'tm':
            case 'heidiconId':
            case 'heidiconSystemObjectId':
            case 'year':
            case 'month':
                // Convert to integer, return null if invalid
                if (is_numeric($value)) {
                    return (int) $value;
                }
                return null;

            case 'date':
            case 'created':
            case 'modified':
                // Convert to DateTime
                try {
                    return new \DateTime($value);
                } catch (\Exception $e) {
                    return null;
                }

            default:
                // Return as string
                return $value;
        }
    }

    private function appendValue(?string $existingValue, string $newValue): string
    {
        // If existing value is null or empty, just return the new value
        if ($existingValue === null || trim($existingValue) === '') {
            return $newValue;
        }

        // Trim both values
        $existingValue = trim($existingValue);
        $newValue = trim($newValue);

        // If new value is empty, return existing value
        if ($newValue === '') {
            return $existingValue;
        }

        // Check if new value is already part of existing value
        if (stripos($existingValue, $newValue) !== false) {
            // New value already exists, return existing value unchanged
            return $existingValue;
        }

        // Append new value with separator
        return $existingValue . '; ' . $newValue;
    }
}
