<?php

namespace App\Entity;

use App\Repository\ExcavationRepository;
use Doctrine\ORM\Mapping as ORM;

/**
 * @ORM\Entity(repositoryClass=ExcavationRepository::class)
 */
class Excavation {
    private $id;
    private $site;
    private $season;
    private $trench;
    private $context;
    private $year;
    private $specialist;
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

    public function setSpecialist($specialist) {
        $this->specialist = $specialist;
    }
    public function getSpecialist() {
        return $this->specialist;
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

    public function __toString() {
        $formattedSeason = $this->formatSeason($this->season);
        return $this->site . $formattedSeason . '-' . $this->trench;
    }

    private function formatSeason($season) {
        if (empty($season)) {
            return '';
        }

        // Extract all 4-digit years from the season string
        preg_match_all('/\d{4}/', $season, $matches);
        $years = $matches[0];

        if (empty($years)) {
            return $season; // Return as-is if no years found
        }

        if (count($years) === 1) {
            // Single year: "2025" -> "25"
            return substr($years[0], -2);
        } elseif (count($years) === 2) {
            // Two years: "2023/2024" -> "23/24"
            return substr($years[0], -2) . '/' . substr($years[1], -2);
        } else {
            // More than two years: "2012/2013/2014" -> "12/…/14"
            return substr($years[0], -2) . '/…/' . substr($years[count($years) - 1], -2);
        }
    }
}