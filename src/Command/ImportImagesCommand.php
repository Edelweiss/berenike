<?php

namespace App\Command;

use App\Entity\Image;
use App\Entity\ImageSpecialist;
use App\Repository\FindRepository;
use App\Repository\SpecialistRepository;
use App\Service\ImageService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Helper\ProgressBar;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

/**
 * Import legacy images into the asset management system.
 * 
 * Usage:
 *   bin/console app:import-images <source-dir> <image-csv> <find-image-csv> [--dry-run] [--batch-size=100]
 * 
 * Specification: docs/concept/asset_manager.md
 */
class ImportImagesCommand extends Command
{
    protected static $defaultName = 'app:import-images';
    protected static $defaultDescription = 'Import legacy images into the asset management system';

    private EntityManagerInterface $entityManager;
    private FindRepository $findRepository;
    private SpecialistRepository $specialistRepository;
    private ImageService $imageService;

    public function __construct(
        EntityManagerInterface $entityManager,
        FindRepository $findRepository,
        SpecialistRepository $specialistRepository,
        ImageService $imageService
    ) {
        parent::__construct();
        $this->entityManager = $entityManager;
        $this->findRepository = $findRepository;
        $this->specialistRepository = $specialistRepository;
        $this->imageService = $imageService;
    }

    protected function configure(): void
    {
        $this
            ->addArgument('source-dir', InputArgument::REQUIRED, 'Directory containing source image files')
            ->addArgument('image-csv', InputArgument::REQUIRED, 'Path to image.csv file (image metadata)')
            ->addArgument('find-image-csv', InputArgument::REQUIRED, 'Path to find_image.csv file (find-image relationships)')
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Validate files, CSV data, and references without writing to database or file system')
            ->addOption('batch-size', 'b', InputOption::VALUE_REQUIRED, 'Number of records to process before clearing entity manager (memory management)', 100)
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        
        $sourceDir = (string) $input->getArgument('source-dir');
        $imageCsvPath = (string) $input->getArgument('image-csv');
        $findImageCsvPath = (string) $input->getArgument('find-image-csv');
        $dryRun = (bool) $input->getOption('dry-run');
        $batchSize = max(1, (int) $input->getOption('batch-size'));

        $io->title('Image Asset Import');
        
        // Validate inputs
        if (!is_dir($sourceDir)) {
            $io->error(sprintf('Source directory not found: %s', $sourceDir));
            return Command::FAILURE;
        }
        if (!file_exists($imageCsvPath)) {
            $io->error(sprintf('Image CSV not found: %s', $imageCsvPath));
            return Command::FAILURE;
        }
        if (!file_exists($findImageCsvPath)) {
            $io->error(sprintf('Find-Image CSV not found: %s', $findImageCsvPath));
            return Command::FAILURE;
        }

        if ($dryRun) {
            $io->warning('DRY RUN MODE - No database or file system changes will be made');
        }

        $io->section('Loading CSV data');
        
        // Load image.csv
        $imageData = $this->loadImageCsv($imageCsvPath);
        $io->writeln(sprintf('Loaded %d image records from CSV', count($imageData)));
        
        // Load find_image.csv
        $findImageData = $this->loadFindImageCsv($findImageCsvPath);
        $io->writeln(sprintf('Loaded %d find-image relationships from CSV', count($findImageData)));
        
        // Build index: image_name => [find_ids]
        $imageToFinds = [];
        foreach ($findImageData as $row) {
            $imageName = $row['image_name'];
            $findId = $row['find_id'];
            if (!isset($imageToFinds[$imageName])) {
                $imageToFinds[$imageName] = [];
            }
            $imageToFinds[$imageName][] = $findId;
        }

        $io->section('Processing images');
        
        $stats = [
            'total' => count($imageData),
            'processed' => 0,
            'skipped_existing' => 0,
            'skipped_no_file' => 0,
            'skipped_no_specialist' => 0,
            'skipped_no_finds' => 0,
            'images_created' => 0,
            'images_updated' => 0,
            'files_processed' => 0,
            'errors' => 0,
        ];
        
        $warnings = [];
        $errors = [];
        
        $progressBar = new ProgressBar($output, $stats['total']);
        $progressBar->setFormat('verbose');
        $progressBar->start();
        
        $operationCount = 0;
        
        foreach ($imageData as $imageName => $imageInfo) {
            $progressBar->advance();
            
            try {
                $result = $this->processImage(
                    $imageName,
                    $imageInfo,
                    $imageToFinds[$imageName] ?? [],
                    $sourceDir,
                    $dryRun
                );
                
                $stats[$result['status']]++;
                $stats['processed']++;
                
                if (isset($result['warning'])) {
                    $warnings[] = $result['warning'];
                }
                
                // Memory management: clear entity manager every batch-size operations
                $operationCount++;
                if (!$dryRun && $operationCount % $batchSize === 0) {
                    $this->entityManager->flush();
                    $this->entityManager->clear();
                }
                
            } catch (\Exception $e) {
                $stats['errors']++;
                $errors[] = sprintf('%s: %s', $imageName, $e->getMessage());
            }
        }
        
        $progressBar->finish();
        $io->newLine(2);
        
        // Final flush
        if (!$dryRun && $operationCount % $batchSize !== 0) {
            $this->entityManager->flush();
        }
        
        // Display results
        $io->section('Import Summary');
        $io->table(
            ['Metric', 'Count'],
            [
                ['Total records', $stats['total']],
                ['Processed', $stats['processed']],
                ['Images created', $stats['images_created']],
                ['Images updated (existing)', $stats['images_updated']],
                ['Files processed', $stats['files_processed']],
                ['Skipped (already exists)', $stats['skipped_existing']],
                ['Skipped (no image file)', $stats['skipped_no_file']],
                ['Skipped (specialist not found)', $stats['skipped_no_specialist']],
                ['Skipped (no finds linked)', $stats['skipped_no_finds']],
                ['Errors', $stats['errors']],
            ]
        );
        
        if (!empty($warnings)) {
            $io->section(sprintf('Warnings (%d)', count($warnings)));
            foreach (array_slice($warnings, 0, 20) as $warning) {
                $io->writeln('  <comment>' . $warning . '</comment>');
            }
            if (count($warnings) > 20) {
                $io->writeln(sprintf('  ... and %d more warnings', count($warnings) - 20));
            }
        }
        
        if (!empty($errors)) {
            $io->section(sprintf('Errors (%d)', count($errors)));
            foreach (array_slice($errors, 0, 20) as $error) {
                $io->writeln('  <error>' . $error . '</error>');
            }
            if (count($errors) > 20) {
                $io->writeln(sprintf('  ... and %d more errors', count($errors) - 20));
            }
        }
        
        if ($dryRun) {
            $io->success('Dry run completed successfully. No changes were made.');
        } else {
            $io->success('Import completed.');
        }
        
        return $stats['errors'] > 0 ? Command::FAILURE : Command::SUCCESS;
    }

