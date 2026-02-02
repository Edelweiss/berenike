<?php

namespace App\Controller;

use App\Repository\FindRepository;
use Symfony\Component\HttpFoundation\Response;
use Doctrine\ORM\EntityManagerInterface;

class HomeController extends BerenikeController{
    private $entityManager;
    private $findRepository;

    public function __construct(
        \Symfony\Component\HttpFoundation\RequestStack $requestStack,
        \Psr\Log\LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        FindRepository $findRepository
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->findRepository = $findRepository;
    }

    public function index(): Response {
        return $this->render('home/index.html.twig');
    }

    public function dashboard(): Response {
        // Fetch specific Find records
        $findIds = [20742, 213, 1110];
        $finds = $this->findRepository->findBy(['id' => $findIds]);

        // Get finds count per year
        $findsPerYear = $this->entityManager->createQuery(
            'SELECT f.year, COUNT(f.id) as count
             FROM App\Entity\Find f
             WHERE f.year IS NOT NULL
             GROUP BY f.year
             ORDER BY f.year ASC'
        )->getResult();

        // Get finds count per trench
        $findsPerTrench = $this->entityManager->createQuery(
            'SELECT e.site, e.trench, COUNT(f.id) as count
             FROM App\Entity\Find f
             JOIN f.bucket b
             JOIN b.locus l
             JOIN l.excavation e
             WHERE e.trench IS NOT NULL
             GROUP BY e.trench
             ORDER BY e.site, e.trench+0, e.trench ASC'
        )->getResult();

        return $this->render('home/dashboard.html.twig', [
            'finds' => $finds,
            'findsPerYear' => $findsPerYear,
            'findsPerTrench' => $findsPerTrench
        ]);
    }

    public function about(): Response {
        return $this->render('home/about.html.twig');
    }
    public function contact(): Response {
        return $this->render('home/contact.html.twig');
    }
    public function help(): Response {
        return $this->render('home/help.html.twig');
    }
    
    public function info(): Response {
        return $this->render('home/info.html.twig');
    }
}
