<?php

namespace App\Controller;

use App\Entity\Find;
use App\Entity\Bucket;
use App\Entity\Locus;
use App\Form\FindType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;
use App\Repository\FindRepository;

class FindController extends BerenikeController
{
  private $entityManager;
  private $findRepository;

  public function __construct(
      RequestStack $requestStack,
      LoggerInterface $logger,
      EntityManagerInterface $entityManager,
      FindRepository $findRepository) {
      parent::__construct($requestStack, $logger);
      $this->entityManager = $entityManager;
      $this->findRepository = $findRepository;
  }

  public function edit(Request $request, $id): Response
  {
      $find = $this->findRepository->find($id);
      if (!$find) {
          throw $this->createNotFoundException('Find not found');
      }

      $form = $this->createForm(FindType::class, $find);
      $form->handleRequest($request);

      if ($form->isSubmitted() && $form->isValid()) {
          // Filter out empty/incomplete image entries
          $this->filterEmptyImages($find);
          
          $find->setModified(new \DateTime());
          $this->entityManager->flush();

          return $this->redirectToRoute('PapyrillioBerenike_FindShow', ['id' => $find->getId()]);
      }

      return $this->render('find/edit.html.twig', [
          'find' => $find,
          'form' => $form->createView(),
      ]);
  }

  public function list(Request $request): Response {
    $finds = [];
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

      $visibleColumns = ['object'];
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
      if(in_array($sort, ['year', 'month', 'object', 'objectNo', 'category', 'categoryNo', 'weight', 'quantity', 
                          'dimensions', 'preservation', 'description', 'material', 'materialRemarks', 
                          'datingAbsolute', 'typologyReference', 'publications', 'remarks', 'created', 'modified',
                          'inventoryNumber', 'tm', 'date', 'dateRemarks', 'scaRegister', 'rebuildChanges',
                          'heidiconId', 'heidiconUuid', 'heidiconSystemObjectId'])){
        $orderBy = ' ORDER BY f.' . $sort . ' ' . $sortDirection;
      } elseif($sort === 'trench'){
        $orderBy = ' ORDER BY e.' . $sort . ' ' . $sortDirection;
      } elseif($sort === 'locus'){
        $orderBy = ' ORDER BY l.number ' . $sortDirection;
      } elseif($sort === 'bucket'){
        $orderBy = ' ORDER BY b.number ' . $sortDirection;
      }

      // WHERE WITH

      $where = '';
      $with = '';
      $parameters = [];
      if($this->getParameter('_search') == 'true'){
        $prefix = ' WHERE ';

        foreach(['id', 'year', 'month', 'object', 'objectNo', 'category', 'categoryNo', 'weight', 'quantity', 
                 'dimensions', 'preservation', 'description', 'material', 'materialRemarks', 
                 'datingAbsolute', 'typologyReference', 'publications', 'remarks', 'created', 'modified',
                 'inventoryNumber', 'tm', 'date', 'dateRemarks', 'scaRegister', 'rebuildChanges',
                 'heidiconId', 'heidiconUuid', 'heidiconSystemObjectId'] as $field){
          if(strlen($this->getParameter($field))){
            $where .= $prefix . 'f.' . $field . ' LIKE :' . $field . '_search';
            $parameters[$field . '_search'] = '%' . $this->getParameter($field) . '%';
            $prefix = ' AND ';
          }
        }

        foreach(['trench'] as $field){
          if(strlen($this->getParameter($field))){
            $where .= $prefix . 'e.' . $field . ' LIKE :' . $field;
            $parameters[$field] = '%' . $this->getParameter($field) . '%';
            $prefix = ' AND ';
          }
        }

        if($this->getParameter('locus')){
          $where .= $prefix . 'l.number LIKE :locus';
          $parameters['locus'] = '%' . $this->getParameter('locus') . '%';
          $prefix = ' AND ';
        }

        if($this->getParameter('bucket')){
          $where .= $prefix . 'b.number LIKE :bucket';
          $parameters['bucket'] = '%' . $this->getParameter('bucket') . '%';
          $prefix = ' AND ';
        }
      }

      // LIMIT

      $query = $this->entityManager->createQuery('
        SELECT count(DISTINCT f.id) FROM App\Entity\Find f
        LEFT JOIN f.bucket b LEFT JOIN b.locus l JOIN l.excavation e
        ' . $where
      );
      $query->setParameters($parameters);
      $count = $query->getSingleScalarResult();
      $totalPages = ($count > 0 && $limit > 0) ? ceil($count/$limit) : 0;

      // PAGINATION

      $query = $this->entityManager->createQuery('
        SELECT DISTINCT f.id FROM App\Entity\Find f
        LEFT JOIN f.bucket b LEFT JOIN b.locus l JOIN l.excavation e
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
      $where .= 'f.id IN (:id)';
      $parameters['id'] = $ids;

      $this->logger->info('limit: ' . $limit);
      $this->logger->info('page: ' . $page);
      $this->logger->info('offset: ' . $offset);
      $this->logger->info('sort: ' . $sort);
      $this->logger->info('sortDirection: ' . $sortDirection);
      $this->logger->info('totalPages: ' . $totalPages);

      // QUERY

      $query = $this->entityManager->createQuery('
        SELECT f, b, l, e, fs FROM App\Entity\Find f
        LEFT JOIN f.bucket b 
        LEFT JOIN b.locus l 
        JOIN l.excavation e
        LEFT JOIN f.findSpecialists fs ' . $where . ' ' . $orderBy
      );
      $query->setParameters($parameters);

      $finds = $query->getResult();

      return $this->render('find/list.xml.twig', ['finds' => $finds, 'count' => $count, 'totalPages' => $totalPages, 'page' => $page]);
    } else {
      return $this->render('find/list.html.twig', ['finds' => $finds]);
    }
  }

