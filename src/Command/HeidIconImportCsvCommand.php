<?php

namespace App\Command;

use App\Entity\Image;
use App\Entity\ImageSpecialist;
use App\Repository\FindRepository;
use App\Repository\SpecialistRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;

/**
 * heidICON (easydb) XML import — CSV-mapping variant.
 *
 * Workaround for corrupted `obj_beschreibung_link` URLs in recent heidICON
 * exports. Instead of extracting the berenike find ID from the URL inside
 * each `<objekte>`, this command relies on an external CSV mapping
 * (filename → find ID) to attach each `<ressourcen>` (image) to its find.
 *
 * The CSV (default: `data/heidICON/find_photos.csv`) is expected to have a
 * header `find,photos`, where `photos` is a comma-separated list of image
 * file names (possibly with surrounding spaces). Standard CSV quoting is
 * used when the photo list itself contains commas.
 *
 * Find rows are still enriched with heidICON identifiers
 * (`heidicon_id`, `heidicon_uuid`, `heidicon_system_object_id`) using the
 * `<objekte>` that owns the image's `eas-id` within the same XML file.
 */
class HeidIconImportCsvCommand extends Command
{
    protected static $defaultName = 'heidicon:import-csv';
    protected static $defaultDescription = 'Import heidICON images using a filename→find CSV mapping (workaround for corrupted obj_beschreibung_link URLs)';

    private const NS = 'https://schema.easydb.de/EASYDB/1.0/objects/';
    private const NS_PREFIX = 'eb';
    private const SPECIALITY_PHOTOGRAPHER = 'photographer';
    private const IMAGE_TYPE_PHOTO = 'photo';
    private const DEFAULT_MAPPING = 'data/heidICON/find_photos.csv';

    private EntityManagerInterface $entityManager;
    private FindRepository $findRepository;
    private SpecialistRepository $specialistRepository;

    public function __construct(
        EntityManagerInterface $entityManager,
        FindRepository $findRepository,
        SpecialistRepository $specialistRepository
    ) {
        parent::__construct();
        $this->entityManager = $entityManager;
        $this->findRepository = $findRepository;
        $this->specialistRepository = $specialistRepository;
    }

