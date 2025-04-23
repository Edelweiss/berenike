<?php

namespace App\Entity;

use App\Repository\LocusRepository;
use Doctrine\ORM\Mapping as ORM;

class Locus {
    private $id;
    private $site;
    private $season;
    private $trench;
    private $number;
    private $description;
    private $created;
    private $modified;
    private $buckets;
    private $excavation;

    public function __construct() {
        $this->buckets = new \Doctrine\Common\Collections\ArrayCollection();
    }

    public function setId($id) {
        $this->id = $id;
    }
    public function getId() {
        return $this->id;
    }

    public function setSite($site) {
        $this->site = $site;
    }
    public function getSite() {
        return $this->site;
    }

    public function setSeason($season) {
        $this->season = $season;
    }
    public function getSeason() {
        return $this->season;
    }

    public function setTrench($trench) {
        $this->trench = $trench;
    }
    public function getTrench() {
        return $this->trench;
    }

    public function setNumber($number) {
        $this->number = $number;
    }
    public function getNumber() {
        return $this->number;
    }

    public function setDescription($description) {
        $this->description = $description;
    }
    public function getDescription() {
        return $this->description;
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

    public function setBuckets($buckets) {
        $this->buckets = $buckets;
    }
    public function getBuckets() {
        return $this->buckets;
    }
    public function addBucket(\App\Entity\Bucket $bucket) {
        $this->buckets[] = bucket;
    }
    public function getBucket() {
        return $this->buckets;
    }

    public function setExcavation(\App\Entity\Excavation $excavation) {
        $this->excavation = $excavation;
    }
    public function getExcavation() {
        return $this->excavation;
    }
}