    /**
     * Load and parse image.csv
     * Returns array: image_name => [type, number, heidICON_id, heidICON_uuid, heidICON_system_object_id, specialist_gnd, year, speciality]
     */
    private function loadImageCsv(string $csvPath): array
    {
        $data = [];
        $handle = fopen($csvPath, 'r');
        if ($handle === false) {
            throw new \RuntimeException(sprintf('Failed to open CSV file: %s', $csvPath));
        }
        
        // Read header
        $header = fgetcsv($handle);
        if ($header === false) {
            fclose($handle);
            throw new \RuntimeException('CSV file is empty');
        }
        
        // Build column index
        $columns = array_flip($header);
        
        while (($row = fgetcsv($handle)) !== false) {
            $imageName = $row[$columns['image_name']] ?? null;
            if (empty($imageName)) {
                continue;
            }
            
            $data[$imageName] = [
                'type' => $row[$columns['type']] ?? 'photo',
                'number' => !empty($row[$columns['number'] ?? null]) ? $row[$columns['number']] : null,
                'heidICON_id' => !empty($row[$columns['heidICON_id'] ?? null]) ? (int)$row[$columns['heidICON_id']] : null,
                'heidICON_uuid' => !empty($row[$columns['heidICON_uuid'] ?? null]) ? $row[$columns['heidICON_uuid']] : null,
                'heidICON_system_object_id' => !empty($row[$columns['heidICON_system_object_id'] ?? null]) ? (int)$row[$columns['heidICON_system_object_id']] : null,
                'specialist_gnd' => $row[$columns['specialist_gnd']] ?? null,
                'year' => !empty($row[$columns['year'] ?? null]) ? (int)$row[$columns['year']] : null,
                'speciality' => !empty($row[$columns['speciality'] ?? null]) ? $row[$columns['speciality']] : null,
            ];
        }
        
        fclose($handle);
        return $data;
    }

    /**
     * Load and parse find_image.csv
     * Returns array of [find_id, image_name]
     */
    private function loadFindImageCsv(string $csvPath): array
    {
        $data = [];
        $handle = fopen($csvPath, 'r');
        if ($handle === false) {
            throw new \RuntimeException(sprintf('Failed to open CSV file: %s', $csvPath));
        }
        
        // Read header
        $header = fgetcsv($handle);
        if ($header === false) {
            fclose($handle);
            throw new \RuntimeException('CSV file is empty');
        }
        
        $columns = array_flip($header);
        
        while (($row = fgetcsv($handle)) !== false) {
            $findId = isset($row[$columns['find_id']]) ? (int)$row[$columns['find_id']] : null;
            $imageName = $row[$columns['image_name']] ?? null;
            
            if ($findId && $imageName) {
                $data[] = [
                    'find_id' => $findId,
                    'image_name' => $imageName,
                ];
            }
        }
        
        fclose($handle);
        return $data;
    }