    protected function configure(): void
    {
        $this
            ->addArgument(
                'directory',
                InputArgument::OPTIONAL,
                'Directory containing heidICON XML files (scanned recursively). Relative paths are resolved from the project root.',
                'data/heidICON'
            )
            ->addOption('mapping', 'm', InputOption::VALUE_REQUIRED, 'Path to the filename→find CSV mapping', self::DEFAULT_MAPPING)
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Parse and validate but do not persist anything to the database')
            ->addOption('batch-size', 'b', InputOption::VALUE_REQUIRED, 'Number of records between Doctrine flushes', 50)
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $directoryArg = (string) $input->getArgument('directory');
        $mappingArg   = (string) $input->getOption('mapping');
        $dryRun       = (bool) $input->getOption('dry-run');
        $batchSize    = max(1, (int) $input->getOption('batch-size'));

        $projectRoot = dirname(__DIR__, 2);
        $directory   = $this->resolvePath($projectRoot, $directoryArg);
        $mappingPath = $this->resolvePath($projectRoot, $mappingArg);

        if (!is_dir($directory)) {
            $io->error(sprintf('Directory not found: %s', $directory));
            return Command::FAILURE;
        }
        if (!is_file($mappingPath)) {
            $io->error(sprintf('Mapping CSV not found: %s', $mappingPath));
            return Command::FAILURE;
        }

        $io->title('heidICON Import (CSV mapping)');
        $io->info(sprintf('Scanning: %s', $directory));
        $io->info(sprintf('Mapping:  %s', $mappingPath));
        if ($dryRun) {
            $io->warning('DRY RUN MODE - No changes will be persisted');
        }

        $loadWarnings = [];
        $fileToFinds = $this->loadMapping($mappingPath, $loadWarnings);
        $io->info(sprintf('Loaded %d distinct filename(s) from mapping', count($fileToFinds)));

        $xmlFiles = $this->findXmlFiles($directory);
        if (empty($xmlFiles)) {
            $io->warning('No XML files found.');
            return Command::SUCCESS;
        }
        $io->info(sprintf('Found %d XML file(s)', count($xmlFiles)));

        $stats = [
            'files_processed'    => 0,
            'files_with_errors'  => 0,
            'objekte_total'        => 0,
            'objekte_unmatched'    => 0,
            'objekte_multi_matched' => 0,
            'ressourcen_skipped'   => 0,
            'finds_updated'         => 0,
            'images_deleted'        => 0,
            'images_inserted'       => 0,
            'images_updated'     => 0,
            'specialists_linked' => 0,
            'warnings'           => 0,
        ];
        $warnings = $loadWarnings;

        // ============================================================
        // Phase 1 — parse every XML file, build global indexes:
        //   - $objektes:  list of every <objekte> across all files
        //   - $easToRes:  eas-id → ressourcen (filename + DOM node), built
        //                 from every <ressourcen> in every file
        // The DOMDocument references are kept alive in $docs so the cached
        // DOM nodes remain valid for phase 2 / 3.
        // ============================================================
        $docs = [];
        $objektes = [];
        $easToRes = [];

        foreach ($xmlFiles as $xmlFile) {
            $dom = new \DOMDocument();
            $dom->preserveWhiteSpace = false;
            if (!@$dom->load($xmlFile)) {
                $warnings[] = sprintf('[WARNING] %s: invalid XML, file skipped', basename($xmlFile));
                $stats['files_with_errors']++;
                continue;
            }
            $docs[] = $dom;
            $xpath = new \DOMXPath($dom);
            $xpath->registerNamespace(self::NS_PREFIX, self::NS);

            $hasObjekte = false;
            foreach ($xpath->query('/eb:objects/eb:objekte') as $objekte) {
                $hasObjekte = true;
                $easIds = [];
                foreach ($xpath->query('eb:_standard-eas/eb:files/eb:file/eb:eas-id', $objekte) as $en) {
                    $eid = trim($en->textContent);
                    if ($eid !== '') {
                        $easIds[] = $eid;
                    }
                }
                $objektes[] = [
                    'node'       => $objekte,
                    'xpath'      => $xpath,
                    'sourceFile' => $xmlFile,
                    'easIds'     => $easIds,
                ];
                $stats['objekte_total']++;
            }

            foreach ($xpath->query('/eb:objects/eb:ressourcen') as $res) {
                $easId = $this->stringOrNull($xpath, 'eb:_standard-eas/eb:files/eb:file/eb:eas-id', $res);
                if ($easId === null) {
                    $resHeidiconId = $this->intOrNull($xpath, 'eb:_id', $res);
                    $warnings[] = sprintf(
                        '[WARNING] %s: ressourcen _id=%s has no eas-id; skipped',
                        basename($xmlFile),
                        $resHeidiconId ?? '?'
                    );
                    $stats['ressourcen_skipped']++;
                    continue;
                }
                if (isset($easToRes[$easId])) {
                    // First occurrence wins; warn on cross-file duplicate.
                    $warnings[] = sprintf(
                        '[WARNING] %s: duplicate eas-id %s (first seen in %s); using first occurrence',
                        basename($xmlFile),
                        $easId,
                        basename($easToRes[$easId]['sourceFile'])
                    );
                    continue;
                }
                $filename = $this->stringOrNull($xpath, 'eb:asset/eb:files/eb:file/eb:original_filename', $res);
                $easToRes[$easId] = [
                    'node'       => $res,
                    'xpath'      => $xpath,
                    'sourceFile' => $xmlFile,
                    'filename'   => $filename,
                ];
            }

            if (!$hasObjekte && $xpath->query('/eb:objects/eb:ressourcen')->length === 0) {
                $warnings[] = sprintf('[WARNING] %s: no <objekte> and no <ressourcen>; file skipped', basename($xmlFile));
                $stats['files_with_errors']++;
                continue;
            }
            $stats['files_processed']++;
        }

        $io->info(sprintf(
            'Indexed %d <objekte> and %d <ressourcen> across %d file(s)',
            $stats['objekte_total'],
            count($easToRes),
            $stats['files_processed']
        ));

        // ============================================================
        // Phase 2 — match each <objekte> to a find by intersecting CSV
        // candidate find-IDs across the full filename set of the objekte
        // (gathered from the global eas-id → ressourcen index, so that
        // ressourcen living in other XML files of the same import run are
        // taken into account). Upsert images for matched objekte.
        // ============================================================
        $imageRepo = $this->entityManager->getRepository(Image::class);
        $claimedRes = []; // eas-id → true
        $clearedFinds = []; // find id → true (existing images wiped exactly once)
        $opCount = 0;

        foreach ($objektes as $info) {
            /** @var \DOMElement $objekte */
            $objekte    = $info['node'];
            /** @var \DOMXPath $xpath */
            $xpath      = $info['xpath'];
            $sourceFile = $info['sourceFile'];
            $easIds     = $info['easIds'];
            $objHeidiconId = $this->intOrNull($xpath, 'eb:_id', $objekte);
            $objLabel = sprintf('<objekte> _id=%s (%s)', $objHeidiconId ?? '?', basename($sourceFile));

            $ownedFiles = [];    // normalised key → original filename
            $ownedRes   = [];    // eas-id → entry
            foreach ($easIds as $eid) {
                if (!isset($easToRes[$eid])) {
                    continue;
                }
                $entry = $easToRes[$eid];
                $ownedRes[$eid] = $entry;
                if ($entry['filename'] !== null) {
                    $ownedFiles[$this->normaliseFilename($entry['filename'])] = $entry['filename'];
                }
            }

            if (empty($ownedFiles)) {
                $warnings[] = sprintf(
                    '[WARNING] %s: no <ressourcen> with original_filename found across import set (owns %d eas-id(s)); skipping objekte',
                    $objLabel,
                    count($easIds)
                );
                $stats['objekte_unmatched']++;
                continue;
            }

            $candidates  = null;
            $missingFile = null;
            foreach (array_keys($ownedFiles) as $key) {
                $finds = $fileToFinds[$key] ?? [];
                if (empty($finds)) {
                    $missingFile = $ownedFiles[$key];
                    $candidates  = [];
                    break;
                }
                $candidates = $candidates === null
                    ? $finds
                    : array_values(array_intersect($candidates, $finds));
                if (empty($candidates)) {
                    break;
                }
            }

            if (empty($candidates)) {
                $reason = $missingFile !== null
                    ? sprintf('filename "%s" not in CSV', $missingFile)
                    : 'no CSV row contains all filenames';
                $warnings[] = sprintf(
                    '[WARNING] %s: %s (objekte owns %d filename(s)); skipping objekte',
                    $objLabel,
                    $reason,
                    count($ownedFiles)
                );
                $stats['objekte_unmatched']++;
                continue;
            }
            // One or more CSV rows cover all of the objekte's filenames:
            //   - Exactly 1 candidate  → ordinary 1:1 match.
            //   - 2+ candidates        → a Sammelbild whose photos are shared
            //                            by several finds. Apply the heidICON
            //                            metadata and upsert images for every
            //                            matched find (same behaviour as the
            //                            URL-based command's multi-objekte
            //                            handling).
            $uuid             = $this->stringOrNull($xpath, 'eb:_uuid', $objekte);
            $systemObjectId   = $this->intOrNull($xpath, 'eb:_system_object_id', $objekte);
            $matchedAtLeastOne = false;
            $missingFindIds    = [];

            foreach ($candidates as $findId) {
                $find = $this->findRepository->find($findId);
                if ($find === null) {
                    $missingFindIds[] = $findId;
                    continue;
                }

                // heidICON XML is the source of truth: on first encounter,
                // wipe every existing image (and its image_specialist rows,
                // via cascade-remove) of this find so the run leaves only
                // what the current XML describes.
                if (!isset($clearedFinds[$findId])) {
                    $clearedFinds[$findId] = true;
                    $existing = $imageRepo->findBy(['find' => $find]);
                    foreach ($existing as $oldImg) {
                        if (!$dryRun) {
                            $this->entityManager->remove($oldImg);
                        }
                        $stats['images_deleted']++;
                    }
                    if (!$dryRun && !empty($existing)) {
                        // Flush deletions before re-inserting so unique
                        // constraints (e.g. on heidicon_id+find) don't trip.
                        $this->entityManager->flush();
                    }
                }

                $find->setHeidiconId($objHeidiconId);
                $find->setHeidiconUuid($uuid);
                $find->setHeidiconSystemObjectId($systemObjectId);
                if (!$dryRun) {
                    $this->entityManager->persist($find);
                }
                $stats['finds_updated']++;
                $matchedAtLeastOne = true;

                foreach ($ownedRes as $eid => $entry) {
                    $claimedRes[$eid] = true;
                    $this->upsertImage(
                        $entry['xpath'],
                        $entry['node'],
                        $find,
                        $entry['sourceFile'],
                        $dryRun,
                        $imageRepo,
                        $warnings,
                        $stats
                    );
                    $opCount++;
                    if (!$dryRun && $opCount >= $batchSize) {
                        $this->entityManager->flush();
                        $opCount = 0;
                    }
                }
            }

            if (!empty($missingFindIds)) {
                $warnings[] = sprintf(
                    '[WARNING] %s: candidate find ID(s) %s not in database; skipped those',
                    $objLabel,
                    implode(',', $missingFindIds)
                );
            }
            if (!$matchedAtLeastOne) {
                $warnings[] = sprintf(
                    '[WARNING] %s: none of the %d candidate find(s) exist in DB; skipping objekte',
                    $objLabel,
                    count($candidates)
                );
                $stats['objekte_unmatched']++;
            } elseif (count($candidates) > 1) {
                $stats['objekte_multi_matched']++;
            }
        }

        // ============================================================
        // Phase 3 — any <ressourcen> not claimed by a matched <objekte>
        // is an orphan: warn and count.
        // ============================================================
        foreach ($easToRes as $eid => $entry) {
            if (isset($claimedRes[$eid])) {
                continue;
            }
            $resHeidiconId = $this->intOrNull($entry['xpath'], 'eb:_id', $entry['node']);
            $warnings[] = sprintf(
                '[WARNING] %s: ressourcen _id=%s (eas-id=%s, filename="%s") not claimed by any matched <objekte>; skipped',
                basename($entry['sourceFile']),
                $resHeidiconId ?? '?',
                $eid,
                $entry['filename'] ?? ''
            );
            $stats['ressourcen_skipped']++;
        }

        if (!$dryRun) {
            $this->entityManager->flush();
            $this->entityManager->clear();
        }

        $stats['warnings'] = count($warnings);

        $io->section('Summary');
        $io->table(
            ['Metric', 'Count'],
            [
                ['XML files processed',     $stats['files_processed']],
                ['XML files with errors',   $stats['files_with_errors']],
                ['<objekte> total',         $stats['objekte_total']],
                ['<objekte> unmatched',     $stats['objekte_unmatched']],
                ['<objekte> multi-matched', $stats['objekte_multi_matched']],
                ['<ressourcen> skipped',    $stats['ressourcen_skipped']],
                ['Finds updated',           $stats['finds_updated']],
                ['Images deleted',          $stats['images_deleted']],
                ['Images inserted',         $stats['images_inserted']],
                ['Images updated',          $stats['images_updated']],
                ['Specialist links set',    $stats['specialists_linked']],
                ['Warnings',                $stats['warnings']],
            ]
        );

        if (!empty($warnings)) {
            $io->section('Warnings');
            foreach ($warnings as $w) {
                $io->writeln($w);
            }
        }

        if ($dryRun) {
            $io->note('Dry run complete — no changes were written.');
        } else {
            $io->success('heidICON CSV import completed.');
        }

        return Command::SUCCESS;
    }

