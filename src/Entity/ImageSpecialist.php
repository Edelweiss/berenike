<?php
namespace App\Entity;

class ImageSpecialist {
    private $id;
    private $year;
    private $speciality;
    private $image;
    private $specialist;

    public function setId($id) {
        $this->id = $id;
    }
    public function getId() {
        return $this->id;
    }

    public function setYear($year) {
        $this->year = $year;
    }
    public function getYear() {
        return $this->year;
    }

    public function setSpeciality($speciality) {
        $this->speciality = $speciality;
    }
    public function getSpeciality() {
        return $this->speciality;
    }

    public function setImage(\App\Entity\Image $image){
        $this->image = $image;
    }
    public function getImage(){
        return $this->image;
    }

    public function setSpecialist(\App\Entity\Specialist $specialist){
        $this->specialist = $specialist;
    }
    public function getSpecialist(){
        return $this->specialist;
    }
}
