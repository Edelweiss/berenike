<?php

namespace App\Controller;

use App\Entity\Find;
use App\Entity\Bucket;
use App\Entity\Locus;
use App\Entity\Excavation;
use App\Form\FindType;
use App\Form\BucketType;
use App\Form\LocusType;
use App\Form\ExcavationType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;

class AdminController extends BerenikeController
{
    private $entityManager;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
    }

    public function newFind(Request $request): Response
    {
        $find = new Find();
        
        $form = $this->createForm(FindType::class, $find);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $find->setCreated(new \DateTime());
            $find->setModified(new \DateTime());
            
            $this->entityManager->persist($find);
            $this->entityManager->flush();

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
}
