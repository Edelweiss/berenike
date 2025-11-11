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
        $findIds = [20742, 1110, 27904];
        $finds = $this->findRepository->findBy(['id' => $findIds]);

        return $this->render('home/dashboard.html.twig', [
            'finds' => $finds
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
}
