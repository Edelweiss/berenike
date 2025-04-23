<?php
namespace App\Entity;

use App\Repository\BucketRepository;
use Doctrine\ORM\Mapping as ORM;

class Bucket {
    private $id;
    private $number;
    private $dating;
    private $remarks;
    private $created;
    private $modified;
    private $finds;
    private $locus;

    public function __construct()
    {
        $this->finds = new \Doctrine\Common\Collections\ArrayCollection();
    }

    public function setId($id)
    {
        $this->id = $id;
    }
    public function getId()
    {
        return $this->id;
    }

    public function setNumber($number)
    {
        $this->number = $number;
    }
    public function getNumber()
    {
        return $this->number;
    }

    public function setDating($dating)
    {
        $this->dating = $dating;
    }
    public function getDating()
    {
        return $this->dating;
    }

    public function setRemarks($remarks)
    {
        $this->remarks = $remarks;
    }
    public function getRemarks()
    {
        return $this->remarks;
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

    public function setLocus(\App\Entity\Locus $locus)
    {
        $this->locus = $locus;
    }
    public function getLocus()
    {
        return $this->locus;
    }

    public function addFind(\App\Entity\Find $find)
    {
        $this->finds[] = $find;
    }
    public function getFinds()
    {
        return $this->finds;
    }
}