    /**
     * Load the filename → list-of-find-ids mapping from the CSV.
     *
     * The CSV has header `find,photos`. Each `photos` cell holds a
     * comma-separated list of image file names (with possible surrounding
     * whitespace); rows whose list contains commas are wrapped in
     * double quotes (handled by fgetcsv).
     *
     * The same filename may appear for several finds; all candidate find IDs
     * are kept so the caller can disambiguate by intersecting candidates
     * across the full filename set of an objekte.
     *
     * @return array<string,int[]> filename (basename, lowercase) → list of find_ids
     */
    private function loadMapping(string $path, array &$warnings): array
    {
        $map = [];
        $fh = fopen($path, 'r');
        if ($fh === false) {
            return $map;
        }

        $header = fgetcsv($fh);
        if ($header === false) {
            fclose($fh);
            return $map;
        }
        $header = array_map(static fn($s) => strtolower(trim((string) $s)), $header);
        $findCol  = array_search('find',   $header, true);
        $photoCol = array_search('photos', $header, true);
        if ($findCol === false || $photoCol === false) {
            fclose($fh);
            $warnings[] = sprintf('[WARNING] Mapping CSV %s: header must contain "find" and "photos"', basename($path));
            return $map;
        }

        while (($row = fgetcsv($fh)) !== false) {
            if (!isset($row[$findCol], $row[$photoCol])) {
                continue;
            }
            $findIdRaw = trim((string) $row[$findCol]);
            $photos    = (string) $row[$photoCol];
            if ($findIdRaw === '' || !ctype_digit($findIdRaw)) {
                continue;
            }
            $findId = (int) $findIdRaw;

            foreach (explode(',', $photos) as $name) {
                $key = $this->normaliseFilename($name);
                if ($key === '') {
                    continue;
                }
                if (!isset($map[$key])) {
                    $map[$key] = [];
                }
                if (!in_array($findId, $map[$key], true)) {
                    $map[$key][] = $findId;
                }
            }
        }
        fclose($fh);
        return $map;
    }

