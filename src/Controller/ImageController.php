<?php

namespace App\Controller;

use App\Entity\Image;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;

class ImageController extends BerenikeController
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

    public function show($id): Response
    {
        if (!$id) {
            return $this->redirectToRoute('PapyrillioBerenike_FindList');
        }

        $repository = $this->entityManager->getRepository(Image::class);
        $image = $repository->findOneBy(['id' => $id]);

        if (!$image) {
            $this->addFlash('warning', 'Image not found');
            return $this->redirectToRoute('PapyrillioBerenike_FindList');
        }

        return $this->render('image/show.html.twig', ['image' => $image]);
    }
}
