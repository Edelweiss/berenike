<?php

namespace App\Controller;

use App\Entity\Locus;
use App\Entity\Excavation;
use App\Form\LocusType;
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
        $loci = [];
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
            if(in_array($sort, ['number', 'addendum', 'description'])){
                $orderBy = ' ORDER BY l.' . $sort . ' ' . $sortDirection;
            } elseif(in_array($sort, ['site', 'season', 'trench'])){
                $orderBy = ' ORDER BY e.' . $sort . ' ' . $sortDirection;
            }

            // WHERE

            $where = '';
            $parameters = [];
            if($this->getParameter('_search') == 'true'){
                $prefix = ' WHERE ';

                if(strlen($this->getParameter('number'))){
                    $where .= $prefix . 'l.number LIKE :number';
                    $parameters['number'] = '%' . $this->getParameter('number') . '%';
                    $prefix = ' AND ';
                }

                if(strlen($this->getParameter('addendum'))){
                    $where .= $prefix . 'l.addendum LIKE :addendum';
                    $parameters['addendum'] = '%' . $this->getParameter('addendum') . '%';
                    $prefix = ' AND ';
                }

                if(strlen($this->getParameter('description'))){
                    $where .= $prefix . 'l.description LIKE :description';
                    $parameters['description'] = '%' . $this->getParameter('description') . '%';
                    $prefix = ' AND ';
                }

                foreach(['site', 'season', 'trench'] as $field){
                    if(strlen($this->getParameter($field))){
                        $where .= $prefix . 'e.' . $field . ' LIKE :' . $field;
                        $parameters[$field] = '%' . $this->getParameter($field) . '%';
                        $prefix = ' AND ';
                    }
                }
            }

            // COUNT

            $query = $this->entityManager->createQuery('
                SELECT count(DISTINCT l.id) FROM App\Entity\Locus l
                JOIN l.excavation e
                ' . $where
            );
            $query->setParameters($parameters);
            $count = $query->getSingleScalarResult();
            $totalPages = ($count > 0 && $limit > 0) ? ceil($count/$limit) : 0;

            // PAGINATION

            $query = $this->entityManager->createQuery('
                SELECT DISTINCT l.id FROM App\Entity\Locus l
                JOIN l.excavation e
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
            $where .= 'l.id IN (:id)';
            $parameters['id'] = $ids;

            // QUERY

            $query = $this->entityManager->createQuery('
                SELECT l FROM App\Entity\Locus l
                JOIN l.excavation e
                ' . $where . ' ' . $orderBy
            );
            $query->setParameters($parameters);

            $loci = $query->getResult();

            return $this->render('locus/list.xml.twig', [
                'loci' => $loci, 
                'count' => $count, 
                'totalPages' => $totalPages, 
                'page' => $page
            ]);
        } else {
            return $this->render('locus/list.html.twig', ['loci' => $loci]);
        }
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

    public function edit(Request $request, $id): Response
    {
        $locus = $this->locusRepository->find($id);
        
        if (!$locus) {
            throw $this->createNotFoundException('Locus not found');
        }

        $form = $this->createForm(LocusType::class, $locus);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->entityManager->flush();

            return $this->redirectToRoute('PapyrillioBerenike_LocusShow', ['id' => $locus->getId()]);
        }

        return $this->render('locus/edit.html.twig', [
            'locus' => $locus,
            'form' => $form->createView(),
        ]);
    }

    /**
     * Search for excavations/trenches by pattern: SITE+SEASON-TRENCH
     * Example: BE98-127
     */
    public function searchExcavations(Request $request): Response
    {
        $query = $request->query->get('q', '');
        
        if (strlen($query) < 2) {
            return $this->json([]);
        }
        
        // Remove trailing separators (-, /) to prevent empty results while typing
        $query = rtrim($query, '-/');
        
        if (strlen($query) < 2) {
            return $this->json([]);
        }
        
        $qb = $this->entityManager->createQueryBuilder();
        $qb->select('e')
            ->from(Excavation::class, 'e');
        
        // Try full format: SITE+SEASON-TRENCH
        if (preg_match('/^([A-Z]{2,3})(\d{1,4})-(.+?)$/i', $query, $matches)) {
            $site = strtoupper($matches[1]);
            $seasonInput = $matches[2];
            $trench = $matches[3];
            
            // Handle both 2-digit and 4-digit year input
            if (strlen($seasonInput) <= 2) {
                $seasonYear = $this->inflateSeason(str_pad($seasonInput, 2, '0', STR_PAD_LEFT));
            } else {
                $seasonYear = $seasonInput;
            }
            
            $qb->where('e.site = :site')
                ->andWhere('LOCATE(:season, e.season) > 0')
                ->andWhere('e.trench LIKE :trench')
                ->setParameter('site', $site)
                ->setParameter('season', $seasonYear)
                ->setParameter('trench', $trench . '%');
        } elseif (preg_match('/^([A-Z]{2,3})(\d{1,4})$/i', $query, $matches)) {
            // Partial: SITE+SEASON
            $site = strtoupper($matches[1]);
            $seasonInput = $matches[2];
            
            if (strlen($seasonInput) <= 2) {
                $seasonYear = $this->inflateSeason(str_pad($seasonInput, 2, '0', STR_PAD_LEFT));
            } else {
                $seasonYear = $seasonInput;
            }
            
            $qb->where('e.site = :site')
                ->andWhere('LOCATE(:season, e.season) > 0')
                ->setParameter('site', $site)
                ->setParameter('season', $seasonYear);
        } elseif (preg_match('/^([A-Z]{2,3})$/i', $query, $matches)) {
            // Partial: SITE only
            $site = strtoupper($matches[1]);
            
            $qb->where('e.site = :site')
                ->setParameter('site', $site);
        } else {
            return $this->json([]);
        }
        
        $qb->setMaxResults(20)
            ->orderBy('e.site', 'ASC')
            ->addOrderBy('e.season', 'ASC')
            ->addOrderBy('e.trench', 'ASC');
        
        $excavations = $qb->getQuery()->getResult();
        
        // Format results
        $results = [];
        foreach ($excavations as $excavation) {
            $label = $excavation->getSite() . $this->formatSeasonDisplay($excavation->getSeason()) . '-' 
                   . $excavation->getTrench();
            
            $results[] = [
                'id' => $excavation->getId(),
                'label' => $label
            ];
        }
        
        return $this->json($results);
    }
    
    private function inflateSeason(string $twoDigitYear): string
    {
        $year = (int)$twoDigitYear;
        
        if ($year >= 95) {
            return '19' . $twoDigitYear;
        } else {
            return '20' . str_pad($twoDigitYear, 2, '0', STR_PAD_LEFT);
        }
    }
    
    private function formatSeasonDisplay(string $season): string
    {
        if (empty($season)) {
            return '';
        }
        
        if (strpos($season, '/') !== false) {
            $years = explode('/', $season);
            $first = substr($years[0], -2);
            $last = substr($years[count($years) - 1], -2);
            return $first . '/' . $last;
        }
        
        return substr($season, -2);
    }
}
