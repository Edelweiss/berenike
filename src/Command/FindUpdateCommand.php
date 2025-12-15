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

class FindUpdateCommand extends Command
{
    protected static $defaultName = 'find:update';
    protected static $defaultDescription = 'Update find records from a CSV or FileMaker XML file';
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
                // Check if EntityManager is closed and skip if so
                if (!$this->entityManager->isOpen()) {
                    $io->writeln(sprintf('<error>EntityManager is closed, skipping find ID %d</error>', $findId));
                    $stats['errors']++;
                    continue;
                }
                
                $result = $this->updateFind($findId, $data, $dryRun, $setEmptyToNull, $io);
                
                if ($result === 'updated') {
                    $stats['updated']++;
                    $processedInBatch++;
                    
                    // Flush in batches for better performance
                    if (!$dryRun && $processedInBatch >= $batchSize) {
                        try {
                            $this->entityManager->flush();
                            $this->entityManager->clear();
                            $processedInBatch = 0;
                        } catch (\Exception $e) {
                            $io->writeln(sprintf('<error>Error flushing batch at find ID %d: %s</error>', $findId, $e->getMessage()));
                            $stats['errors']++;
                            // EntityManager might be closed, can't continue
                            throw $e;
                        }
                    }
                } elseif ($result === 'not_found') {
                    $io->writeln(sprintf('<comment>Find with ID %d not found in database</comment>', $findId));
                    $stats['not_found']++;
                }
            } catch (\Exception $e) {
                $io->writeln(sprintf('<error>Error updating find ID %d: %s</error>', $findId, $e->getMessage()));
                $stats['errors']++;
                
                // If EntityManager is closed, we can't continue
                if (!$this->entityManager->isOpen()) {
                    $io->error('EntityManager has been closed due to an error. Cannot continue processing.');
                    break;
                }
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
                // Check if EntityManager is closed and skip if so
                if (!$this->entityManager->isOpen()) {
                    $io->writeln(sprintf('<error>EntityManager is closed, skipping find ID %d</error>', $findId));
                    $stats['errors']++;
                    continue;
                }
                
                $result = $this->updateFind($findId, $data, $dryRun, $setEmptyToNull, $io);

                if ($result === 'updated') {
                    $stats['updated']++;
                    $processedInBatch++;

                    if (!$dryRun && $processedInBatch >= $batchSize) {
                        try {
                            $this->entityManager->flush();
                            $this->entityManager->clear();
                            $processedInBatch = 0;
                        } catch (\Exception $e) {
                            $io->writeln(sprintf('<error>Error flushing batch at find ID %d: %s</error>', $findId, $e->getMessage()));
                            $stats['errors']++;
                            // EntityManager might be closed, can't continue
                            throw $e;
                        }
                    }
                } elseif ($result === 'not_found') {
                    $io->writeln(sprintf('<comment>Find with ID %d not found in database</comment>', $findId));
                    $stats['not_found']++;
                }
            } catch (\Exception $e) {
                $io->writeln(sprintf('<error>Error updating find ID %d: %s</error>', $findId, $e->getMessage()));
                $stats['errors']++;
                
                // If EntityManager is closed, we can't continue
                if (!$this->entityManager->isOpen()) {
                    $io->error('EntityManager has been closed due to an error. Cannot continue processing.');
                    break;
                }
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

    private function updateFind(int $findId, array $data, bool $dryRun, bool $setEmptyToNull, ?SymfonyStyle $io = null): string
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

            // Sanitize the value before processing
            $value = $this->sanitizeValue($value, $actualFieldName);
            
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
                    // Set to null only if current value is not null
                    if (method_exists($find, $getterMethod)) {
                        $currentValue = $find->$getterMethod();
                        if ($currentValue !== null) {
                            $find->$setterMethod(null);
                            $updatedFields++;
                        }
                    } else {
                        $find->$setterMethod(null);
                        $updatedFields++;
                    }
                } else {
                    if ($appendMode && method_exists($find, $getterMethod)) {
                        // Append mode: get existing value and append new value if not already present
                        $existingValue = $find->$getterMethod();
                        $newValue = $this->appendValue($existingValue, $value);
                        if ($newValue !== $existingValue) {
                            $find->$setterMethod($newValue);
                            $updatedFields++;
                        }
                    } else {
                        // Special handling for incomplete dates
                        if ($actualFieldName === 'date') {
                            $this->handleDateField($find, $value, $io);
                            $updatedFields++;
                        } else {
                            // Replace mode: convert and set value
                            $convertedValue = $this->convertValue($actualFieldName, $value);
                            
                            // Validate and truncate string values if needed
                            if (is_string($convertedValue)) {
                                $convertedValue = $this->validateAndTruncateField($actualFieldName, $convertedValue, $findId, $io);
                            }
                            
                            // Only update if value has changed
                            if (method_exists($find, $getterMethod)) {
                                $currentValue = $find->$getterMethod();
                                // Handle DateTime comparison specially
                                if ($convertedValue instanceof \DateTime && $currentValue instanceof \DateTime) {
                                    if ($convertedValue->format('Y-m-d H:i:s') !== $currentValue->format('Y-m-d H:i:s')) {
                                        $find->$setterMethod($convertedValue);
                                        $updatedFields++;
                                    }
                                } elseif ($convertedValue !== $currentValue) {
                                    $find->$setterMethod($convertedValue);
                                    $updatedFields++;
                                }
                            } else {
                                $find->$setterMethod($convertedValue);
                                $updatedFields++;
                            }
                        }
                    }
                }
            }
        }

        // If the date field in $data was not empty, but could not be fully parsed, append the original value to dateRemarks
        if (isset($data['date']) && trim($data['date']) !== '' && $find->getDate() === null) {
            $this->appendToDateRemarks($find, $data['date']);
        }

        if (!$dryRun && $updatedFields > 0) {
            try {
                $this->entityManager->persist($find);
            } catch (\Exception $e) {
                // Re-throw to be handled by the calling method
                throw new \RuntimeException(sprintf('Failed to persist find ID %d: %s', $findId, $e->getMessage()), 0, $e);
            }
        }

        return 'updated';
    }
    
    /**
     * Validate and truncate field value if it exceeds the maximum length
     * Field length limits from Find.orm.xml
     */
    private function validateAndTruncateField(string $fieldName, string $value, int $findId, ?SymfonyStyle $io = null): string
    {
        // Field length limits from database schema
        $fieldLengths = [
            'inventoryNumber' => 255,
            'heidiconUuid' => 255,
            'trench' => 10,
            'dateRemarks' => 255,
            'scaRegister' => 16,
            'object' => 64,
            'objectNo' => 64,
            'category' => 255,
            'categoryNo' => 64,
            'weight' => 64,
            'quantity' => 64,
            'dimensions' => 255,
            'preservation' => 255,
            'description' => 65535, // TEXT type
            'material' => 255,
            'materialRemarks' => 255,
            'datingAbsolute' => 255,
            'typologyReference' => 255,
            'publications' => 65535, // TEXT type
            'remarks' => 65535, // TEXT type
            'rebuildChanges' => 65535, // TEXT type
        ];
        
        if (!isset($fieldLengths[$fieldName])) {
            // Unknown field, return as-is
            return $value;
        }
        
        $maxLength = $fieldLengths[$fieldName];
        $actualLength = mb_strlen($value, 'UTF-8');
        
        if ($actualLength > $maxLength) {
            $truncated = mb_substr($value, 0, $maxLength, 'UTF-8');
            if ($io) {
                $io->writeln(sprintf(
                    '<comment>Field "%s" truncated from %d to %d chars for find ID %d: "%s" → "%s"</comment>',
                    $fieldName,
                    $actualLength,
                    $maxLength,
                    $findId,
                    mb_substr($value, 0, 50, 'UTF-8') . '...',
                    mb_substr($truncated, 0, 50, 'UTF-8') . '...'
                ), OutputInterface::VERBOSITY_VERBOSE);
            }
            return $truncated;
        }
        
        return $value;
    }
    
    /**
     * Handle date field with support for incomplete dates
     * - Full date: 2009-01-29 -> setDate() (also sets year and month)
     * - Year-month only: 2009-01 -> setYear() + setMonth()
     * - Year only: 2009 -> setYear() only
     * - Uncertain dates: 1996-0x-xx, 1997-01-?? -> extract what's valid
     * - Invalid: return without changes
     */
    private function handleDateField(Find $find, string $value, ?SymfonyStyle $io = null): void
    {
        $value = trim($value);
        
        if ($value === '') {
            return;
        }
        
        // Try to parse as complete date first
        $dateInfo = $this->parseDateValue($value);
        
        if ($dateInfo === null) {
            // Completely invalid date
            $find->setDate(null);
            if ($io) {
                $io->writeln(sprintf('<comment>Skipping invalid date value: "%s" for find ID %d</comment>', $value, $find->getId()), OutputInterface::VERBOSITY_VERBOSE);
            }
            return;
        }
        
        // If we have a complete date (year, month, day), use setDate
        if ($dateInfo['complete']) {
            try {
                $date = new \DateTime(sprintf('%04d-%02d-%02d', $dateInfo['year'], $dateInfo['month'], $dateInfo['day']));
                $find->setDate($date);
            } catch (\Exception $e) {
                if ($io) {
                    $io->writeln(sprintf('<comment>Failed to create date from "%s": %s</comment>', $value, $e->getMessage()), OutputInterface::VERBOSITY_VERBOSE);
                }
            }
        } else {
            // Incomplete date - set year and/or month directly
            $find->setDate(null);
            if ($dateInfo['year'] !== null) {
                $find->setYear($dateInfo['year']);
            }
            if ($dateInfo['month'] !== null) {
                $find->setMonth($dateInfo['month']);
            }
            if ($io) {
                $io->writeln(sprintf('<comment>Incomplete date "%s": set year=%s, month=%s for find ID %d</comment>', 
                    $value, 
                    $dateInfo['year'] ?? 'null', 
                    $dateInfo['month'] ?? 'null',
                    $find->getId()
                ), OutputInterface::VERBOSITY_VERBOSE);
            }
        }
    }

    /**
     * Append a value to the dateRemarks field
     */
    private function appendToDateRemarks(Find $find, string $value): void
    {
        $existing = $find->getDateRemarks();
        if ($existing === null || trim($existing) === '') {
            $find->setDateRemarks($value);
        } else {
            // Check if value is already present
            if (stripos($existing, $value) === false) {
                $find->setDateRemarks($existing . '; ' . $value);
            }
        }
    }

    /**
     * Parse a date value and return structured info about what was extracted
     * Returns null if completely invalid, otherwise an array with:
     * - 'complete' => bool (whether all parts are valid)
     * - 'year' => int|null
     * - 'month' => int|null  
     * - 'day' => int|null
     */
    private function parseDateValue(string $value): ?array
    {
        $value = trim($value);
        
        // Reject obviously invalid values
        if ($value === '' || preg_match('/^[a-z]+$/i', $value) || $value === '000') {
            return null;
        }
        
        // Try standard ISO format: YYYY-MM-DD or YYYY_MM_DD
        // Also handles dates with 00 for invalid month/day (e.g., 2003-00-00)
        if (preg_match('/^(\d{4})[-_](\d{2})[-_](\d{2})$/', $value, $matches)) {
            $year = (int) $matches[1];
            $month = (int) $matches[2];
            $day = (int) $matches[3];
            
            $validYear = ($year >= 1990 && $year <= 2100);
            $validMonth = ($month >= 1 && $month <= 12);
            $validDay = ($day >= 1 && $day <= 31);
            
            if ($validYear && $validMonth && $validDay) {
                return ['complete' => true, 'year' => $year, 'month' => $month, 'day' => $day];
            }
            
            // Handle incomplete dates with 00 values (e.g., 2003-00-00, 2003-01-00)
            if ($validYear) {
                return [
                    'complete' => false, 
                    'year' => $year, 
                    'month' => $validMonth ? $month : null, 
                    'day' => $validDay ? $day : null
                ];
            }
        }
        
        // Try DD-MM-YY format: 31-12-13
        if (preg_match('/^(\d{2})-(\d{2})-(\d{2})$/', $value, $matches)) {
            $day = (int) $matches[1];
            $month = (int) $matches[2];
            $year = (int) $matches[3];
            // Assume 20xx for years 00-30, 19xx for 31-99
            $year = $year <= 30 ? 2000 + $year : 1900 + $year;
            
            if ($month >= 1 && $month <= 12 && $day >= 1 && $day <= 31) {
                return ['complete' => true, 'year' => $year, 'month' => $month, 'day' => $day];
            }
        }
        
        // Try year-only: 1996, 2020
        if (preg_match('/^(\d{4})$/', $value, $matches)) {
            $year = (int) $matches[1];
            if ($year >= 1990 && $year <= 2100) {
                return ['complete' => false, 'year' => $year, 'month' => null, 'day' => null];
            }
        }
        
        // Try year-month only: 2009-01 or 2009_01
        if (preg_match('/^(\d{4})[-_](\d{1,2})$/', $value, $matches)) {
            $year = (int) $matches[1];
            $month = (int) $matches[2];
            if ($year >= 1990 && $year <= 2100 && $month >= 1 && $month <= 12) {
                return ['complete' => false, 'year' => $year, 'month' => $month, 'day' => null];
            }
        }
        
        // Try uncertain dates with ? or x placeholders: 1996-0x-xx, 1997-01-??, 2015-01-??
        if (preg_match('/^(\d{4})[-_](\d{1,2}|[x?]+)[-_](\d{1,2}|[x?]+)$/i', $value, $matches)) {
            $year = (int) $matches[1];
            $monthPart = $matches[2];
            $dayPart = $matches[3];
            
            // Check if month is valid number
            $month = null;
            if (preg_match('/^\d{1,2}$/', $monthPart)) {
                $monthNum = (int) $monthPart;
                if ($monthNum >= 1 && $monthNum <= 12) {
                    $month = $monthNum;
                }
            }
            
            // Check if day is valid number
            $day = null;
            if (preg_match('/^\d{1,2}$/', $dayPart)) {
                $dayNum = (int) $dayPart;
                if ($dayNum >= 1 && $dayNum <= 31) {
                    $day = $dayNum;
                }
            }
            
            if ($year >= 1990 && $year <= 2100) {
                return [
                    'complete' => ($month !== null && $day !== null),
                    'year' => $year,
                    'month' => $month,
                    'day' => $day
                ];
            }
        }
        
        // Try typo with extra digit: 2014-015-15 -> extract year only
        if (preg_match('/^(\d{4})-\d{3,}-\d+$/', $value, $matches)) {
            $year = (int) $matches[1];
            if ($year >= 1990 && $year <= 2100) {
                return ['complete' => false, 'year' => $year, 'month' => null, 'day' => null];
            }
        }
        
        return null;
    }

    /**
     * Sanitize values from FileMaker exports
     * - Clean up date formats (underscores to hyphens)
     * - Remove leading/trailing whitespace and apostrophes
     * - Clean up extra whitespace
     */
    private function sanitizeValue(string $value, string $fieldName): string
    {
        // Trim whitespace
        $value = trim($value);
        
        // Remove leading/trailing apostrophes (common in FileMaker text fields)
        $value = trim($value, "'\"");
        
        // Additional trim after removing quotes
        $value = trim($value);
        
        // Date field sanitization
        if (in_array($fieldName, ['date', 'created', 'modified'])) {
            // Replace underscores with hyphens in dates (e.g., 2009_01_29 -> 2009-01-29)
            $value = str_replace('_', '-', $value);
            
            // Handle various date separators (dots, slashes) and convert to ISO format
            // Pattern: DD.MM.YYYY or D.M.YYYY
            if (preg_match('/^(\d{1,2})\.(\d{1,2})\.(\d{4})$/', $value, $matches)) {
                $value = sprintf('%04d-%02d-%02d', $matches[3], $matches[2], $matches[1]);
            }
            // Pattern: DD/MM/YYYY or D/M/YYYY
            elseif (preg_match('/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/', $value, $matches)) {
                $value = sprintf('%04d-%02d-%02d', $matches[3], $matches[2], $matches[1]);
            }
        }
        
        // Normalize whitespace
        // Replace multiple newlines with single newline
        $value = preg_replace('/\n+/', "\n", $value);
        // Replace multiple spaces and tabs with single space (but preserve newlines)
        $value = preg_replace('/[ \t]+/', ' ', $value);
        
        // Final trim
        $value = trim($value);
        
        return $value;
    }

    /*
All FileMaker fields (for reference):
id
PB_Id
trench2
date
SCA Register
object id
object no
category
category no
weight
quantity
dimensions
preservation
description
material
material remarks
dating absolute
typology reference
publications
remarks
rebuild_changes
Created
Modified
    */
    private function normalizeFieldName(string $fieldName): string
    {
        // Convert field name to camelCase
        // Example: "Inventory Number" -> "inventoryNumber"
        // Example: "object_id" -> "objectId"
        // Example: "tm" -> "tm"
        // Example: "SCA Register" -> "scaRegister"

        $fieldName = trim($fieldName);

        // Handle FileMaker-specific field mappings
        $fileMakerMappings = [
            'trench2' => 'trench',
            'object id' => 'object',
            'PB_Id' => 'bucketId'
        ];

        if (isset($fileMakerMappings[$fieldName])) {
            return $fileMakerMappings[$fieldName];
        }

        // Replace both underscores and spaces with underscores for uniform processing
        $fieldName = str_replace(' ', '_', $fieldName);
        // Convert to lowercase and then to camelCase
        $fieldName = strtolower($fieldName);
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
