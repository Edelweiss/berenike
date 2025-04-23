<?php
namespace App\Entity;
use App\Repository\SpecialistRepository;
use Doctrine\ORM\Mapping as ORM;

class Specialist {
    private $id;
    private $name;
    private $findSpecialists;

    public function __construct() {
        $this->findSpecialists = new \Doctrine\Common\Collections\ArrayCollection();
    }

    public function setId($id) {
        $this->id = $id;
    }
    public function getId() {
        return $this->id;
    }

    public function setName($name) {
        $this->name = $name;
    }
    public function getName() {
        return $this->name;
    }

    public function addFindSpecialist(\App\Entity\FindSpecialist $findSpecialist) {
        $this->findSpecialists[] = $findSpecialist;
    }
    public function getFindSpecialists() {
        return $this->findSpecialists;
    }
}