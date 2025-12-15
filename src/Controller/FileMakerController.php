<?php

namespace App\Controller;

use App\Repository\BucketRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;

/**
 * Wrapper class to make FileMaker data compatible with Find templates
 */
class FileMakerFind
{
    private $data;
    
    public function __construct(\stdClass $data)
    {
        $this->data = $data;
    }
    
    public function __get($name)
    {
        return $this->data->$name ?? null;
    }
    
    public function __isset($name)
    {
        return isset($this->data->$name);
    }
    
    public function __call($name, $arguments)
    {
        // Handle getter methods like getId(), getTm(), etc.
        if (strpos($name, 'get') === 0 && strlen($name) > 3) {
            $property = lcfirst(substr($name, 3));
            return $this->data->$property ?? null;
        }
        
        // For other method calls, try to return the property directly
        // This handles cases where Twig tries to call properties as methods
        if (isset($this->data->$name)) {
            return $this->data->$name;
        }
        
        return null;
    }
    
    public function thumbnailImage()
    {
        return null; // FileMaker data doesn't include images
    }
    
    public function getBucket()
    {
        return $this->data->bucket ?? null;
    }
    
    public function getFindSpecialists()
    {
        return []; // FileMaker data doesn't include specialists
    }
    
    public function getImages()
    {
        return []; // FileMaker data doesn't include images
    }
}

