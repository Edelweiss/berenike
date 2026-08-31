<?php
namespace App\Entity;
use App\Repository\SpecialistRepository;
use Doctrine\ORM\Mapping as ORM;

class Specialist {
    private $id;
    private $name;
    private $gnd;
    private $findSpecialists;
    private $imageSpecialists;
    private $excavations;

    public function __construct() {
        $this->findSpecialists = new \Doctrine\Common\Collections\ArrayCollection();
        $this->imageSpecialists = new \Doctrine\Common\Collections\ArrayCollection();
        $this->excavations = new \Doctrine\Common\Collections\ArrayCollection();
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

    public function setGnd($gnd) {
        $this->gnd = $gnd;
    }
    public function getGnd() {
        return $this->gnd;
    }

    public function addFindSpecialist(\App\Entity\FindSpecialist $findSpecialist) {
        $this->findSpecialists[] = $findSpecialist;
    }
    public function getFindSpecialists() {
        return $this->findSpecialists;
    }

    public function addImageSpecialist(\App\Entity\ImageSpecialist $imageSpecialist) {
        $this->imageSpecialists[] = $imageSpecialist;
    }
    public function getImageSpecialists() {
        return $this->imageSpecialists;
    }

    public function setExcavations($excavations) {
        $this->excavations = $excavations;
    }
    public function getExcavations() {
        return $this->excavations;
    }
}