    /**
     * Normalise a filename for map lookup: strip leading/trailing whitespace,
     * lowercase, and reduce to basename (in case the CSV ever contains a
     * relative path).
     */
    private function normaliseFilename(string $name): string
    {
        $name = trim($name);
        if ($name === '') {
            return '';
        }
        $name = basename($name);
        return strtolower($name);
    }

    /**
     * Upsert one <ressourcen> as an Image row attached to $find, and
     * link the photographer via image_specialist (same semantics as
     * the URL-based command).
     *
     * @param \Doctrine\Persistence\ObjectRepository $imageRepo
     * @param array<string,int> $stats  modified in place
     */
    private function upsertImage(
        \DOMXPath $xpath,
        \DOMElement $res,
        \App\Entity\Find $find,
        string $xmlFile,
        bool $dryRun,
        $imageRepo,
        array &$warnings,
        array &$stats
    ): void {
        $resHeidiconId = $this->intOrNull($xpath, 'eb:_id', $res);
        $easId = $this->intOrNull($xpath, 'eb:_standard-eas/eb:files/eb:file/eb:eas-id', $res);
        if ($easId === null) {
            $warnings[] = sprintf(
                '[WARNING] %s: <ressourcen> _id=%s without eas-id, skipped',
                basename($xmlFile),
                $resHeidiconId ?? '?'
            );
            $stats['ressourcen_skipped']++;
            return;
        }

        $image = $imageRepo->findOneBy(['heidiconId' => $easId, 'find' => $find]);
        $isNew = false;
        if ($image === null) {
            $image = new Image();
            $isNew = true;
        }

        $image->setFind($find);
        $image->setType(self::IMAGE_TYPE_PHOTO);
        $image->setHeidiconId($easId);
        $image->setHeidiconUuid($this->stringOrNull($xpath, 'eb:_uuid', $res));
        $image->setHeidiconSystemObjectId($this->intOrNull($xpath, 'eb:_system_object_id', $res));

        $width  = $this->stringOrNull($xpath, 'eb:asset/eb:files/eb:file/eb:technical_metadata/eb:width', $res);
        $height = $this->stringOrNull($xpath, 'eb:asset/eb:files/eb:file/eb:technical_metadata/eb:height', $res);
        $size = ($width !== null || $height !== null) ? sprintf('%s,%s', $width ?? '', $height ?? '') : '';
        $image->setSize($size);

        $file = $this->stringOrNull($xpath, 'eb:asset/eb:files/eb:file/eb:original_filename', $res);
        $image->setFile($file ?? '');

        if ($isNew || $image->getPath() === null) {
            $image->setPath('');
        }

        if (!$dryRun) {
            $this->entityManager->persist($image);
        }
        if ($isNew) {
            $stats['images_inserted']++;
        } else {
            $stats['images_updated']++;
        }

        // --- Photographer link --------------------------------------------
        $gndUri = $this->stringOrNull(
            $xpath,
            'eb:_nested__ressourcen__res_autoren/eb:ressourcen__res_autoren'
            . '/eb:custom[@name="res_autor_gnd"]/eb:string[@name="conceptURI"]',
            $res
        );

        if ($gndUri === null) {
            $plain = $this->stringOrNull(
                $xpath,
                'eb:_nested__ressourcen__res_autoren_lok/eb:ressourcen__res_autoren_lok/eb:res_autor_lok',
                $res
            );
            $warnings[] = sprintf(
                '[WARNING] No GND author for ressourcen _id=%d (file %s); plain-text author: %s',
                $resHeidiconId,
                basename($xmlFile),
                $plain ?? '(none)'
            );
            return;
        }

        $specialist = $this->specialistRepository->findOneBy(['gnd' => $gndUri]);
        if ($specialist === null) {
            $warnings[] = sprintf(
                '[WARNING] Specialist not found for GND %s (ressourcen _id=%d, file %s)',
                $gndUri,
                $resHeidiconId,
                basename($xmlFile)
            );
            return;
        }

        foreach ($image->getImageSpecialists() as $existing) {
            if ($existing->getSpeciality() === self::SPECIALITY_PHOTOGRAPHER) {
                $image->removeImageSpecialist($existing);
                if (!$dryRun) {
                    $this->entityManager->remove($existing);
                }
            }
        }

        $dateCreated = $this->stringOrNull(
            $xpath,
            'eb:asset/eb:files/eb:file/eb:date_created',
            $res
        );
        $year = null;
        if ($dateCreated !== null && preg_match('/^(\d{4})/', $dateCreated, $ym)) {
            $year = (int) $ym[1];
        }

        $imageSpecialist = new ImageSpecialist();
        $imageSpecialist->setSpeciality(self::SPECIALITY_PHOTOGRAPHER);
        $imageSpecialist->setYear($year);
        $imageSpecialist->setSpecialist($specialist);
        $image->addImageSpecialist($imageSpecialist);

        if (!$dryRun) {
            $this->entityManager->persist($imageSpecialist);
        }
        $stats['specialists_linked']++;
    }

