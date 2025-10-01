<?php

namespace App\Controller;

use App\Entity\Find;
use App\Entity\Bucket;
use App\Entity\Locus;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;
use App\Repository\BucketRepository;

class BucketController extends BerenikeController
{
    private $entityManager;
    private $bucketRepository;

    public function __construct(
        RequestStack $requestStack,
        LoggerInterface $logger,
        EntityManagerInterface $entityManager,
        BucketRepository $bucketRepository
    ) {
        parent::__construct($requestStack, $logger);
        $this->entityManager = $entityManager;
        $this->bucketRepository = $bucketRepository;
    }

    public function list(Request $request): Response
    {
        $buckets = [];
        if ($this->request->getMethod() == 'POST') {

        // REQUEST PARAMETERS
      
      $limit         = $this->getParameter('rows');
      $page          = $this->getParameter('page');
      $offset        = $page * $limit - $limit;
      $offset        = $offset < 0 ? 0 : $offset;
      $sort          = $this->getParameter('sidx');
      $sortDirection = $this->getParameter('sord');
      $visible       = explode(';', rtrim($this->getParameter('visible'), ';'));

      // SELECT

      $visibleColumns = ['title'];
      foreach($visible as $column){
        if($column != ''){
          $visibleColumns[] = $column;
        }
      }
      $visible = $visibleColumns;

      $this->logger->info('visible: ' . print_r($visible, true));
      $this->logger->info('visible: ' . $this->getParameter('visible'));

      // ODER BY

      $orderBy = '';
      if(in_array($sort, ['number', 'dating', 'remarks', 'created', 'modified'])){
        $orderBy = ' ORDER BY b.' . $sort . ' ' . $sortDirection;
      }
      if($sort == 'locus'){
        $orderBy = ' ORDER BY l.number ' . $sortDirection;
      }

      // WHERE WITH

      $where = '';
      $parameters = [];
      if($this->getParameter('_search') == 'true'){
        $prefix = ' WHERE ';

        foreach(['number', 'dating', 'remarks'] as $field){
          if(strlen($this->getParameter($field))){
            $where .= $prefix . 'b.' . $field . ' LIKE :' . $field;
            $parameters[$field] = '%' . $this->getParameter($field) . '%';
            $prefix = ' AND ';
          }
        }

        if($this->getParameter('locus')){
          $where .= $prefix . 'l.number LIKE :locus';
          $parameters['locus'] = '%' . $this->getParameter('locus') . '%';
          $prefix = ' AND ';
        }
      }

      // LIMIT

      $query = $this->entityManager->createQuery('
        SELECT count(DISTINCT b.id) FROM App\Entity\Bucket b
        LEFT JOIN b.locus l
        ' . $where
      );
      $query->setParameters($parameters);
      $count = $query->getSingleScalarResult();
      $totalPages = ($count > 0 && $limit > 0) ? ceil($count/$limit) : 0;

      // PAGINATION

      $query = $this->entityManager->createQuery('
        SELECT DISTINCT b.id FROM App\Entity\Bucket b
        LEFT JOIN b.locus l
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
      $where .= 'b.id IN (:id)';
      $parameters['id'] = $ids;

      $this->logger->info('limit: ' . $limit);
      $this->logger->info('page: ' . $page);
      $this->logger->info('offset: ' . $offset);
      $this->logger->info('sort: ' . $sort);
      $this->logger->info('sortDirection: ' . $sortDirection);
      $this->logger->info('totalPages: ' . $totalPages);

      // QUERY

      $query = $this->entityManager->createQuery('
        SELECT b, l, f FROM App\Entity\Bucket b
        LEFT JOIN b.locus l LEFT JOIN b.finds f' . $where . ' ' . $orderBy
      );
      $query->setParameters($parameters);

      $buckets = $query->getResult();

      return $this->render('bucket/list.xml.twig', ['buckets' => $buckets, 'count' => $count, 'totalPages' => $totalPages, 'page' => $page]);
    } else {
      return $this->render('bucket/list.html.twig', ['buckets' => $buckets]);
    }
  }

  public function new(): Response {
    $bucket = new Bucket();
    $bucket->setCreated(new \DateTime());
    $bucket->setModified(new \DateTime());

    $form = $this->createForm(BucketType::class, $bucket);

    if ($this->request->getMethod() == 'POST') {
      $form->handleRequest($this->request);
      if ($form->isValid()) {
        $this->entityManager->persist($bucket);
        $this->entityManager->flush();

        $this->addFlash('notice', 'Bucket was created successfully!');
        return $this->redirect($this->generateUrl('PapyrillioBerenike_BucketShow', ['id' => $bucket->getId()]));
      }
    }

    return $this->render('bucket/new.html.twig', ['form' => $form->createView()]);
  }

  public function edit($id): Response {
    $bucket = $this->bucketRepository->find($id);

    if (!$bucket) {
        throw $this->createNotFoundException('Bucket not found');
    }

    $form = $this->createForm(BucketType::class, $bucket);

    if ($this->request->getMethod() == 'POST') {
        $form->handleRequest($this->request);
        if ($form->isValid()) {
            $bucket->setModified(new \DateTime());
            $this->entityManager->flush();

            $this->addFlash('notice', 'Bucket was updated successfully!');
            return $this->redirect($this->generateUrl('PapyrillioBerenike_BucketShow', ['id' => $bucket->getId()]));
        }
    }

    return $this->render('bucket/edit.html.twig', [
        'form' => $form->createView(),
        'bucket' => $bucket
    ]);
  }

  public function delete($id): Response {
    $bucket = $this->bucketRepository->find($id);

    if (!$bucket) {
        throw $this->createNotFoundException('Bucket not found');
    }

    $this->entityManager->remove($bucket);
    $this->entityManager->flush();

    $this->addFlash('notice', 'Bucket was deleted successfully!');
    return $this->redirect($this->generateUrl('PapyrillioBerenike_BucketList'));
  }

  public function show($id): Response {
    if(!$id){
      return $this->forward('PapyrillioBerenikeBundle:Bucket:list');
    }

    $repository = $this->entityManager->getRepository(Bucket::class);
    $bucket = $repository->findOneBy(['id' => $id]);

    return $this->render('bucket/show.html.twig', ['bucket' => $bucket]);
  }
  

}
