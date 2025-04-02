<?php

namespace App\Controller;
use Symfony\Component\HttpFoundation\Response;

class HomeController extends BerenikeController{
    public function index(): Response {
        return $this->render('home/index.html.twig');
    }
    public function about(): Response {
        return $this->render('home/about.html.twig');
    }
    public function contact(): Response {
        return $this->render('home/contact.html.twig');
    }
    public function help(): Response {
        return $this->render('home/help.html.twig');
    }
}