    /**
     * Process a single image
     */
    private function processImage(
        string $imageName,
        array $imageInfo,
        array $findIds,
        string $sourceDir,
        bool $dryRun
    ): array {
        // Generate asset_key
        $assetKey = $this->imageService->generateAssetKey($imageName);
        
        // Find source file
        $sourceFile = $sourceDir . '/' . $imageName;
        if (!file_exists($sourceFile)) {
            return [
                'status' => 'skipped_no_file',
                'warning' => sprintf('Image file not found: %s', $imageName),
            ];
        }
        
        // Check if no finds are linked
        if (empty($findIds)) {
            return [
                'status' => 'skipped_no_finds',
                'warning' => sprintf('No finds linked to image: %s', $imageName),
            ];
        }
        
        // Resolve specialist
        $specialist = null;
        if (!$dryRun && !empty($imageInfo['specialist_gnd'])) {
            // Add https:// prefix if not present
            $gnd = $imageInfo['specialist_gnd'];
            if (strpos($gnd, 'http') !== 0) {
                $gnd = 'https://' . $gnd;
            }
            $specialist = $this->specialistRepository->findOneBy(['gnd' => $gnd]);
            
            if ($specialist === null) {
                return [
                    'status' => 'skipped_no_specialist',
                    'warning' => sprintf('Specialist not found for GND: %s (image: %s)', $imageInfo['specialist_gnd'], $imageName),
                ];
            }
        }
        
        // Check if image already exists in database by asset_key
        $existingImage = null;
        $isUpdate = false;
        
        if (!$dryRun) {
            $existingImage = $this->entityManager->getRepository(Image::class)
                ->findOneBy(['assetKey' => $assetKey]);
        }
        
        if ($existingImage) {
            $image = $existingImage;
            $isUpdate = true;
            
            // Check if asset files exist
            if ($this->imageService->assetExists($assetKey)) {
                // Files already exist, just link to finds
                if (!$dryRun) {
                    foreach ($findIds as $findId) {
                        $find = $this->findRepository->find($findId);
                        if ($find && !$image->getFinds()->contains($find)) {
                            $image->addFind($find);
                        }
                    }
                }
                
                return [
                    'status' => 'skipped_existing',
                    'warning' => sprintf('Image already exists with files: %s', $imageName),
                ];
            }
        } else {
            // Create new image entity
            $image = new Image();
        }
        
        // Set image properties
        $image->setAssetKey($assetKey);
        $image->setType($imageInfo['type'] ?? 'photo');
        $image->setNumber($imageInfo['number']);
        $image->setHeidiconId($imageInfo['heidICON_id']);
        $image->setHeidiconUuid($imageInfo['heidICON_uuid']);
        $image->setHeidiconSystemObjectId($imageInfo['heidICON_system_object_id']);
        
        // Legacy fields (kept for compatibility)
        $image->setFile($imageName);
        $image->setPath($assetKey); // Store asset_key in path field
        
        if (!$dryRun) {
            // Process image files
            try {
                $dimensions = $this->imageService->processImage($sourceFile, $assetKey);
                $image->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));
            } catch (\Exception $e) {
                throw new \RuntimeException(sprintf('Failed to process image file: %s', $e->getMessage()));
            }
            
            // Link to finds
            foreach ($findIds as $findId) {
                $find = $this->findRepository->find($findId);
                if ($find) {
                    $image->addFind($find);
                } else {
                    throw new \RuntimeException(sprintf('Find not found: %d', $findId));
                }
            }
            
            // Link specialist
            if ($specialist) {
                $imageSpecialist = new ImageSpecialist();
                $imageSpecialist->setImage($image);
                $imageSpecialist->setSpecialist($specialist);
                $imageSpecialist->setYear($imageInfo['year']);
                $imageSpecialist->setSpeciality($imageInfo['speciality']);
                
                $image->addImageSpecialist($imageSpecialist);
                $this->entityManager->persist($imageSpecialist);
            }
            
            $this->entityManager->persist($image);
        } else {
            // Dry run: just get dimensions for validation
            $dimensions = $this->imageService->getImageDimensions($sourceFile);
            $image->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));
        }
        
        return [
            'status' => $isUpdate ? 'images_updated' : 'images_created',
        ];
    }
}
