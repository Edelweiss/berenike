<?php

namespace App\Entity;

use App\Repository\ExcavationRepository;
use Doctrine\ORM\Mapping as ORM;

class Excavation {
    private $id;
    private $site;
    private $season;
    private $trench;
    private $context;
    private $year;
    private $loci;

    public function __construct() {
        $this->loci = new \Doctrine\Common\Collections\ArrayCollection();
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

    public function setContext($context) {
        $this->context = $context;
    }
    public function getContext() {
        return $this->context;
    }

    public function setYear($year) {
        $this->year = $year;
    }
    public function getYear() {
        return $this->year;
    }

    public function setLoci($loci) {
        $this->loci = $loci;
    }
    public function getLoci() {
        return $this->loci;
    }
    public function addLocus(\App\Entity\Locus $locus) {
        $this->loci[] = locus;
    }

    public function setExcavation(\App\Entity\Excavation $excavation) {
        $this->excavation = $excavation;
    }
    public function getExcavation() {
        return $this->excavation;
    }
}