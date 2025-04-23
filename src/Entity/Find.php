<?php
namespace App\Entity;
use App\Repository\FindRepository;
use Doctrine\ORM\Mapping as ORM;
use DateTime;
use Exception;

class Find {
    private $id;
    private $trench;
    private $date;
    private $year;
    private $month;
    private $dateRemarks;
    private $scaRegister;
    private $object;
    private $objectNo;
    private $category;
    private $categoryNo;
    private $weight;
    private $quantity;
    private $dimensions;
    private $preservation;
    private $description;
    private $material;
    private $materialRemarks;
    private $datingAbsolute;
    private $typologyReference;
    private $publications;
    private $remarks;
    private $rebuildChanges;
    private $created;
    private $modified;
    private $bucket;
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

    public function setTrench($trench) {
        $this->trench = $trench;
    }
    public function getTrench() {
        return $this->trench;
    }

    public function setDate($date) {
        $this->date = $date;
    }
    public function getDate() {
        return $this->date;
    }

    public function setYear($year) {
        $this->year = $year;
    }
    public function getYear() {
        return $this->year;
    }

    public function setMonth($month) {
        $this->month = $month;
    }
    public function getMonth() {
        return $this->month;
    }

    public function setDateRemarks($dateRemarks) {
        $this->dateRemarks = $dateRemarks;
    }
    public function getDateRemarks() {
        return $this->dateRemarks;
    }

    public function setScaRegister($scaRegister) {
        $this->scaRegister = $scaRegister;
    }
    public function getScaRegister() {
        return $this->scaRegister;
    }

    public function setObject($object) {
        $this->object = $object;
    }
    public function getObject() {
        return $this->object;
    }

    public function setObjectNo($objectNo) {
        $this->objectNo = $objectNo;
    }
    public function getObjectNo() {
        return $this->objectNo;
    }

    public function setCategory($category) {
        $this->category = $category;
    }
    public function getCategory() {
        return $this->category;
    }

    public function setCategoryNo($categoryNo) {
        $this->categoryNo = $categoryNo;
    }
    public function getCategoryNo() {
        return $this->categoryNo;
    }

    public function setWeight($weight) {
        $this->weight = $weight;
    }
    public function getWeight() {
        return $this->weight;
    }

    public function setQuantity($quantity) {
        $this->quantity = $quantity;
    }
    public function getQuantity() {
        return $this->quantity;
    }

    public function setDimensions($dimensions) {
        $this->dimensions = $dimensions;
    }
    public function getDimensions() {
        return $this->dimensions;
    }

    public function setPreservation($preservation) {
        $this->preservation = $preservation;
    }
    public function getPreservation() {
        return $this->preservation;
    }

    public function setDescription($description) {
        $this->description = $description;
    }
    public function getDescription() {
        return $this->description;
    }

    public function setMaterial($material) {
        $this->material = $material;
    }
    public function getMaterial() {
        return $this->material;
    }

    public function setMaterialRemarks($materialRemarks) {
        $this->materialRemarks = $materialRemarks;
    }
    public function getMaterialRemarks() {
        return $this->materialRemarks;
    }

    public function setDatingAbsolute($datingAbsolute) {
        $this->datingAbsolute = $datingAbsolute;
    }
    public function getDatingAbsolute() {
        return $this->datingAbsolute;
    }

    public function setTypologyReference($typologyReference) {
        $this->typologyReference = $typologyReference;
    }
    public function getTypologyReference() {
        return $this->typologyReference;
    }

    public function setPublications($publications) {
        $this->publications = $publications;
    }
    public function getPublications() {
        return $this->publications;
    }

    public function setRemarks($remarks) {
        $this->remarks = $remarks;
    }
    public function getRemarks() {
        return $this->remarks;
    }

    public function setRebuildChanges($rebuildChanges) {
        $this->rebuildChanges = $rebuildChanges;
    }
    public function getRebuildChanges() {
        return $this->rebuildChanges;
    }

    public function setCreated($created) {
        $this->created = $created;
    }
    public function getCreated() {
        return $this->created;
    }

    public function setModified($modified) {
        $this->modified = $modified;
    }
    public function getModified() {
        return $this->modified;
    }

    public function setBucket(\App\Entity\Bucket $bucket){
        $this->bucket = bucket;
    }
    public function getBucket(){
        return $this->bucket;
    }

    public function addFindSpecialist(\App\Entity\addFindSpecialist $findSpecialist) {
        $this->findSpecialists[] = $findSpecialist;
    }
    public function getFindSpecialists() {
        return $this->findSpecialists;
    }
}
