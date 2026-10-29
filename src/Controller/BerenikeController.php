<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\RequestStack;
use Psr\Log\LoggerInterface;

class BerenikeController extends AbstractController{
  protected $request;
  protected $allParameters = [];
  protected $logger;

  public function __construct(RequestStack $requestStack, LoggerInterface $logger)
  {
      $this->request = $requestStack->getCurrentRequest();
      if ($this->request) {
          $this->allParameters = array_merge($this->request->request->all(), $this->request->query->all());
      }
      $this->logger = $logger;
  }

  protected function getParameter(string $name): \UnitEnum|array|string|int|float|bool|null{
    if(array_key_exists($name, $this->allParameters)){
      return $this->allParameters[$name];
    }
    return null;
  }

}
