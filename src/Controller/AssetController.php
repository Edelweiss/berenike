<?php

namespace App\Controller;

use App\Entity\Image;
use App\Entity\ImageSpecialist;
use App\Entity\Find;
use App\Form\AssetType;
use App\Service\ImageService;
use App\Repository\ImageRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Symfony\Component\HttpFoundation\File\UploadedFile;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\DependencyInjection\ParameterBag\ParameterBagInterface;
use Psr\Log\LoggerInterface;
use Symfony\Component\Security\Http\Attribute\IsGranted;

class AssetController extends BerenikeController
{
    private EntityManagerInterface $entityManager;
    private ImageRepository $imageRepository;
    private ImageService $imageService;
    private string $projectDir;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        ImageRepository $imageRepository,
        ImageService $imageService,
        ParameterBagInterface $params
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->imageRepository = $imageRepository;
        $this->imageService = $imageService;
        $this->projectDir = $params->get('kernel.project_dir');
    }

    /**
     * List all assets (images with asset_key)
     */
    public function list(Request $request): Response
    {
        // Load all assets for client-side sorting/filtering with List.js
        $queryBuilder = $this->imageRepository->createQueryBuilder('i')
            ->where('i.assetKey IS NOT NULL')
            ->andWhere('i.assetShard IS NOT NULL')
            ->orderBy('i.id', 'DESC');

        $assets = $queryBuilder->getQuery()->getResult();
        $totalAssets = count($assets);

        return $this->render('asset/list.html.twig', [
            'assets' => $assets,
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
     * Visual editor for an asset
     */
    #[IsGranted('ROLE_EDITOR')]
    public function editVisual(int $id): Response
    {
        $asset = $this->imageRepository->findOneBy(['id' => $id]);

        if (!$asset || !$asset->getAssetKey()) {
            $this->addFlash('warning', 'Asset not found or has no asset files to edit');
            return $this->redirectToRoute('PapyrillioBerenike_AssetList');
        }

        return $this->render('asset/edit_visual.html.twig', ['asset' => $asset]);
    }

    /**
     * Save edited asset image
     */
    #[IsGranted('ROLE_EDITOR')]
    public function saveEdited(int $id, Request $request): Response
    {
        $asset = $this->imageRepository->findOneBy(['id' => $id]);

        if (!$asset || !$asset->getAssetKey()) {
            return $this->json(['error' => 'Asset not found'], 404);
        }

        $imageData = $request->request->get('imageData');
        $saveMode = $request->request->get('saveMode', 'new'); // 'new' or 'overwrite'

        if (!$imageData) {
            return $this->json(['error' => 'No image data provided'], 400);
        }

        if (!preg_match('/^data:image\/\w+;base64,/', $imageData)) {
            return $this->json(['error' => 'Invalid image data format'], 400);
        }
        $imageData = base64_decode(substr($imageData, strpos($imageData, ',') + 1));
        if ($imageData === false) {
            return $this->json(['error' => 'Base64 decode failed'], 400);
        }

        $tmpDir = $this->projectDir . '/var/tmp';
        if (!is_dir($tmpDir)) {
            mkdir($tmpDir, 0777, true);
        }
        $tempFile = $tmpDir . '/img_edit_' . uniqid() . '.png';
        if (file_put_contents($tempFile, $imageData) === false) {
            return $this->json(['error' => 'Failed to write temporary file'], 500);
        }

        try {
            if ($saveMode === 'overwrite') {
                $assetKey = $asset->getAssetKey();

                // Delete old asset files
                $assetDir = $this->imageService->getAssetDirectory($assetKey);
                if (is_dir($assetDir)) {
                    foreach (glob($assetDir . '/*') as $file) {
                        if (is_file($file)) {
                            unlink($file);
                        }
                    }
                }

                $dimensions = $this->imageService->processImage($tempFile, $assetKey);
                $asset->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));
                $this->entityManager->flush();

                return $this->json([
                    'success' => true,
                    'message' => 'Asset updated successfully',
                    'assetId' => $asset->getId(),
                    'redirectUrl' => $this->generateUrl('PapyrillioBerenike_AssetShow', ['id' => $asset->getId()])
                ]);
            }

            // Save as new: create new Image entity
            $newAssetKey = $asset->getAssetKey() . '_edited_' . time();
            $dimensions = $this->imageService->processImage($tempFile, $newAssetKey);

            $newAsset = new Image();
            $newAsset->setAssetKey($newAssetKey);
            $newAsset->setType($asset->getType());
            $newAsset->setNumber($asset->getNumber() ? $asset->getNumber() . ' (edited)' : 'edited');
            $newAsset->setFile($asset->getFile());
            $newAsset->setPath($newAssetKey);
            $newAsset->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));

            // Copy specialist relationships
            foreach ($asset->getImageSpecialists() as $originalIS) {
                $newIS = new ImageSpecialist();
                $newIS->setImage($newAsset);
                $newIS->setSpecialist($originalIS->getSpecialist());
                $newIS->setYear($originalIS->getYear());
                $this->entityManager->persist($newIS);
                $newAsset->addImageSpecialist($newIS);
            }

            $this->entityManager->persist($newAsset);
            $this->entityManager->flush();

            return $this->json([
                'success' => true,
                'message' => 'New asset created successfully',
                'assetId' => $newAsset->getId(),
                'redirectUrl' => $this->generateUrl('PapyrillioBerenike_AssetShow', ['id' => $newAsset->getId()])
            ]);
        } catch (\Exception $e) {
            $this->logger->error('Asset edit save failed', ['error' => $e->getMessage()]);
            return $this->json(['error' => 'Failed to save asset: ' . $e->getMessage()], 500);
        } finally {
            if (is_file($tempFile)) {
                @unlink($tempFile);
            }
        }
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
