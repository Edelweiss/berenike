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
        $excavations = [];
        if ($this->request->getMethod() == 'POST') {

            // REQUEST PARAMETERS

            $limit         = $this->getParameter('rows');
            $page          = $this->getParameter('page');
            $offset        = $page * $limit - $limit;
            $offset        = $offset < 0 ? 0 : $offset;
            $sort          = $this->getParameter('sidx');
            $sortDirection = $this->getParameter('sord');

            // ORDER BY

            $orderBy = '';
            if(in_array($sort, ['site', 'season', 'trench', 'year', 'context'])){
                $orderBy = ' ORDER BY e.' . $sort . ' ' . $sortDirection;
            }

            // WHERE

            $where = '';
            $parameters = [];
            if($this->getParameter('_search') == 'true'){
                $prefix = ' WHERE ';

                foreach(['site', 'season', 'trench', 'context'] as $field){
                    if(strlen($this->getParameter($field))){
                        $where .= $prefix . 'e.' . $field . ' LIKE :' . $field;
                        $parameters[$field] = '%' . $this->getParameter($field) . '%';
                        $prefix = ' AND ';
                    }
                }

                if($this->getParameter('year')){
                    $where .= $prefix . 'e.year = :year';
                    $parameters['year'] = $this->getParameter('year');
                    $prefix = ' AND ';
                }
            }

            // COUNT

            $query = $this->entityManager->createQuery('
                SELECT count(DISTINCT e.id) FROM App\Entity\Excavation e
                ' . $where
            );
            $query->setParameters($parameters);
            $count = $query->getSingleScalarResult();
            $totalPages = ($count > 0 && $limit > 0) ? ceil($count/$limit) : 0;

            // PAGINATION

            $query = $this->entityManager->createQuery('
                SELECT DISTINCT e.id FROM App\Entity\Excavation e
                ' . $where . ' ' . $orderBy
            );
            $query->setParameters($parameters);
            $query->setFirstResult($offset)->setMaxResults($limit);

            $result = $query->getScalarResult();
            $ids = [];
            foreach ($result as $row) {
                $ids[] = $row['id'];
            }
            if($where === ''){
                $where = ' WHERE ';
            } else {
                $where .= ' AND ';
            }
            $where .= 'e.id IN (:id)';
            $parameters['id'] = $ids;

            // QUERY

            $query = $this->entityManager->createQuery('
                SELECT e FROM App\Entity\Excavation e
                ' . $where . ' ' . $orderBy
            );
            $query->setParameters($parameters);

            $excavations = $query->getResult();

            return $this->render('excavation/list.xml.twig', [
                'excavations' => $excavations, 
                'count' => $count, 
                'totalPages' => $totalPages, 
                'page' => $page
            ]);
        } else {
            return $this->render('excavation/list.html.twig', ['excavations' => $excavations]);
        }
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
