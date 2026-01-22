<?php

namespace App\Controller;

use App\Entity\Specialist;
use App\Form\SpecialistType;
use App\Repository\SpecialistRepository;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;

class SpecialistController extends BerenikeController
{
    private $entityManager;
    private $specialistRepository;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        SpecialistRepository $specialistRepository
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->specialistRepository = $specialistRepository;
    }

    public function list(Request $request): Response
    {
        $specialists = [];
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
            if(in_array($sort, ['name'])){
                $orderBy = ' ORDER BY s.' . $sort . ' ' . $sortDirection;
            }

            // WHERE

            $where = '';
            $parameters = [];
            if($this->getParameter('_search') == 'true'){
                $prefix = ' WHERE ';

                if(strlen($this->getParameter('name'))){
                    $where .= $prefix . 's.name LIKE :name';
                    $parameters['name'] = '%' . $this->getParameter('name') . '%';
                    $prefix = ' AND ';
                }
            }

            // COUNT

            $query = $this->entityManager->createQuery('
                SELECT count(DISTINCT s.id) FROM App\Entity\Specialist s
                ' . $where
            );
            $query->setParameters($parameters);
            $count = $query->getSingleScalarResult();
            $totalPages = ($count > 0 && $limit > 0) ? ceil($count/$limit) : 0;

            // PAGINATION

            $query = $this->entityManager->createQuery('
                SELECT DISTINCT s.id FROM App\Entity\Specialist s
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
            $where .= 's.id IN (:id)';
            $parameters['id'] = $ids;

            // QUERY

            $query = $this->entityManager->createQuery('
                SELECT s FROM App\Entity\Specialist s
                ' . $where . ' ' . $orderBy
            );
            $query->setParameters($parameters);

            $specialists = $query->getResult();

            return $this->render('specialist/list.xml.twig', [
                'specialists' => $specialists, 
                'count' => $count, 
                'totalPages' => $totalPages, 
                'page' => $page
            ]);
        } else {
            return $this->render('specialist/list.html.twig', ['specialists' => $specialists]);
        }
    }

    public function show(Request $request, $id): Response
    {
        $specialist = $this->specialistRepository->find($id);

        if (!$specialist) {
            throw $this->createNotFoundException('Specialist not found');
        }

        return $this->render('specialist/show.html.twig', [
            'specialist' => $specialist
        ]);
    }

    public function edit(Request $request, $id): Response
    {
        $specialist = $this->specialistRepository->find($id);
        
        if (!$specialist) {
            throw $this->createNotFoundException('Specialist not found');
        }

        $form = $this->createForm(SpecialistType::class, $specialist);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->entityManager->flush();

            return $this->redirectToRoute('PapyrillioBerenike_SpecialistShow', ['id' => $specialist->getId()]);
        }

        return $this->render('specialist/edit.html.twig', [
            'specialist' => $specialist,
            'form' => $form->createView(),
        ]);
    }
}
