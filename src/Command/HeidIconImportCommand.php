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
 * heidICON (easydb) XML import.
 *
 * Reads exported XML files (one heidICON `<objekte>` plus its `<ressourcen>` per
 * file) and synchronises image metadata and photographer credits into the
 * berenike database. Specification: docs/concept/heidICON.md.
 */
class HeidIconImportCommand extends Command
{
    protected static $defaultName = 'heidicon:import';
    protected static $defaultDescription = 'Import image metadata and photographer credits from heidICON (easydb) XML exports';

    private const NS = 'https://schema.easydb.de/EASYDB/1.0/objects/';
    private const NS_PREFIX = 'eb';
    private const SPECIALITY_PHOTOGRAPHER = 'photographer';
    private const IMAGE_TYPE_PHOTO = 'photo';

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
            ->addOption('dry-run', null, InputOption::VALUE_NONE, 'Parse and validate but do not persist anything to the database')
            ->addOption('batch-size', 'b', InputOption::VALUE_REQUIRED, 'Number of records between Doctrine flushes', 50)
        ;
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);

        $directoryArg = (string) $input->getArgument('directory');
        $dryRun = (bool) $input->getOption('dry-run');
        $batchSize = max(1, (int) $input->getOption('batch-size'));

        $projectRoot = dirname(__DIR__, 2);
        $directory = $this->resolvePath($projectRoot, $directoryArg);

        if (!is_dir($directory)) {
            $io->error(sprintf('Directory not found: %s', $directory));
            return Command::FAILURE;
        }

        $io->title('heidICON Import');
        $io->info(sprintf('Scanning: %s', $directory));
        if ($dryRun) {
            $io->warning('DRY RUN MODE - No changes will be persisted');
        }

        $xmlFiles = $this->findXmlFiles($directory);
        if (empty($xmlFiles)) {
            $io->warning('No XML files found.');
            return Command::SUCCESS;
        }
        $io->info(sprintf('Found %d XML file(s)', count($xmlFiles)));

        $stats = [
            'files_processed'     => 0,
            'files_with_errors'   => 0,
            'objekte_skipped'     => 0,
            'finds_updated'       => 0,
            'images_inserted'     => 0,
            'images_updated'      => 0,
            'specialists_linked'  => 0,
            'ressourcen_orphaned' => 0,
            'images_deleted'      => 0,
            'warnings'            => 0,
        ];
        $warnings = [];
        $opCount = 0;
        /** @var array<int,true> $clearedFinds find id → true (images wiped once per run) */
        $clearedFinds = [];

        // ============================================================
        // Phase 1 — parse every XML file, build global indexes:
        //   - $objektes:  every <objekte> across all files
        //   - $easToRes:  eas-id → entry (DOM node + xpath + sourceFile)
        //                 for every <ressourcen> across all files
        // The DOMDocuments are kept alive in $docs so the cached DOM
        // nodes remain valid for phase 2 / 3.
        // ============================================================
        $docs      = [];
        $objektes  = [];
        $easToRes  = [];

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

            $hasObjekte    = false;
            $hasRessourcen = false;
            foreach ($xpath->query('/eb:objects/eb:objekte') as $objekte) {
                $hasObjekte = true;
                $objektes[] = [
                    'node'       => $objekte,
                    'xpath'      => $xpath,
                    'sourceFile' => $xmlFile,
                ];
            }
            foreach ($xpath->query('/eb:objects/eb:ressourcen') as $res) {
                $hasRessourcen = true;
                $resHeidiconId = $this->intOrNull($xpath, 'eb:_id', $res);
                $easId = $this->stringOrNull($xpath, 'eb:_standard-eas/eb:files/eb:file/eb:eas-id', $res);
                if ($easId === null) {
                    $warnings[] = sprintf(
                        '[WARNING] %s: <ressourcen> _id=%s without eas-id, skipped',
                        basename($xmlFile),
                        $resHeidiconId ?? '?'
                    );
                    $stats['ressourcen_orphaned']++;
                    continue;
                }
                if (isset($easToRes[$easId])) {
                    $warnings[] = sprintf(
                        '[WARNING] %s: duplicate eas-id %s (first seen in %s); using first occurrence',
                        basename($xmlFile),
                        $easId,
                        basename($easToRes[$easId]['sourceFile'])
                    );
                    continue;
                }
                $easToRes[$easId] = [
                    'node'       => $res,
                    'xpath'      => $xpath,
                    'sourceFile' => $xmlFile,
                ];
            }

            if (!$hasObjekte && !$hasRessourcen) {
                $warnings[] = sprintf('[WARNING] %s: no <objekte> and no <ressourcen>; file skipped', basename($xmlFile));
                $stats['files_with_errors']++;
                continue;
            }
            $stats['files_processed']++;
        }

        $io->info(sprintf(
            'Indexed %d <objekte> and %d <ressourcen> across %d file(s)',
            count($objektes),
            count($easToRes),
            $stats['files_processed']
        ));

        // ============================================================
        // Phase 2 — for every <objekte>: resolve find from URL, wipe
        // existing images on first encounter, then upsert each owned
        // <ressourcen> looked up via the GLOBAL eas-id index (so
        // ressourcen living in other XML files of the same run are
        // resolved correctly).
        // ============================================================
        $imageRepo  = $this->entityManager->getRepository(Image::class);
        $claimedRes = []; // eas-id → true

        foreach ($objektes as $info) {
            /** @var \DOMElement $objekte */
            $objekte    = $info['node'];
            /** @var \DOMXPath $xpath */
            $xpath      = $info['xpath'];
            $sourceFile = $info['sourceFile'];
            $objHeidiconId = $this->intOrNull($xpath, 'eb:_id', $objekte);
            $objLabel = sprintf('<objekte> _id=%s (%s)', $objHeidiconId ?? '?', basename($sourceFile));

            $urlNode = $xpath->query(
                'eb:custom[@name="obj_beschreibung_link"]/eb:string[@name="url"]',
                $objekte
            )->item(0);
            if ($urlNode === null) {
                $warnings[] = sprintf('[WARNING] %s: no obj_beschreibung_link URL; skipping branch', $objLabel);
                $stats['objekte_skipped']++;
                continue;
            }
            $url = trim($urlNode->textContent);
            if (!preg_match('#/find/(\d+)$#', $url, $m)) {
                $warnings[] = sprintf('[WARNING] %s: cannot extract find ID from URL "%s"; skipping branch', $objLabel, $url);
                $stats['objekte_skipped']++;
                continue;
            }
            $findId = (int) $m[1];

            $find = $this->findRepository->find($findId);
            if ($find === null) {
                $warnings[] = sprintf('[WARNING] %s: find ID %d not found in database; skipping branch', $objLabel, $findId);
                $stats['objekte_skipped']++;
                continue;
            }

            // heidICON XML is the source of truth: on first encounter of
            // this find in the current run, wipe every existing image (and
            // its image_specialist rows, via cascade-remove).
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
                    // Flush deletes before re-inserting so unique constraints don't trip.
                    $this->entityManager->flush();
                }
            }

            $find->setHeidiconId($objHeidiconId);
            $find->setHeidiconUuid($this->stringOrNull($xpath, 'eb:_uuid', $objekte));
            $find->setHeidiconSystemObjectId($this->intOrNull($xpath, 'eb:_system_object_id', $objekte));
            if (!$dryRun) {
                $this->entityManager->persist($find);
            }
            $stats['finds_updated']++;

            // Resolve every eas-id this objekte owns via the global index
            // and upsert one image per ressourcen.
            foreach ($xpath->query('eb:_standard-eas/eb:files/eb:file/eb:eas-id', $objekte) as $easNode) {
                $easId = trim($easNode->textContent);
                if ($easId === '' || !isset($easToRes[$easId])) {
                    continue;
                }
                $entry = $easToRes[$easId];
                $claimedRes[$easId] = true;
                $this->upsertRessourcen(
                    $entry['xpath'],
                    $entry['node'],
                    $find,
                    (int) $easId,
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

        // ============================================================
        // Phase 3 — any <ressourcen> not claimed by any matched objekte
        // is an orphan: warn and count.
        // ============================================================
        foreach ($easToRes as $easId => $entry) {
            if (isset($claimedRes[$easId])) {
                continue;
            }
            $resHeidiconId = $this->intOrNull($entry['xpath'], 'eb:_id', $entry['node']);
            $warnings[] = sprintf(
                '[WARNING] %s: ressourcen _id=%s (eas-id=%s) not owned by any matched <objekte>; skipped',
                basename($entry['sourceFile']),
                $resHeidiconId ?? '?',
                $easId
            );
            $stats['ressourcen_orphaned']++;
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
                ['<objekte> skipped',       $stats['objekte_skipped']],
                ['Finds updated',           $stats['finds_updated']],
                ['Images deleted',          $stats['images_deleted']],
                ['Images inserted',         $stats['images_inserted']],
                ['Images updated',          $stats['images_updated']],
                ['Specialist links set',    $stats['specialists_linked']],
                ['<ressourcen> orphaned',   $stats['ressourcen_orphaned']],
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
            $io->success('heidICON import completed.');
        }

        return Command::SUCCESS;
    }

    /**
     * Upsert one <ressourcen> as an Image (and image_specialist) on $find.
     *
     * @param \Doctrine\Persistence\ObjectRepository $imageRepo
     * @param array<string,int> $stats  modified in place
     */
    private function upsertRessourcen(
        \DOMXPath $xpath,
        \DOMElement $res,
        \App\Entity\Find $find,
        int $easId,
        string $xmlFile,
        bool $dryRun,
        $imageRepo,
        array &$warnings,
        array &$stats
    ): void {
        $resHeidiconId = $this->intOrNull($xpath, 'eb:_id', $res);

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

        // --- Photographer link ----------------------------------------
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
                '[WARNING] No GND author for ressourcen _id=%s (file %s); plain-text author: %s',
                $resHeidiconId ?? '?',
                basename($xmlFile),
                $plain ?? '(none)'
            );
            return;
        }

        $specialist = $this->specialistRepository->findOneBy(['gnd' => $gndUri]);
        if ($specialist === null) {
            $warnings[] = sprintf(
                '[WARNING] Specialist not found for GND %s (ressourcen _id=%s, file %s)',
                $gndUri,
                $resHeidiconId ?? '?',
                basename($xmlFile)
            );
            return;
        }

        foreach ($image->getImageSpecialists() as $existingIs) {
            if ($existingIs->getSpeciality() === self::SPECIALITY_PHOTOGRAPHER) {
                $image->removeImageSpecialist($existingIs);
                if (!$dryRun) {
                    $this->entityManager->remove($existingIs);
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

    /**
     * Recursively collect all *.xml files under the given directory (sorted).
     *
     * @return string[]
     */
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
