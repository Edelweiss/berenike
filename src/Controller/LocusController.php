<?php

namespace App\Controller;

use App\Entity\Locus;
use App\Repository\LocusRepository;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;

class LocusController extends BerenikeController
{
    private $entityManager;
    private $locusRepository;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        LocusRepository $locusRepository
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->locusRepository = $locusRepository;
    }

    public function list(Request $request): Response
    {
        $loci = $this->locusRepository->findAll();

        return $this->render('locus/list.html.twig', [
            'loci' => $loci
        ]);
    }

    public function show(Request $request, $id): Response
    {
        $locus = $this->locusRepository->find($id);

        if (!$locus) {
            throw $this->createNotFoundException('Locus not found');
        }

        return $this->render('locus/show.html.twig', [
            'locus' => $locus
        ]);
    }
}
