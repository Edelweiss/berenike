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
          $this->addFlash('warning', 'Find not found');
          return $this->redirectToRoute('PapyrillioBerenike_FindList');
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
      if(in_array($sort, ['id', 'year', 'month', 'object', 'objectNo', 'category', 'categoryNo', 'weight', 'quantity', 
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
        $this->addFlash('warning', 'Find not found');
        return $this->redirectToRoute('PapyrillioBerenike_FindList');
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
        $this->addFlash('warning', 'Find not found');
        return $this->redirectToRoute('PapyrillioBerenike_FindList');
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
    foreach ($find->getImages() as $image) {
      // Check if image has type
      if (!$image->getType()) {
        $find->removeImage($image);
      }
    }
  }

  public function exportCsv(Request $request): Response
  {
      // Get parameters from request
      $sort          = $request->query->get('sidx', 'trench');
      $sortDirection = $request->query->get('sord', 'asc');
      $visible       = explode(';', rtrim($request->query->get('visible', ''), ';'));

      // Build visible columns list
      $visibleColumns = [];
      foreach($visible as $column){
        if($column != ''){
          $visibleColumns[] = $column;
        }
      }

      // Build ORDER BY clause
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

      // Build WHERE clause
      $where = '';
      $parameters = [];
      if($request->query->get('_search') == 'true'){
        $prefix = ' WHERE ';

        foreach(['id', 'year', 'month', 'object', 'objectNo', 'category', 'categoryNo', 'weight', 'quantity', 
                 'dimensions', 'preservation', 'description', 'material', 'materialRemarks', 
                 'datingAbsolute', 'typologyReference', 'publications', 'remarks', 'created', 'modified',
                 'inventoryNumber', 'tm', 'date', 'dateRemarks', 'scaRegister', 'rebuildChanges',
                 'heidiconId', 'heidiconUuid', 'heidiconSystemObjectId'] as $field){
          $value = $request->query->get($field);
          if($value && strlen($value)){
            $where .= $prefix . 'f.' . $field . ' LIKE :' . $field . '_search';
            $parameters[$field . '_search'] = '%' . $value . '%';
            $prefix = ' AND ';
          }
        }

        foreach(['trench'] as $field){
          $value = $request->query->get($field);
          if($value && strlen($value)){
            $where .= $prefix . 'e.' . $field . ' LIKE :' . $field;
            $parameters[$field] = '%' . $value . '%';
            $prefix = ' AND ';
          }
        }

        $locusValue = $request->query->get('locus');
        if($locusValue){
          $where .= $prefix . 'l.number LIKE :locus';
          $parameters['locus'] = '%' . $locusValue . '%';
          $prefix = ' AND ';
        }

        $bucketValue = $request->query->get('bucket');
        if($bucketValue){
          $where .= $prefix . 'b.number LIKE :bucket';
          $parameters['bucket'] = '%' . $bucketValue . '%';
          $prefix = ' AND ';
        }
      }

      // Query all matching finds (no limit)
      $query = $this->entityManager->createQuery('
        SELECT f, b, l, e FROM App\Entity\Find f
        LEFT JOIN f.bucket b 
        LEFT JOIN b.locus l 
        JOIN l.excavation e
        ' . $where . ' ' . $orderBy
      );
      $query->setParameters($parameters);
      $finds = $query->getResult();

      // Generate CSV
      $csv = fopen('php://temp', 'r+');
      
      // Write UTF-8 BOM for better Excel compatibility
      fputs($csv, "\xEF\xBB\xBF");

      // Column headers mapping
      $columnHeaders = [
        'id' => 'ID',
        'tm' => 'TM',
        'heidiconId' => 'HeidICON ID',
        'heidiconUuid' => 'HeidICON UUID',
        'heidiconSystemObjectId' => 'HeidICON System Object ID',
        'trench' => 'Trench',
        'locus' => 'Locus',
        'bucket' => 'Bucket',
        'inventoryNumber' => 'Inventory Number',
        'date' => 'Date',
        'year' => 'Year',
        'month' => 'Month',
        'dateRemarks' => 'Date Remarks',
        'scaRegister' => 'SCA Register',
        'object' => 'Object',
        'objectNo' => 'Object No',
        'category' => 'Category',
        'categoryNo' => 'Category No',
        'weight' => 'Weight',
        'quantity' => 'Quantity',
        'dimensions' => 'Dimensions',
        'preservation' => 'Preservation',
        'description' => 'Description',
        'material' => 'Material',
        'materialRemarks' => 'Material Remarks',
        'datingAbsolute' => 'Dating Absolute',
        'typologyReference' => 'Typology Reference',
        'publications' => 'Publications',
        'remarks' => 'Remarks',
        'created' => 'Created',
        'modified' => 'Modified',
      ];

      // Write header row with selected columns
      $headers = [];
      foreach($visibleColumns as $col){
        if(isset($columnHeaders[$col])){
          $headers[] = $columnHeaders[$col];
        }
      }
      fputcsv($csv, $headers);

      // Write data rows
      foreach($finds as $find){
        $row = [];
        foreach($visibleColumns as $col){
          $value = '';
          switch($col){
            case 'id':
              $value = $find->getId();
              break;
            case 'tm':
              $value = $find->getTm();
              break;
            case 'heidiconId':
              $value = $find->getHeidiconId();
              break;
            case 'heidiconUuid':
              $value = $find->getHeidiconUuid();
              break;
            case 'heidiconSystemObjectId':
              $value = $find->getHeidiconSystemObjectId();
              break;
            case 'trench':
              $value = $find->getBucket() && $find->getBucket()->getLocus() && $find->getBucket()->getLocus()->getExcavation() 
                ? $find->getBucket()->getLocus()->getExcavation()->getTrench() : '';
              break;
            case 'locus':
              $value = $find->getBucket() && $find->getBucket()->getLocus() 
                ? $find->getBucket()->getLocus()->getNumber() : '';
              break;
            case 'bucket':
              $value = $find->getBucket() ? $find->getBucket()->getNumber() : '';
              break;
            case 'inventoryNumber':
              $value = $find->getInventoryNumber();
              break;
            case 'date':
              $value = $find->getDate() ? $find->getDate()->format('Y-m-d') : '';
              break;
            case 'year':
              $value = $find->getYear();
              break;
            case 'month':
              $value = $find->getMonth();
              break;
            case 'dateRemarks':
              $value = $find->getDateRemarks();
              break;
            case 'scaRegister':
              $value = $find->getScaRegister();
              break;
            case 'object':
              $value = $find->getObject();
              break;
            case 'objectNo':
              $value = $find->getObjectNo();
              break;
            case 'category':
              $value = $find->getCategory();
              break;
            case 'categoryNo':
              $value = $find->getCategoryNo();
              break;
            case 'weight':
              $value = $find->getWeight();
              break;
            case 'quantity':
              $value = $find->getQuantity();
              break;
            case 'dimensions':
              $value = $find->getDimensions();
              break;
            case 'preservation':
              $value = $find->getPreservation();
              break;
            case 'description':
              $value = $find->getDescription();
              break;
            case 'material':
              $value = $find->getMaterial();
              break;
            case 'materialRemarks':
              $value = $find->getMaterialRemarks();
              break;
            case 'datingAbsolute':
              $value = $find->getDatingAbsolute();
              break;
            case 'typologyReference':
              $value = $find->getTypologyReference();
              break;
            case 'publications':
              $value = $find->getPublications();
              break;
            case 'remarks':
              $value = $find->getRemarks();
              break;
            case 'created':
              $value = $find->getCreated() ? $find->getCreated()->format('Y-m-d H:i:s') : '';
              break;
            case 'modified':
              $value = $find->getModified() ? $find->getModified()->format('Y-m-d H:i:s') : '';
              break;
          }
          $row[] = $value;
        }
        fputcsv($csv, $row);
      }

      rewind($csv);
      $csvContent = stream_get_contents($csv);
      fclose($csv);

      // Return CSV response
      $response = new Response($csvContent);
      $response->headers->set('Content-Type', 'text/csv; charset=utf-8');
      $response->headers->set('Content-Disposition', 'attachment; filename="finds_export_' . date('Y-m-d_His') . '.csv"');
      
      return $response;
  }

}