  public function new(): Response {
    $find = new Find();
    $find->setCreated(new \DateTime());
    $find->setModified(new \DateTime());

    $form = $this->createForm(FindType::class, $find);

    if ($this->request->getMethod() == 'POST') {
      $form->handleRequest($this->request);
      if ($form->isValid()) {
        // Filter out empty/incomplete image entries
        $this->filterEmptyImages($find);
        
        $this->entityManager->persist($find);
        $this->entityManager->flush();

        $this->addFlash('notice', 'Find was created successfully!');
        return $this->redirect($this->generateUrl('PapyrillioBerenike_FindShow', ['id' => $find->getId()]));
      }
    }

    return $this->render('find/new.html.twig', ['form' => $form->createView()]);
  }

  public function delete($id): Response {
    $find = $this->findRepository->find($id);
    
    if (!$find) {
        throw $this->createNotFoundException('Find not found');
    }

    $this->entityManager->remove($find);
    $this->entityManager->flush();

    $this->addFlash('notice', 'Find was deleted successfully!');
    return $this->redirect($this->generateUrl('PapyrillioBerenike_FindList'));
  }

  public function show($id, Request $request): Response {
    if(!$id){
      return $this->forward('PapyrillioBerenikeBundle:Find:list');
    }
    
    $find = $this->findRepository->find($id);
    if (!$find) {
        throw $this->createNotFoundException('Find not found');
    }

    // Check which route was used to access this action
    $route = $request->attributes->get('_route');
    if ($route === 'PapyrillioBerenike_FindShowForHeidIcon') {
        return $this->render('find/showForHeidIcon.html.twig', ['find' => $find]);
    }
    return $this->render('find/show.html.twig', ['find' => $find]);
  }
  
  /**
   * Filter out empty or incomplete image entries from a find.
   * An image is considered empty if it has no type or no valid image specialists.
   * A valid image specialist must have a specialist relationship.
   */
  private function filterEmptyImages(Find $find): void
  {
      $imagesToRemove = [];
      
      foreach ($find->getImages() as $image) {
          // Check if image has type
          if (!$image->getType()) {
              $imagesToRemove[] = $image;
              continue;
          }
          
          // Check if image has at least one valid image specialist
          $hasValidSpecialist = false;
          foreach ($image->getImageSpecialists() as $imageSpecialist) {
              if ($imageSpecialist !== null && $imageSpecialist->getSpecialist() !== null) {
                  $hasValidSpecialist = true;
                  break;
              }
          }
          
          if (!$hasValidSpecialist) {
              $imagesToRemove[] = $image;
          }
      }
      
      // Remove empty images
      foreach ($imagesToRemove as $image) {
          $find->removeImage($image);
      }
      
      if (count($imagesToRemove) > 0) {
          $this->logger->info(sprintf('Filtered out %d empty image(s) from find', count($imagesToRemove)));
      }
  }

}
