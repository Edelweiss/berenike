<?php

namespace App\Controller;

use App\Entity\Find;
use App\Entity\Bucket;
use App\Entity\Locus;
use App\Entity\Image;
use App\Entity\ImageSpecialist;
use App\Form\FindType;
use App\Service\ImageService;
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
  private $imageService;

  public function __construct(
      RequestStack $requestStack,
      LoggerInterface $logger,
      EntityManagerInterface $entityManager,
      FindRepository $findRepository,
      ImageService $imageService) {
      parent::__construct($requestStack, $logger);
      $this->entityManager = $entityManager;
      $this->findRepository = $findRepository;
      $this->imageService = $imageService;
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
          // Debug: Check what's in the request
          $files = $request->files->all();
          $this->logger->info('Request files', ['files' => $files]);
          
          // Handle new image uploads - access from form, not getData()
          $newImageUploadsForm = $form->get('newImageUploads');
          
          if ($newImageUploadsForm->count() > 0) {
              foreach ($newImageUploadsForm as $index => $uploadForm) {
                  $uploadedFile = $uploadForm->get('uploadedFile')->getData();
                  
                  $this->logger->info('Processing upload form', [
                      'index' => $index,
                      'has_file' => $uploadedFile !== null,
                      'file_name' => $uploadedFile ? $uploadedFile->getClientOriginalName() : null
                  ]);
                  
                  if ($uploadedFile) {
                      try {
                          $type = $uploadForm->get('type')->getData() ?? 'photo';
                          $specialist = $uploadForm->get('specialist')->getData();
                          $speciality = $uploadForm->get('speciality')->getData();
                          $year = $uploadForm->get('year')->getData();
                          
                          // Generate asset_key from filename
                          $originalFilename = $uploadedFile->getClientOriginalName();
                          $assetKey = $this->imageService->generateAssetKey($originalFilename);
                          
                          // Check if image with this assetKey already exists
                          $imageRepository = $this->entityManager->getRepository(Image::class);
                          $existingImage = $imageRepository->findOneBy(['assetKey' => $assetKey]);
                          
                          if ($existingImage) {
                              // Use existing image, just link it to the find
                              $this->logger->info('Image already exists, linking to find', ['assetKey' => $assetKey]);
                              $image = $existingImage;
                          } else {
                              // Create new Image entity
                              $image = new Image();
                              $image->setAssetKey($assetKey);
                              $image->setType($type);
                              $image->setFile($originalFilename);
                              $image->setPath($assetKey);
                              
                              // Use uploaded file's temporary path
                              $tempPath = $uploadedFile->getRealPath();
                              
                              // Process the image
                              $dimensions = $this->imageService->processImage($tempPath, $assetKey);
                              $image->setSize(sprintf('%d,%d', $dimensions['width'], $dimensions['height']));
                          }
                          // Handle specialist data if provided (only for new images)
                          if (!$existingImage && ($specialist || $speciality || $year)) {
                              $imageSpecialist = new ImageSpecialist();
                              $imageSpecialist->setImage($image);
                              
                              if ($specialist) {
                                  $imageSpecialist->setSpecialist($specialist);
                              }
                              if ($speciality) {
                                  $imageSpecialist->setSpeciality($speciality);
                              }
                              if ($year) {
                                  $imageSpecialist->setYear($year);
                              }
                              
                              $image->addImageSpecialist($imageSpecialist);
                              $this->entityManager->persist($imageSpecialist);
                          }
                          
                          // Link image to find
                          $find->addImage($image);
                          if (!$existingImage) {
                              $this->entityManager->persist($image);
                          }
                          
                      } catch (\Exception $e) {
                          $this->logger->error('Failed to process uploaded image: ' . $e->getMessage());
                          $this->addFlash('error', 'Failed to process image: ' . $originalFilename);
                      }
                  }
              }
          }
          
          $find->setModified(new \DateTime());
          $this->entityManager->flush();

          $this->addFlash('success', 'Find updated successfully');
          return $this->redirectToRoute('PapyrillioBerenike_FindShow', ['id' => $find->getId()]);
      }

      return $this->render('find/edit.html.twig', [
          'find' => $find,
          'form' => $form->createView(),
      ]);
  }

  public function list(Request $request): Response {
    $finds = [];
    $session = $request->getSession();
    
    if ($this->request->getMethod() == 'POST') {

      // REQUEST PARAMETERS

      $limit         = $this->getParameter('rows');
      $page          = $this->getParameter('page');
      $offset        = $page * $limit - $limit;
      $offset        = $offset < 0 ? 0 : $offset;
      $sort          = $this->getParameter('sidx');
      $sortDirection = $this->getParameter('sord');
      $visible       = explode(';', rtrim($this->getParameter('visible'), ';'));
      
      // Store grid state in session
      $gridState = [
        'page' => $page,
        'rows' => $limit,
        'sidx' => $sort,
        'sord' => $sortDirection,
        'visible' => $this->getParameter('visible'),
        'search' => $this->getParameter('_search'),
        'filters' => []
      ];
      
      // Store filter values
      foreach(['id', 'year', 'month', 'object', 'objectNo', 'category', 'categoryNo', 'weight', 'quantity', 
               'dimensions', 'preservation', 'description', 'material', 'materialRemarks', 
               'datingAbsolute', 'typologyReference', 'publications', 'literature', 'remarks', 'created', 'modified',
               'inventoryNumber', 'tm', 'date', 'dateRemarks', 'scaRegister', 'rebuildChanges',
               'heidiconId', 'heidiconUuid', 'heidiconSystemObjectId', 'trench', 'locus', 'bucket'] as $field) {
        $value = $this->getParameter($field);
        if ($value !== null && $value !== '') {
          $gridState['filters'][$field] = $value;
        }
      }
      
      $session->set('find_grid_state', $gridState);

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
                          'datingAbsolute', 'typologyReference', 'publications', 'literature', 'remarks', 'created', 'modified',
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
                 'datingAbsolute', 'typologyReference', 'publications', 'literature', 'remarks', 'created', 'modified',
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
      // Get saved grid state from session
      $gridState = $session->get('find_grid_state', []);
      
      return $this->render('find/list.html.twig', [
        'finds' => $finds,
        'gridState' => $gridState
      ]);
    }
  }

  public function resetView(Request $request): Response {
    $session = $request->getSession();
    $session->remove('find_grid_state');
    return $this->redirectToRoute('PapyrillioBerenike_FindList');
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
                          'datingAbsolute', 'typologyReference', 'publications', 'literature', 'remarks', 'created', 'modified',
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
                 'datingAbsolute', 'typologyReference', 'publications', 'literature', 'remarks', 'created', 'modified',
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
        'literature' => 'Literature',
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
            case 'literature':
              $value = $find->getLiterature();
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

  public function searchBuckets(Request $request): Response
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
      
      // Try to parse progressive input
      // Patterns to match:
      // 1. Full format: SITE+SEASON-TRENCH/LOCUS/BUCKET (e.g., BE98-127/999/1)
      // 2. Partial with trench: SITE+SEASON-TRENCH (e.g., BE98-127)
      // 3. Site with season: SITE+SEASON (e.g., BE98 or AG26)
      // 4. Site only: SITE (e.g., BE or AG)
      
      $qb = $this->entityManager->createQueryBuilder();
      $qb->select('b', 'l', 'e')
          ->from(Bucket::class, 'b')
          ->join('b.locus', 'l')
          ->join('l.excavation', 'e');
      
      // Try full format first
      if (preg_match('/^([A-Z]{2,3})(\d{2})-(.+?)\/(.+?)\/(.+)$/i', $query, $matches)) {
          // Full format: SITE+SEASON-TRENCH/LOCUS/BUCKET
          $site = strtoupper($matches[1]);
          $seasonShort = $matches[2];
          $trench = $matches[3];
          $locusNum = $matches[4];
          $bucketNum = $matches[5];
          $seasonYear = $this->inflateSeason($seasonShort);
          
          $qb->where('e.site = :site')
              ->andWhere('LOCATE(:season, e.season) > 0')
              ->andWhere('e.trench = :trench')
              ->andWhere('l.number = :locus')
              ->andWhere('b.number = :bucket')
              ->setParameter('site', $site)
              ->setParameter('season', $seasonYear)
              ->setParameter('trench', $trench)
              ->setParameter('locus', $locusNum)
              ->setParameter('bucket', $bucketNum);
      } elseif (preg_match('/^([A-Z]{2,3})(\d{2})-(.+?)\/(.+?)$/i', $query, $matches)) {
          // Partial: SITE+SEASON-TRENCH/LOCUS
          $site = strtoupper($matches[1]);
          $seasonShort = $matches[2];
          $trench = $matches[3];
          $locusNum = $matches[4];
          $seasonYear = $this->inflateSeason($seasonShort);
          
          $qb->where('e.site = :site')
              ->andWhere('LOCATE(:season, e.season) > 0')
              ->andWhere('e.trench = :trench')
              ->andWhere('l.number = :locus')
              ->setParameter('site', $site)
              ->setParameter('season', $seasonYear)
              ->setParameter('trench', $trench)
              ->setParameter('locus', $locusNum);
      } elseif (preg_match('/^([A-Z]{2,3})(\d{2})-(.+?)$/i', $query, $matches)) {
          // Partial: SITE+SEASON-TRENCH
          $site = strtoupper($matches[1]);
          $seasonShort = $matches[2];
          $trench = $matches[3];
          $seasonYear = $this->inflateSeason($seasonShort);
          
          $qb->where('e.site = :site')
              ->andWhere('LOCATE(:season, e.season) > 0')
              ->andWhere('e.trench LIKE :trench')
              ->setParameter('site', $site)
              ->setParameter('season', $seasonYear)
              ->setParameter('trench', $trench . '%');
      } elseif (preg_match('/^([A-Z]{2,3})(\d{1,4})$/i', $query, $matches)) {
          // Partial: SITE+SEASON (e.g., AG26, BE98, AG2026)
          $site = strtoupper($matches[1]);
          $seasonInput = $matches[2];
          
          // Handle both 2-digit and 4-digit year input
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
          // Partial: SITE only (e.g., AG, BE)
          $site = strtoupper($matches[1]);
          
          $qb->where('e.site = :site')
              ->setParameter('site', $site);
      } else {
          // No match - return empty
          return $this->json([]);
      }
      
      $qb->setMaxResults(20)
          ->orderBy('e.site', 'ASC')
          ->addOrderBy('e.season', 'ASC')
          ->addOrderBy('e.trench', 'ASC')
          ->addOrderBy('l.number', 'ASC')
          ->addOrderBy('b.number', 'ASC');
      
      $buckets = $qb->getQuery()->getResult();
      
      // Format results
      $results = [];
      foreach ($buckets as $bucket) {
          $locus = $bucket->getLocus();
          $excavation = $locus->getExcavation();
          $label = $excavation->getSite() . $this->formatSeasonDisplay($excavation->getSeason()) . '-' 
                 . $excavation->getTrench() . '/' . $locus->getNumber() . '/' . $bucket->getNumber();
          
          $results[] = [
              'id' => $bucket->getId(),
              'label' => $label
          ];
      }
      
      return $this->json($results);
  }
  
  private function inflateSeason(string $twoDigitYear): string
  {
      $year = (int)$twoDigitYear;
      
      // Assume 20th century for years >= 95, 21st century for years < 95
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
      
      // Extract all 4-digit years
      preg_match_all('/\d{4}/', $season, $matches);
      $years = $matches[0];
      
      if (empty($years)) {
          return $season;
      }
      
      if (count($years) === 1) {
          return substr($years[0], -2);
      } else {
          return substr($years[0], -2) . '/' . substr(end($years), -2);
      }
  }

}
