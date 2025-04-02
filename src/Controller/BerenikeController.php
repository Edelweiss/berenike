<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;

class BerenikeController extends AbstractController{
  protected $request;
  protected $allParameters = [];
  protected $logger;

  public function __construct(RequestStack $requestStack, LoggerInterface $logger)
  {
      $this->request = $requestStack->getCurrentRequest();
      $this->allParameters = array_merge($this->request->request->all(), $this->request->query->all());
      $this->logger = $logger;
  }

  protected function getParameter($key){
    if(array_key_exists($key, $this->allParameters)){
      return $this->allParameters[$key];
    }
    return null;
  }

}