    /** @return string[] */
    private function findXmlFiles(string $directory): array
    {
        $files = [];
        $it = new \RecursiveIteratorIterator(
            new \RecursiveDirectoryIterator($directory, \FilesystemIterator::SKIP_DOTS)
        );
        foreach ($it as $file) {
            if ($file->isFile() && strtolower($file->getExtension()) === 'xml') {
                $files[] = $file->getPathname();
            }
        }
        sort($files);
        return $files;
    }

    private function resolvePath(string $projectRoot, string $path): string
    {
        if ($path !== '' && ($path[0] === '/' || preg_match('#^[A-Za-z]:[\\\\/]#', $path))) {
            return $path;
        }
        return rtrim($projectRoot, '/') . '/' . $path;
    }

    private function relativePath(string $projectRoot, string $path): string
    {
        $root = rtrim($projectRoot, '/') . '/';
        if (strncmp($path, $root, strlen($root)) === 0) {
            return substr($path, strlen($root));
        }
        return $path;
    }

    private function stringOrNull(\DOMXPath $xpath, string $query, \DOMNode $context): ?string
    {
        $node = $xpath->query($query, $context)->item(0);
        if ($node === null) {
            return null;
        }
        $value = trim($node->textContent);
        return $value === '' ? null : $value;
    }

    private function intOrNull(\DOMXPath $xpath, string $query, \DOMNode $context): ?int
    {
        $value = $this->stringOrNull($xpath, $query, $context);
        return ($value !== null && ctype_digit($value)) ? (int) $value : null;
    }
}
