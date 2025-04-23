<?php

namespace App\Entity;

use App\Repository\LocusRepository;
use Doctrine\ORM\Mapping as ORM;

class Locus {
    private $id;
    private $siteId;
    private $seasonId;
    private $trenchId;
    private $number;
    private $description;
    private $created;
    private $modified;
    private $buckets;

    public function setId($id)
    {
        $this->id = $id;
    }
    public function getId()
    {
        return $this->id;
    }

    public function setSiteId($siteId)
    {
        $this->siteId = $siteId;
    }
    public function getSiteId()
    {
        return $this->siteId;
    }

    public function setSeasonId($seasonId)
    {
        $this->seasonId = $seasonId;
    }
    public function getSeasonId()
    {
        return $this->seasonId;
    }
    public function getSeasonYear()
    {
        return $this->seasonId + 2000;
    }

    public function setTrenchId($trenchId)
    {
        $this->trenchId = $trenchId;
    }
    public function getTrenchId()
    {
        return $this->trenchId;
    }

    public function setNumber($number)
    {
        $this->number = $number;
    }
    public function getNumber()
    {
        return $this->number;
    }

    public function setDescription($description)
    {
        $this->description = $description;
    }
    public function getDescription()
    {
        return $this->description;
    }

    public function setCreated($created)
    {
        $this->created = $created;
    }
    public function getCreated()
    {
        return $this->created;
    }

    public function setModified($modified)
    {
        $this->modified = $modified;
    }
    public function getModified()
    {
        return $this->modified;
    }

    public function setBuckets($buckets)
    {
        $this->buckets = $buckets;
    }
    public function getBuckets()
    {
        return $this->buckets;
    }

    public function __construct()
    {
        $this->buckets = new \Doctrine\Common\Collections\ArrayCollection();
    }

    public function addBucket(\App\Entity\Bucket $bucket)
    {
        $this->buckets[] = bucket;
    }
    public function getBucket()
    {
        return $this->buckets;
    }
}