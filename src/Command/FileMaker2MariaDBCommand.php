<?php

/**
 * FileMaker XML to MariaDB Import Command
 * 
 * This command imports FileMaker XML dumps into a new MariaDB table.
 * 
 * Usage:
 *   php bin/console filemaker:import <xml-file> <table-name>
 * 
 * Example:
 *   php bin/console filemaker:import fmp/finds_2.xml finds_import
 * 
 * The command will:
 * - Parse the XML file to detect field names
 * - Create a new table (dropping if it exists)
 * - Set id and pb_id fields as INT
 * - Set Created and Modified fields as TIMESTAMP
 * - Set all other fields as TEXT
 * - Import all records in batches of 100
 */

namespace App\Command;

use Doctrine\DBAL\Connection;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

class FileMaker2MariaDBCommand extends Command
{
    protected static $defaultName = 'filemaker:import';
    protected static $defaultDescription = 'Import FileMaker XML data into a new MariaDB table';
    
    private $connection;

    public function __construct(Connection $connection)
    {
        parent::__construct();
        $this->connection = $connection;
    }

    protected function configure()
    {
        $this
            ->addArgument('xml-file', InputArgument::REQUIRED, 'Path to FileMaker XML file (relative to data/ directory)')
            ->addArgument('table-name', InputArgument::REQUIRED, 'Name of the MariaDB table to create')
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $io = new SymfonyStyle($input, $output);
        $xmlFile = $input->getArgument('xml-file');
        $tableName = $input->getArgument('table-name');

        // Construct full file path
        $dataDir = dirname(__DIR__, 2) . '/data';
        $filePath = $dataDir . '/' . $xmlFile;

        // Validate file exists
        if (!file_exists($filePath)) {
            $io->error("File not found: {$filePath}");
            return Command::FAILURE;
        }

        $io->title('FileMaker to MariaDB Import');
        $io->text("File: {$filePath}");
        $io->text("Table: {$tableName}");

        try {
            // Parse XML file
            $io->section('Parsing XML file...');
            $xml = simplexml_load_file($filePath);
            
            if ($xml === false) {
                $io->error('Failed to parse XML file');
                return Command::FAILURE;
            }

            // Extract metadata (field definitions)
            $fields = [];
            foreach ($xml->METADATA->FIELD as $field) {
                $attributes = $field->attributes();
                $fieldName = (string) $attributes['NAME'];
                $fields[] = $fieldName;
            }

            $io->text("Found " . count($fields) . " fields");
            $io->listing($fields);

            // Drop table if exists and create new table
            $io->section('Creating table...');
            $this->connection->executeStatement("DROP TABLE IF EXISTS `{$tableName}`");

            $columnDefinitions = [];
            foreach ($fields as $field) {
                $columnName = $this->sanitizeColumnName($field);
                
                // Determine column type
                if (in_array(strtolower($field), ['id', 'pb_id'])) {
                    $columnDefinitions[] = "`{$columnName}` INT";
                } elseif (in_array($field, ['Created', 'Modified'])) {
                    $columnDefinitions[] = "`{$columnName}` TIMESTAMP NULL";
                } else {
                    $columnDefinitions[] = "`{$columnName}` TEXT";
                }
            }

            $createTableSQL = sprintf(
                "CREATE TABLE `%s` (\n    %s\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci",
                $tableName,
                implode(",\n    ", $columnDefinitions)
            );

            $this->connection->executeStatement($createTableSQL);
            $io->success("Table '{$tableName}' created successfully");

            // Import data
            $io->section('Importing data...');
            $recordCount = 0;
            $batchSize = 100;
            $batch = [];

            foreach ($xml->RESULTSET->ROW as $row) {
                $rowData = [];
                $colIndex = 0;
                
                foreach ($row->COL as $col) {
                    $fieldName = $fields[$colIndex];
                    $columnName = $this->sanitizeColumnName($fieldName);
                    $value = isset($col->DATA) ? (string) $col->DATA : null;
                    
                    // Handle empty strings
                    if ($value === '') {
                        $value = null;
                    }
                    
                    // Convert timestamps to proper format
                    if (in_array($fieldName, ['Created', 'Modified']) && $value !== null) {
                        // FileMaker timestamps are typically in format: "2023-01-30 02:11:29"
                        // MySQL accepts this format directly
                        $value = $value;
                    }
                    
                    $rowData[$columnName] = $value;
                    $colIndex++;
                }

                $batch[] = $rowData;
                
                if (count($batch) >= $batchSize) {
                    $this->insertBatch($tableName, $batch);
                    $recordCount += count($batch);
                    $io->text("Imported {$recordCount} records...");
                    $batch = [];
                }
            }

            // Insert remaining records
            if (!empty($batch)) {
                $this->insertBatch($tableName, $batch);
                $recordCount += count($batch);
            }

            $io->success("Successfully imported {$recordCount} records into table '{$tableName}'");
            return Command::SUCCESS;

        } catch (\Exception $e) {
            $io->error('Import failed: ' . $e->getMessage());
            $io->text('Stack trace: ' . $e->getTraceAsString());
            return Command::FAILURE;
        }
    }

    private function sanitizeColumnName($name)
    {
        // Replace spaces and special characters with underscores
        $sanitized = preg_replace('/[^a-zA-Z0-9_]/', '_', $name);
        // Remove consecutive underscores
        $sanitized = preg_replace('/_+/', '_', $sanitized);
        // Remove leading/trailing underscores
        $sanitized = trim($sanitized, '_');
        
        return $sanitized;
    }

    private function insertBatch($tableName, $batch)
    {
        if (empty($batch)) {
            return;
        }

        // Get column names from first row
        $columns = array_keys($batch[0]);
        $placeholders = [];
        $values = [];

        foreach ($batch as $row) {
            $rowPlaceholders = [];
            foreach ($columns as $column) {
                $rowPlaceholders[] = '?';
                $values[] = $row[$column];
            }
            $placeholders[] = '(' . implode(', ', $rowPlaceholders) . ')';
        }

        $sql = sprintf(
            "INSERT INTO `%s` (`%s`) VALUES %s",
            $tableName,
            implode('`, `', $columns),
            implode(', ', $placeholders)
        );

        $this->connection->executeStatement($sql, $values);
    }
}
