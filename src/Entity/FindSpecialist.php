<?php
namespace App\Entity;

use App\Repository\FindSpecialistRepository;
use Doctrine\ORM\Mapping as ORM;

class FindSpecialist {
    private $id;
    private $year;
    private $speciality;
    private $find;
    private $specialist;

    public function __construct() {
    }

    public function setId($id){
        $this->id = $id;
    }
    public function getId() {
        return $this->id;
    }

    public function setYear($year) {
        $this->year = $year;
    }
    public function getYear(){
        return $this->year;
    }

    public function setSpeciality($speciality) {
        $this->speciality = $speciality;
    }
    public function getSpeciality(){
        return $this->speciality;
    }

    public function setFind(\App\Entity\Find $find) {
        $this->find = $find;
    }
    public function getFind(){
        return $this->find;
    }

    public function setSpecialist(\App\Entity\Specialist $specialist) {
        $this->specialist = $specialist;
    }
    public function getSpecialist(){
        return $this->specialist;
    }
}