<?php

namespace App\Controller;

use App\Entity\Excavation;
use App\Repository\ExcavationRepository;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;

class ExcavationController extends BerenikeController
{
    private $entityManager;
    private $excavationRepository;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        ExcavationRepository $excavationRepository
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->excavationRepository = $excavationRepository;
    }

    public function list(Request $request): Response
    {
        $excavations = $this->excavationRepository->findAll();

        return $this->render('excavation/list.html.twig', [
            'excavations' => $excavations
        ]);
    }

    public function show(Request $request, $id): Response
    {
        $excavation = $this->excavationRepository->find($id);

        if (!$excavation) {
            throw $this->createNotFoundException('Excavation not found');
        }

        return $this->render('excavation/show.html.twig', [
            'excavation' => $excavation
        ]);
    }
}
