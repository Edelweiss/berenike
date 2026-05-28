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
            'warnings'            => 0,
        ];
        $warnings = [];
        $opCount = 0;

        foreach ($xmlFiles as $xmlFile) {
            try {
                $fileStats = $this->processFile($xmlFile, $io, $dryRun, $warnings);
            } catch (\Throwable $e) {
                $stats['files_with_errors']++;
                $warnings[] = sprintf('[ERROR] %s: %s', $this->relativePath($projectRoot, $xmlFile), $e->getMessage());
                continue;
            }

            if ($fileStats === null) {
                $stats['files_with_errors']++;
                continue;
            }

            $stats['files_processed']++;
            $stats['objekte_skipped']    += $fileStats['objekte_skipped'];
            $stats['finds_updated']      += $fileStats['finds_updated'];
            $stats['images_inserted']    += $fileStats['images_inserted'];
            $stats['images_updated']     += $fileStats['images_updated'];
            $stats['specialists_linked'] += $fileStats['specialists_linked'];
            $stats['ressourcen_orphaned']+= $fileStats['ressourcen_orphaned'];

            $opCount += $fileStats['images_inserted'] + $fileStats['images_updated'];
            if (!$dryRun && $opCount >= $batchSize) {
                $this->entityManager->flush();
                $opCount = 0;
            }
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
     * Process one heidICON XML file.
     *
     * A file contains one or more <objekte> (each linked to one berenike find)
     * and zero or more <ressourcen>. Each <ressourcen> carries a single eas-id;
     * each <objekte> lists one or more eas-ids it owns. A ressourcen is
     * attached to the find of the objekte whose eas-id list contains it.
     *
     * Returns null only for file-level failures (unreadable / malformed XML,
     * no <objekte> element at all). When an individual <objekte> branch cannot
     * be matched to a find in the database, only that branch is skipped (its
     * eas-ids are not added to the lookup map, so the corresponding
     * <ressourcen> become orphans and are skipped too).
     *
     * @return array<string,int>|null
     */
    private function processFile(string $xmlFile, SymfonyStyle $io, bool $dryRun, array &$warnings): ?array
    {
        $stats = [
            'objekte_skipped'     => 0,
            'finds_updated'       => 0,
            'images_inserted'     => 0,
            'images_updated'      => 0,
            'specialists_linked'  => 0,
            'ressourcen_orphaned' => 0,
        ];

        $dom = new \DOMDocument();
        $dom->preserveWhiteSpace = false;
        if (!@$dom->load($xmlFile)) {
            $warnings[] = sprintf('[WARNING] %s: invalid XML, file skipped', basename($xmlFile));
            return null;
        }

        $xpath = new \DOMXPath($dom);
        $xpath->registerNamespace(self::NS_PREFIX, self::NS);

        $objekteNodes = $xpath->query('/eb:objects/eb:objekte');
        if ($objekteNodes->length === 0) {
            $warnings[] = sprintf('[WARNING] %s: no <objekte> element, file skipped', basename($xmlFile));
            return null;
        }

        // --- 1. Iterate <objekte>: resolve find, update it, map eas-ids ---
        /** @var array<string, \App\Entity\Find> $easToFind */
        $easToFind = [];

        foreach ($objekteNodes as $objekte) {
            $urlNode = $xpath->query(
                'eb:custom[@name="obj_beschreibung_link"]/eb:string[@name="url"]',
                $objekte
            )->item(0);

            $objHeidiconId = $this->intOrNull($xpath, 'eb:_id', $objekte);
            $objLabel = sprintf('<objekte> _id=%s', $objHeidiconId ?? '?');

            if ($urlNode === null) {
                $warnings[] = sprintf(
                    '[WARNING] %s (%s): no obj_beschreibung_link URL; skipping branch',
                    basename($xmlFile),
                    $objLabel
                );
                $stats['objekte_skipped']++;
                continue;
            }

            $url = trim($urlNode->textContent);
            if (!preg_match('#/find/(\d+)$#', $url, $m)) {
                $warnings[] = sprintf(
                    '[WARNING] %s (%s): cannot extract find ID from URL "%s"; skipping branch',
                    basename($xmlFile),
                    $objLabel,
                    $url
                );
                $stats['objekte_skipped']++;
                continue;
            }
            $findId = (int) $m[1];

            $find = $this->findRepository->find($findId);
            if ($find === null) {
                $warnings[] = sprintf(
                    '[WARNING] %s (%s): find ID %d not found in database; skipping branch',
                    basename($xmlFile),
                    $objLabel,
                    $findId
                );
                $stats['objekte_skipped']++;
                continue;
            }

            $find->setHeidiconId($objHeidiconId);
            $find->setHeidiconUuid($this->stringOrNull($xpath, 'eb:_uuid', $objekte));
            $find->setHeidiconSystemObjectId($this->intOrNull($xpath, 'eb:_system_object_id', $objekte));
            if (!$dryRun) {
                $this->entityManager->persist($find);
            }
            $stats['finds_updated']++;

            // Register every eas-id owned by this objekte against its find.
            $easNodes = $xpath->query('eb:_standard-eas/eb:files/eb:file/eb:eas-id', $objekte);
            foreach ($easNodes as $easNode) {
                $easId = trim($easNode->textContent);
                if ($easId !== '') {
                    $easToFind[$easId] = $find;
                }
            }
        }

        // --- 2. Iterate <ressourcen>: link by eas-id, upsert image --------
        $ressourcenNodes = $xpath->query('/eb:objects/eb:ressourcen');
        foreach ($ressourcenNodes as $res) {
            $resHeidiconId = $this->intOrNull($xpath, 'eb:_id', $res);
            if ($resHeidiconId === null) {
                $warnings[] = sprintf('[WARNING] %s: <ressourcen> without _id, skipped', basename($xmlFile));
                continue;
            }

            $resEasId = $this->stringOrNull(
                $xpath,
                'eb:_standard-eas/eb:files/eb:file/eb:eas-id',
                $res
            );
            if ($resEasId === null || !isset($easToFind[$resEasId])) {
                $warnings[] = sprintf(
                    '[WARNING] %s: ressourcen _id=%d (eas-id=%s) has no owning <objekte> in this file; skipped',
                    basename($xmlFile),
                    $resHeidiconId,
                    $resEasId ?? '?'
                );
                $stats['ressourcen_orphaned']++;
                continue;
            }
            $find = $easToFind[$resEasId];

            // --- Upsert Image ---------------------------------------------
            $imageRepo = $this->entityManager->getRepository(Image::class);
            $image = $imageRepo->findOneBy(['heidiconId' => $resHeidiconId]);
            $isNew = false;
            if ($image === null) {
                $image = new Image();
                $isNew = true;
            }

            $image->setFind($find);
            $image->setType(self::IMAGE_TYPE_PHOTO);
            $image->setHeidiconId($resHeidiconId);
            $image->setHeidiconUuid($this->stringOrNull($xpath, 'eb:_uuid', $res));
            $image->setHeidiconSystemObjectId($this->intOrNull($xpath, 'eb:_system_object_id', $res));

            $width  = $this->stringOrNull($xpath, 'eb:asset/eb:files/eb:file/eb:technical_metadata/eb:width', $res);
            $height = $this->stringOrNull($xpath, 'eb:asset/eb:files/eb:file/eb:technical_metadata/eb:height', $res);
            $size = ($width !== null || $height !== null) ? sprintf('%s,%s', $width ?? '', $height ?? '') : '';
            $image->setSize($size);

            $file = $this->stringOrNull($xpath, 'eb:asset/eb:files/eb:file/eb:original_filename', $res);
            $image->setFile($file ?? '');

            // `path` is NOT NULL in the schema — keep empty string for heidICON images.
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

            // --- Upsert ImageSpecialist (photographer) --------------------
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
                continue;
            }

            $specialist = $this->specialistRepository->findOneBy(['gnd' => $gndUri]);
            if ($specialist === null) {
                $warnings[] = sprintf(
                    '[WARNING] Specialist not found for GND %s (ressourcen _id=%d, file %s)',
                    $gndUri,
                    $resHeidiconId,
                    basename($xmlFile)
                );
                continue;
            }

            // Remove any existing photographer ImageSpecialist on this image.
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

        return $stats;
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
