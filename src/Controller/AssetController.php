<?php

namespace App\Controller;

use App\Entity\Image;
use App\Entity\Find;
use App\Form\AssetType;
use App\Service\ImageService;
use App\Repository\ImageRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Psr\Log\LoggerInterface;

class AssetController extends BerenikeController
{
    private EntityManagerInterface $entityManager;
    private ImageRepository $imageRepository;
    private ImageService $imageService;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        ImageRepository $imageRepository,
        ImageService $imageService
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->imageRepository = $imageRepository;
        $this->imageService = $imageService;
    }

    /**
     * List all assets (images with asset_key)
     */
    public function list(Request $request): Response
    {
        $page = max(1, $request->query->getInt('page', 1));
        $limit = 20;
        $offset = ($page - 1) * $limit;

        $queryBuilder = $this->imageRepository->createQueryBuilder('i')
            ->where('i.assetKey IS NOT NULL')
            ->andWhere('i.assetShard IS NOT NULL')
            ->orderBy('i.id', 'DESC')
            ->setFirstResult($offset)
            ->setMaxResults($limit);

        $assets = $queryBuilder->getQuery()->getResult();

        $countQueryBuilder = $this->imageRepository->createQueryBuilder('i')
            ->select('COUNT(i.id)')
            ->where('i.assetKey IS NOT NULL')
            ->andWhere('i.assetShard IS NOT NULL');
        $totalAssets = $countQueryBuilder->getQuery()->getSingleScalarResult();

        $totalPages = ceil($totalAssets / $limit);

        return $this->render('asset/list.html.twig', [
            'assets' => $assets,
            'page' => $page,
            'totalPages' => $totalPages,
            'totalAssets' => $totalAssets,
        ]);
    }

    /**
     * Show a single asset
     */
    public function show(int $id): Response
    {
        $asset = $this->imageRepository->findOneBy([
            'id' => $id,
        ]);

        if (!$asset || !$asset->getAssetKey()) {
            $this->addFlash('warning', 'Asset not found');
            return $this->redirectToRoute('PapyrillioBerenike_AssetList');
        }

        // Get available variants
        $variants = [];
        if ($asset->getAssetKey()) {
            $variants = $this->imageService->getAssetVariants($asset->getAssetKey());
        }

        return $this->render('asset/show.html.twig', [
            'asset' => $asset,
            'variants' => $variants,
        ]);
    }

    /**
     * Create a new asset
     */
    public function create(Request $request): Response
    {
        $asset = new Image();
        $form = $this->createForm(AssetType::class, $asset);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            /** @var UploadedFile $uploadedFile */
            $uploadedFile = $form->get('uploadedFile')->getData();

            if ($uploadedFile) {
                try {
                    // Generate asset_key from filename
                    $originalFilename = $uploadedFile->getClientOriginalName();
                    $assetKey = $this->imageService->generateAssetKey($originalFilename);
                    
                    // Check if asset already exists
                    $existingAsset = $this->imageRepository->findOneBy(['assetKey' => $assetKey]);
                    if ($existingAsset) {
                        $this->addFlash('warning', 'An asset with this filename already exists');
                        return $this->redirectToRoute('PapyrillioBerenike_AssetShow', ['id' => $existingAsset->getId()]);
                    }

                    $asset->setAssetKey($assetKey);
                    
                    // Use the uploaded file's existing temporary path
                    $tempPath = $uploadedFile->getRealPath();

                    // Process the image (this will copy to asset directory)
                    $dimensions = $this->imageService->processImage($tempPath, $assetKey);
                    
                    // Set size and file properties
                    $asset->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));
                    $asset->setFile($originalFilename);
                    $asset->setPath($assetKey);
                    
                    // Set default type if not set
                    if (!$asset->getType()) {
                        $asset->setType('photo');
                    }
                    
                    // Note: Symfony automatically cleans up uploaded file after request

                    $this->entityManager->persist($asset);
                    $this->entityManager->flush();

                    $this->addFlash('success', 'Asset created successfully');
                    return $this->redirectToRoute('PapyrillioBerenike_AssetShow', ['id' => $asset->getId()]);

                } catch (\Exception $e) {
                    $this->logger->error('Failed to process asset: ' . $e->getMessage());
                    $this->addFlash('error', 'Failed to process image: ' . $e->getMessage());
                }
            } else {
                $this->addFlash('error', 'Please select a file to upload');
            }
        } elseif ($form->isSubmitted()) {
            // Form was submitted but has validation errors
            $this->logger->error('Asset form validation failed');
            foreach ($form->getErrors(true) as $error) {
                $this->logger->error('Form error: ' . $error->getMessage());
                $this->addFlash('error', $error->getMessage());
            }
        }

        return $this->render('asset/create.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    /**
     * Edit an existing asset (metadata only, not the image files)
     */
    public function edit(int $id, Request $request): Response
    {
        $asset = $this->imageRepository->findOneBy(['id' => $id]);

        if (!$asset || !$asset->getAssetKey()) {
            $this->addFlash('warning', 'Asset not found');
            return $this->redirectToRoute('PapyrillioBerenike_AssetList');
        }

        $form = $this->createForm(AssetType::class, $asset, [
            'is_edit' => true,
        ]);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->entityManager->flush();

            $this->addFlash('success', 'Asset updated successfully');
            return $this->redirectToRoute('PapyrillioBerenike_AssetShow', ['id' => $asset->getId()]);
        }

        return $this->render('asset/edit.html.twig', [
            'asset' => $asset,
            'form' => $form->createView(),
        ]);
    }

    /**
     * Delete an asset
     */
    public function delete(int $id, Request $request): Response
    {
        $asset = $this->imageRepository->findOneBy(['id' => $id]);

        if (!$asset || !$asset->getAssetKey()) {
            $this->addFlash('warning', 'Asset not found');
            return $this->redirectToRoute('PapyrillioBerenike_AssetList');
        }

        if ($request->isMethod('POST')) {
            $assetKey = $asset->getAssetKey();
            
            // Remove from database
            $this->entityManager->remove($asset);
            $this->entityManager->flush();

            // Optionally remove files from disk
            // Uncomment if you want to delete physical files
            /*
            $assetDir = $this->imageService->getAssetDirectory($assetKey);
            if (is_dir($assetDir)) {
                $this->removeDirectory($assetDir);
            }
            */

            $this->addFlash('success', 'Asset deleted successfully');
            return $this->redirectToRoute('PapyrillioBerenike_AssetList');
        }

        return $this->render('asset/delete.html.twig', [
            'asset' => $asset,
        ]);
    }

    /**
     * Recursively remove directory and its contents
     */
    private function removeDirectory(string $dir): bool
    {
        if (!is_dir($dir)) {
            return false;
        }

        $files = array_diff(scandir($dir), ['.', '..']);
        foreach ($files as $file) {
            $path = $dir . '/' . $file;
            is_dir($path) ? $this->removeDirectory($path) : unlink($path);
        }

        return rmdir($dir);
    }
}
