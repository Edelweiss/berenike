<?php

namespace App\Controller;

use App\Entity\Find;
use App\Entity\Bucket;
use App\Entity\Locus;
use App\Entity\Excavation;
use App\Entity\Specialist;
use App\Entity\Image;
use App\Entity\ImageSpecialist;
use App\Form\FindType;
use App\Form\BucketType;
use App\Form\LocusType;
use App\Form\ExcavationType;
use App\Form\SpecialistType;
use App\Service\ImageService;
use App\Repository\FindRepository;
use App\Repository\BucketRepository;
use App\Repository\LocusRepository;
use App\Repository\ExcavationRepository;
use App\Repository\SpecialistRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;

class AdminController extends BerenikeController
{
    private $entityManager;
    private $findRepository;
    private $bucketRepository;
    private $locusRepository;
    private $excavationRepository;
    private $specialistRepository;
    private $imageService;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        FindRepository $findRepository,
        BucketRepository $bucketRepository,
        LocusRepository $locusRepository,
        ExcavationRepository $excavationRepository,
        SpecialistRepository $specialistRepository,
        ImageService $imageService
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->findRepository = $findRepository;
        $this->bucketRepository = $bucketRepository;
        $this->locusRepository = $locusRepository;
        $this->excavationRepository = $excavationRepository;
        $this->specialistRepository = $specialistRepository;
        $this->imageService = $imageService;
    }

    public function newFind(Request $request): Response
    {
        $find = new Find();
        
        $form = $this->createForm(FindType::class, $find);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            // Handle new image uploads - access from form, not getData()
            $newImageUploadsForm = $form->get('newImageUploads');
            
            if ($newImageUploadsForm->count() > 0) {
                foreach ($newImageUploadsForm as $index => $uploadForm) {
                    $uploadedFile = $uploadForm->get('uploadedFile')->getData();
                    
                    $this->logger->info('Processing upload form', [
                        'index' => $index,
                        'has_file' => $uploadedFile !== null,
                        'file_name' => $uploadedFile ? $uploadedFile->getClientOriginalName() : null
                    ]);
                    
                    if ($uploadedFile) {
                        try {
                            $type = $uploadForm->get('type')->getData() ?? 'photo';
                            $specialist = $uploadForm->get('specialist')->getData();
                            $speciality = $uploadForm->get('speciality')->getData();
                            $year = $uploadForm->get('year')->getData();
                            
                            // Generate asset_key from filename
                            $originalFilename = $uploadedFile->getClientOriginalName();
                            $assetKey = $this->imageService->generateAssetKey($originalFilename);
                            
                            // Create new Image entity
                            $image = new Image();
                            $image->setAssetKey($assetKey);
                            $image->setType($type);
                            $image->setFile($originalFilename);
                            $image->setPath($assetKey);
                            
                            // Use uploaded file's temporary path
                            $tempPath = $uploadedFile->getRealPath();
                            
                            // Process the image
                            $dimensions = $this->imageService->processImage($tempPath, $assetKey);
                            $image->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));
                            
                            // Handle specialist data if provided
                            if ($specialist || $speciality || $year) {
                                $imageSpecialist = new ImageSpecialist();
                                $imageSpecialist->setImage($image);
                                
                                if ($specialist) {
                                    $imageSpecialist->setSpecialist($specialist);
                                }
                                if ($speciality) {
                                    $imageSpecialist->setSpeciality($speciality);
                                }
                                if ($year) {
                                    $imageSpecialist->setYear($year);
                                }
                                
                                $image->addImageSpecialist($imageSpecialist);
                                $this->entityManager->persist($imageSpecialist);
                            }
                            
                            // Link image to find
                            $find->addImage($image);
                            $this->entityManager->persist($image);
                            
                        } catch (\Exception $e) {
                            $this->logger->error('Failed to process uploaded image: ' . $e->getMessage());
                            $this->addFlash('error', 'Failed to process image: ' . $originalFilename);
                        }
                    }
                }
            }
            
            $find->setCreated(new \DateTime());
            $find->setModified(new \DateTime());
            
            $this->entityManager->persist($find);
            $this->entityManager->flush();

            $this->addFlash('success', 'Find created successfully');
            return $this->redirectToRoute('PapyrillioBerenike_FindShow', ['id' => $find->getId()]);
        }

        return $this->render('admin/newFind.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    public function newBucket(Request $request): Response
    {
        $bucket = new Bucket();
        
        $form = $this->createForm(BucketType::class, $bucket);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->entityManager->persist($bucket);
            $this->entityManager->flush();

            return $this->redirectToRoute('PapyrillioBerenike_BucketShow', ['id' => $bucket->getId()]);
        }

        return $this->render('admin/newBucket.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    public function newLocus(Request $request): Response
    {
        $locus = new Locus();
        
        $form = $this->createForm(LocusType::class, $locus);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->entityManager->persist($locus);
            $this->entityManager->flush();

            return $this->redirectToRoute('PapyrillioBerenike_LocusShow', ['id' => $locus->getId()]);
        }

        return $this->render('admin/newLocus.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    public function newTrench(Request $request): Response
    {
        $excavation = new Excavation();
        
        $form = $this->createForm(ExcavationType::class, $excavation);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->entityManager->persist($excavation);
            $this->entityManager->flush();

            return $this->redirectToRoute('PapyrillioBerenike_ExcavationShow', ['id' => $excavation->getId()]);
        }

        return $this->render('admin/newTrench.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    public function deleteFind(Request $request, $id): Response
    {
        $find = $this->findRepository->find($id);
        
        if (!$find) {
            throw $this->createNotFoundException('Find not found');
        }

        $this->entityManager->remove($find);
        $this->entityManager->flush();

        $this->addFlash('success', 'Find deleted successfully');
        return $this->redirectToRoute('PapyrillioBerenike_FindList');
    }

    public function deleteBucket(Request $request, $id): Response
    {
        $bucket = $this->bucketRepository->find($id);
        
        if (!$bucket) {
            throw $this->createNotFoundException('Bucket not found');
        }

        $this->entityManager->remove($bucket);
        $this->entityManager->flush();

        $this->addFlash('success', 'Bucket deleted successfully');
        return $this->redirectToRoute('PapyrillioBerenike_BucketList');
    }

    public function deleteLocus(Request $request, $id): Response
    {
        $locus = $this->locusRepository->find($id);
        
        if (!$locus) {
            throw $this->createNotFoundException('Locus not found');
        }

        $this->entityManager->remove($locus);
        $this->entityManager->flush();

        $this->addFlash('success', 'Locus deleted successfully');
        return $this->redirectToRoute('PapyrillioBerenike_LocusList');
    }

    public function deleteTrench(Request $request, $id): Response
    {
        $excavation = $this->excavationRepository->find($id);
        
        if (!$excavation) {
            throw $this->createNotFoundException('Trench not found');
        }

        $this->entityManager->remove($excavation);
        $this->entityManager->flush();

        $this->addFlash('success', 'Trench deleted successfully');
        return $this->redirectToRoute('PapyrillioBerenike_ExcavationList');
    }

    public function newSpecialist(Request $request): Response
    {
        $specialist = new Specialist();
        
        $form = $this->createForm(SpecialistType::class, $specialist);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->entityManager->persist($specialist);
            $this->entityManager->flush();

            return $this->redirectToRoute('PapyrillioBerenike_SpecialistShow', ['id' => $specialist->getId()]);
        }

        return $this->render('admin/newSpecialist.html.twig', [
            'form' => $form->createView(),
        ]);
    }

    public function deleteSpecialist(Request $request, $id): Response
    {
        $specialist = $this->specialistRepository->find($id);
        
        if (!$specialist) {
            throw $this->createNotFoundException('Specialist not found');
        }

        $this->entityManager->remove($specialist);
        $this->entityManager->flush();

        $this->addFlash('success', 'Specialist deleted successfully');
        return $this->redirectToRoute('PapyrillioBerenike_SpecialistList');
    }
}
