<?php

namespace App\Entity;

use App\Repository\LocusRepository;
use Doctrine\ORM\Mapping as ORM;
use Symfony\Bridge\Doctrine\Validator\Constraints\UniqueEntity;

/**
 * @ORM\Entity(repositoryClass=LocusRepository::class)
 * @UniqueEntity(
 *     fields={"excavation", "number", "addendum"},
 *     message="This combination of excavation, number and addendum already exists."
 * )
 */
class Locus {
    private $id;
    private $number;
    private $addendum;
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

    public function setNumber($number) {
        $this->number = $number;
    }
    public function getNumber() {
        return $this->number;
    }

    public function setAddendum($addendum) {
        $this->addendum = $addendum;
    }
    public function getAddendum() {
        return $this->addendum;
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

    public function setExcavation(\App\Entity\Excavation $excavation) {
        $this->excavation = $excavation;
    }
    public function getExcavation() {
        return $this->excavation;
    }

    public function __toString() {
        return $this->excavation . '/' . $this->number;
    }
}