class FileMakerController extends BerenikeController
{
    private EntityManagerInterface $entityManager;
    private BucketRepository $bucketRepository;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        BucketRepository $bucketRepository
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->bucketRepository = $bucketRepository;
    }

    public function listFinds(Request $request): Response
    {
        $finds = [];
        
        if ($this->request->getMethod() == 'POST') {
            // REQUEST PARAMETERS
            $limit         = $this->getParameter('rows');
            $page          = $this->getParameter('page');
            $offset        = $page * $limit - $limit;
            $offset        = $offset < 0 ? 0 : $offset;
            $sort          = $this->getParameter('sidx');
            $sortDirection = $this->getParameter('sord');
            $visible       = explode(';', rtrim($this->getParameter('visible'), ';'));

            // Load and parse FileMaker XML
            $xmlFilePath = dirname(__DIR__, 2) . '/data/fmp/finds.xml';
            
            if (!file_exists($xmlFilePath)) {
                throw new \RuntimeException('FileMaker XML file not found: ' . $xmlFilePath);
            }

            $finds = $this->parseFileMakerXml($xmlFilePath);
            
            // Apply filtering if search is active
            if ($this->getParameter('_search') == 'true') {
                $finds = $this->filterFinds($finds);
            }

            // Apply sorting
            if ($sort) {
                $finds = $this->sortFinds($finds, $sort, $sortDirection);
            }

            // Calculate pagination
            $count = count($finds);
            $totalPages = ($count > 0 && $limit > 0) ? ceil($count / $limit) : 0;
            
            // Apply pagination
            $finds = array_slice($finds, $offset, $limit);

            return $this->render('filemaker/list.xml.twig', [
                'finds' => $finds,
                'count' => $count,
                'totalPages' => $totalPages,
                'page' => $page
            ]);
        } else {
            return $this->render('filemaker/list_finds.html.twig', ['finds' => $finds]);
        }
    }

    public function showFind($id): Response
    {
        $xmlFilePath = dirname(__DIR__, 2) . '/data/fmp/finds.xml';
        if (!file_exists($xmlFilePath)) {
            throw new \RuntimeException('FileMaker XML file not found: ' . $xmlFilePath);
        }
        
        // Load and parse XML
        libxml_use_internal_errors(true);
        $xml = simplexml_load_file($xmlFilePath);
        
        if ($xml === false) {
            $errors = libxml_get_errors();
            $errorMessages = array_map(function($error) {
                return sprintf('Line %d: %s', $error->line, trim($error->message));
            }, $errors);
            libxml_clear_errors();
            throw new \RuntimeException('Unable to parse XML file: ' . implode(', ', $errorMessages));
        }
        
        // Get metadata (field names)
        $metadata = $xml->METADATA ?? $xml->metadata;
        if (!$metadata) {
            throw new \RuntimeException('Invalid FileMaker XML: Missing METADATA section');
        }
        
        $fieldNames = [];
        foreach ($metadata->FIELD ?? $metadata->field as $field) {
            $fieldNames[] = (string) ($field['NAME'] ?? $field['name']);
        }
        
        // Find the record with matching ID
        $resultset = $xml->RESULTSET ?? $xml->resultset;
        if (!$resultset) {
            throw new \RuntimeException('Invalid FileMaker XML: Missing RESULTSET section');
        }
        
        $rawXmlRow = null;
        $recordData = [];
        
        foreach ($resultset->ROW ?? $resultset->row as $row) {
            $colIndex = 0;
            $currentId = null;
            
            foreach ($row->COL ?? $row->col as $col) {
                if (isset($fieldNames[$colIndex]) && strtolower($fieldNames[$colIndex]) === 'id') {
                    $currentId = (string) ($col->DATA ?? $col->data ?? '');
                    break;
                }
                $colIndex++;
            }
            
            if ($currentId == $id) {
                // Found the matching record
                $rawXmlRow = $row->asXML();
                
                // Format XML with proper indentation and add field name comments
                $dom = new \DOMDocument('1.0');
                $dom->preserveWhiteSpace = false;
                $dom->formatOutput = true;
                $dom->loadXML($rawXmlRow);
                
                // Add comments to identify each COL element by field name
                $xpath = new \DOMXPath($dom);
                $colNodes = $xpath->query('//COL | //col');
                $colIndex = 0;
                
                foreach ($colNodes as $colNode) {
                    if (isset($fieldNames[$colIndex])) {
                        $comment = $dom->createComment(' ' . $fieldNames[$colIndex] . ' ');
                        $colNode->parentNode->insertBefore($comment, $colNode);
                    }
                    $colIndex++;
                }
                
                $formattedXml = $dom->saveXML();
                
                // Build record data as array
                $colIndex = 0;
                foreach ($row->COL ?? $row->col as $col) {
                    if (isset($fieldNames[$colIndex])) {
                        $value = (string) ($col->DATA ?? $col->data ?? '');
                        $recordData[$fieldNames[$colIndex]] = $value;
                    }
                    $colIndex++;
                }
                break;
            }
        }
        
        if (!$rawXmlRow) {
            throw $this->createNotFoundException(sprintf('Find with ID %d not found in FileMaker data', $id));
        }
        
        return $this->render('filemaker/show_find.html.twig', [
            'id' => $id,
            'rawXml' => $formattedXml,
            'recordData' => $recordData,
            'fieldNames' => $fieldNames
        ]);
    }

    private function parseFileMakerXml(string $filePath): array
    {
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

        // Field name mappings
        $fieldMappings = [
            'trench2' => 'trench',
            'object id' => 'object',
            'object no' => 'objectNo',
            'material remarks' => 'materialRemarks',
            'typology reference' => 'typologyReference',
            'dating absolute' => 'datingAbsolute',
            'sca register' => 'scaRegister',
            'category no' => 'categoryNo',
            'pb_id' => 'pbId',
            'rebuild_changes' => 'rebuildChanges',
            'created' => 'created',
            'modified' => 'modified'
        ];

        // Get metadata (field names)
        $metadata = $xml->METADATA ?? $xml->metadata;
        if (!$metadata) {
            throw new \RuntimeException('Invalid FileMaker XML: Missing METADATA section');
        }

        $fieldNames = [];
        foreach ($metadata->FIELD ?? $metadata->field as $field) {
            $originalName = (string) ($field['NAME'] ?? $field['name']);
            $normalizedName = strtolower(trim($originalName));
            
            // Apply field mappings
            if (isset($fieldMappings[$normalizedName])) {
                $fieldNames[] = $fieldMappings[$normalizedName];
            } else {
                // Convert to camelCase
                $fieldNames[] = $this->toCamelCase($originalName);
            }
        }

        // Process each record
        $resultset = $xml->RESULTSET ?? $xml->resultset;
        if (!$resultset) {
            throw new \RuntimeException('Invalid FileMaker XML: Missing RESULTSET section');
        }

        $finds = [];
        foreach ($resultset->ROW ?? $resultset->row as $row) {
            $data = new \stdClass();
            $colIndex = 0;
            
            // First pass: collect all field values
            foreach ($row->COL ?? $row->col as $col) {
                if (isset($fieldNames[$colIndex])) {
                    $fieldName = $fieldNames[$colIndex];
                    $value = (string) ($col->DATA ?? $col->data ?? '');
                    // Convert value based on field type
                    $data->$fieldName = $this->convertValue($fieldName, $value);
                }
                $colIndex++;
            }
            
            // After all fields are processed, handle bucket
            if (isset($data->pbId) && $data->pbId > 0) {
                $bucket = $this->bucketRepository->find($data->pbId);
                if ($bucket) {
                    // Use the actual bucket entity from database
                    $data->bucket = $bucket;
                } else {
                    // Bucket not found, create mock structure
                    $data->bucket = $this->createMockBucket($data->trench ?? '');
                }
            } else {
                // No pbId, create mock structure
                $data->bucket = $this->createMockBucket($data->trench ?? '');
            }
            
            // Wrap in FileMakerFind to make it compatible with Find templates
            $finds[] = new FileMakerFind($data);
        }

        return $finds;
    }

    private function createMockBucket(string $trench): \stdClass
    {
        $bucket = new \stdClass();
        $bucket->locus = new \stdClass();
        $bucket->locus->excavation = new \stdClass();
        $bucket->locus->excavation->trench = $trench;
        $bucket->locus->excavation->season = '';
        $bucket->locus->excavation->id = 0;
        $bucket->locus->number = '';
        $bucket->locus->id = 0;
        $bucket->number = '';
        $bucket->id = 0;
        return $bucket;
    }

    private function toCamelCase(string $fieldName): string
    {
        $fieldName = trim($fieldName);
        
        // Remove spaces and convert to camelCase
        $parts = preg_split('/[\s_]+/', $fieldName);
        $camelCase = strtolower(array_shift($parts));
        
        foreach ($parts as $part) {
            $camelCase .= ucfirst(strtolower($part));
        }
        
        return $camelCase;
    }

    private function convertValue(string $fieldName, string $value)
    {
        // Return null for empty values
        if (trim($value) === '') {
            return null;
        }

        // Handle special conversions based on field name
        switch ($fieldName) {
            case 'id':
            case 'tm':
            case 'heidiconId':
            case 'heidiconSystemObjectId':
            case 'year':
            case 'month':
            case 'pbId':
                if (is_numeric($value)) {
                    return (int) $value;
                }
                return null;

            case 'weight':
            case 'quantity':
                if (is_numeric($value)) {
                    return (float) $value;
                }
                return $value;

            case 'date':
            case 'created':
            case 'modified':
                try {
                    // Handle various date formats
                    $date = str_replace('_', '-', $value);
                    return new \DateTime($date);
                } catch (\Exception $e) {
                    return null;
                }

            default:
                return $value;
        }
    }

    private function filterFinds(array $finds): array
    {
        $filtered = [];
        
        foreach ($finds as $find) {
            $match = true;
            
            // Check each field for filter
            $filterableFields = [
                'year', 'month', 'object', 'objectNo', 'category', 'categoryNo',
                'weight', 'quantity', 'dimensions', 'preservation', 'description',
                'material', 'materialRemarks', 'datingAbsolute', 'typologyReference',
                'publications', 'remarks', 'inventoryNumber', 'tm', 'dateRemarks',
                'scaRegister', 'rebuildChanges', 'heidiconId', 'heidiconUuid',
                'heidiconSystemObjectId', 'trench'
            ];
            
            foreach ($filterableFields as $field) {
                $filterValue = $this->getParameter($field);

                if ($filterValue !== null && strlen($filterValue) > 0) {
                    $fieldValue = '';
                    
                    if ($field === 'trench') {
                        $bucket = $find->getBucket();
                        if ($bucket instanceof \App\Entity\Bucket) {
                            $fieldValue = $bucket->getLocus()->getExcavation()->getTrench() ?? '';
                        } else {
                            $fieldValue = $bucket->locus->excavation->trench ?? '';
                        }
                    } else {
                        $fieldValue = $find->$field;
                        
                        // Convert dates to string for comparison
                        if ($fieldValue instanceof \DateTime) {
                            $fieldValue = $fieldValue->format('Y-m-d H:i:s');
                        }
                    }

                    // Case-insensitive partial match
                    if (stripos((string)$fieldValue, $filterValue) === false) {
                        $match = false;
                        break;
                    }
                }
            }
            
            if ($match) {
                $filtered[] = $find;
            }
        }
        
        return $filtered;
    }

    private function sortFinds(array $finds, string $sort, string $direction): array
    {
        usort($finds, function($a, $b) use ($sort, $direction) {
            $valueA = null;
            $valueB = null;
            
            // Handle nested properties
            if ($sort === 'trench') {
                $bucketA = $a->getBucket();
                $bucketB = $b->getBucket();
                if ($bucketA instanceof \App\Entity\Bucket) {
                    $valueA = $bucketA->getLocus()->getExcavation()->getTrench() ?? '';
                } else {
                    $valueA = $bucketA->locus->excavation->trench ?? '';
                }
                if ($bucketB instanceof \App\Entity\Bucket) {
                    $valueB = $bucketB->getLocus()->getExcavation()->getTrench() ?? '';
                } else {
                    $valueB = $bucketB->locus->excavation->trench ?? '';
                }
            } elseif ($sort === 'locus') {
                $bucketA = $a->getBucket();
                $bucketB = $b->getBucket();
                if ($bucketA instanceof \App\Entity\Bucket) {
                    $valueA = $bucketA->getLocus()->getNumber() ?? '';
                } else {
                    $valueA = $bucketA->locus->number ?? '';
                }
                if ($bucketB instanceof \App\Entity\Bucket) {
                    $valueB = $bucketB->getLocus()->getNumber() ?? '';
                } else {
                    $valueB = $bucketB->locus->number ?? '';
                }
            } elseif ($sort === 'bucket') {
                $bucketA = $a->getBucket();
                $bucketB = $b->getBucket();
                if ($bucketA instanceof \App\Entity\Bucket) {
                    $valueA = $bucketA->getNumber() ?? '';
                } else {
                    $valueA = $bucketA->number ?? '';
                }
                if ($bucketB instanceof \App\Entity\Bucket) {
                    $valueB = $bucketB->getNumber() ?? '';
                } else {
                    $valueB = $bucketB->number ?? '';
                }
            } else {
                $valueA = $a->$sort;
                $valueB = $b->$sort;
            }
            
            // Handle DateTime objects
            if ($valueA instanceof \DateTime && $valueB instanceof \DateTime) {
                $result = $valueA <=> $valueB;
            } elseif ($valueA instanceof \DateTime || $valueB instanceof \DateTime) {
                // One is DateTime, one is not - convert DateTime to string for comparison
                $strA = $valueA instanceof \DateTime ? $valueA->format('Y-m-d H:i:s') : (string)$valueA;
                $strB = $valueB instanceof \DateTime ? $valueB->format('Y-m-d H:i:s') : (string)$valueB;
                $result = strcasecmp($strA, $strB);
            } elseif ($valueA === null && $valueB === null) {
                $result = 0;
            } elseif ($valueA === null) {
                $result = 1; // nulls sort last
            } elseif ($valueB === null) {
                $result = -1; // nulls sort last
            } else {
                // Convert to string for comparison
                $result = strcasecmp((string)$valueA, (string)$valueB);
            }
            
            return $direction === 'desc' ? -$result : $result;
        });
        
        return $finds;
    }
}
