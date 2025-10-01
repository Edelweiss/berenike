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

  public function list(Request $request): Response {
    $entityManager = $this->getDoctrine()->getManager();
    $repository = $entityManager->getRepository(Find::class);
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
      if(in_array($sort, ['year', 'object', 'category', 'created'])){
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

        foreach(['year', 'object', 'category', 'created'] as $field){
          if(strlen($this->getParameter($field))){
            $where .= $prefix . 'f.' . $field . ' LIKE :' . $field;
            $parameters[$field] = '%' . $this->getParameter($field) . '%';
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
          $where .= $prefix . 'l.number = :locus';
          $parameters['locus'] = '%' . $this->getParameter('locus') . '%';
          $prefix = ' AND ';
        }

        if($this->getParameter('bucket')){
          $where .= $prefix . 'b.number = :bucket';
          $parameters['bucket'] = '%' . $this->getParameter('bucket') . '%';
          $prefix = ' AND ';
        }
      }

      // LIMIT

      $query = $entityManager->createQuery('
        SELECT count(DISTINCT f.id) FROM App\Entity\Find f
        LEFT JOIN f.bucket b LEFT JOIN b.locus l JOIN l.excavation e
        ' . $where
      );
      $query->setParameters($parameters);
      $count = $query->getSingleScalarResult();
      $totalPages = ($count > 0 && $limit > 0) ? ceil($count/$limit) : 0;

      // PAGINATION

      $query = $entityManager->createQuery('
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

      $query = $entityManager->createQuery('
        SELECT f, b, l, e FROM App\Entity\Find f
        LEFT JOIN f.bucket b LEFT JOIN b.locus l JOIN l.excavation e ' . $where . ' ' . $orderBy
      );
      $query->setParameters($parameters);

      $finds = $query->getResult();

      return $this->render('find/list.xml.twig', ['finds' => $finds, 'count' => $count, 'totalPages' => $totalPages, 'page' => $page]);
    } else {
      return $this->render('find/list.html.twig', ['finds' => $finds]);
    }
  }

  public function new(): Response {
    $correction = new Correction();

    $correction->setCreator($this->getUser()->getUsername());
    // $this->get('security.context')->getToken()->getUser()->getUsername()

    $entityManager = $this->getDoctrine()->getManager();
    $editionRepository = $entityManager->getRepository(Edition::class);

    $correction->setCompilation($this->getCompilation());
    $correction->setEdition($this->getEdition());

    $registerRepository = $entityManager->getRepository(Register::class);

    $form = $this->createForm(CorrectionNewType::class, $correction, ['attr' => ['wizardUrl' => $this->generateUrl('PapyrillioBeehive_NumberWizardLookup')]]);

    if ($this->request->getMethod() == 'POST') {
      $form->handleRequest($this->request);
      if ($form->isValid()) {
        foreach($this->getParameter('task') as $category => $description){
          if(strlen(trim($description))){
            $task = new Task();
            $task->setCategory($category);
            $task->setDescription(trim($description));
            $task->setCorrection($correction);
            $entityManager->persist($task);
          }
        }

        if($this->getParameter('register')){
          foreach($this->getParameter('register') as $registerId){
            $register = $registerRepository->findOneBy(['id' => $registerId]);
            if($register){
              $correction->addRegisterEntry($register);
            }
          }
        }
        $entityManager->persist($correction);
        $entityManager->flush();

        if($this->getParameter('redirectTarget') === 'new'){
          $this->addFlash('notice', 'Der Datensatz wurde angelegt!');
          return $this->redirect($this->generateUrl('PapyrillioBeehive_CorrectionNew'));
        } else {
          return $this->redirect($this->generateUrl('PapyrillioBeehive_CorrectionShow', ['id' => $correction->getId()]));
        }
      }
    }

    return $this->render('correction/new.html.twig', ['form' => $form->createView(), 'compilations' => $this->getCompilations(), 'editions' => $editionRepository->findBy([], ['sort' => 'asc'])]);
  }

  protected function getCompilation($id = null){
    $entityManager = $this->getDoctrine()->getManager();
    $repository = $entityManager->getRepository(Compilation::class);

    if($id !== null){
      return $repository->findOneBy(['id' => $id]);
    } else if($this->request->getMethod() == 'POST'){
      return $repository->findOneBy(['id' => $this->getParameter('compilation')]);
    } else {
      return $repository->findOneBy(['volume' => 14]);
    }
  }

  protected function getCompilations(){
    $entityManager = $this->getDoctrine()->getManager();
    $repository = $entityManager->getRepository(Compilation::class);

    return $repository->findAll();
  }

  protected function getEdition(){
    $entityManager = $this->getDoctrine()->getManager();
    $repository = $entityManager->getRepository(Edition::class);

    if($this->request->getMethod() == 'POST'){
      return $repository->findOneBy(['id' => $this->getParameter('edition')]);
    }else{
      return $repository->findOneBy(['sort' => 0]);
    }
  }

  public function update($id): Response {
    $this->retrieveCorrection($id);
    $elementId = $this->getParameter('elementid');

    if($elementId == 'compilation'){
      $this->correction->setCompilation($this->getCompilation($this->getParameter('newvalue')));
      $this->entityManager->flush();
      return new Response(htmlspecialchars($this->correction->getCompilation()->getTitle()));
    } else {
      $setter = 'set' . ucfirst($elementId);
      $getter = 'get' . ucfirst($elementId);
      
      $this->correction->$setter($this->getParameter('newvalue'));
      $this->entityManager->flush();
      $this->entityManager->refresh($this->correction);
      return new Response(htmlspecialchars($this->correction->$getter()));
    }
  }

  public function delete($id): Response {
    $entityManager = $this->getDoctrine()->getManager();
    $repository = $entityManager->getRepository(Correction::class);
    $correction = $repository->findOneBy(['id' => $id]);
    foreach($correction->getTasks() as $task){
      $entityManager->remove($task);
    }
    foreach($correction->getIndexEntries() as $indexEntry){
      $entityManager->remove($indexEntry);
    }

    $entityManager->remove($correction);
    $entityManager->flush();
    return $this->redirect($this->generateUrl('PapyrillioBeehive_CorrectionList'));
  }

  public function show($id): Response {
    if(!$id){
      return $this->forward('PapyrillioBerenikeBundle:Find:list');
    }
    $entityManager = $this->getDoctrine()->getManager();
    $repository = $entityManager->getRepository(Find::class);
    $find = $repository->findOneBy(['id' => $id]);

    return $this->render('find/show.html.twig', ['find' => $find]);
  }
  

}
