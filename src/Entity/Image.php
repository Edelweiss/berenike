<?php
namespace App\Entity;
use App\Repository\ImageRepository;
use Doctrine\ORM\Mapping as ORM;

class Image {
    private $id;
    private $type;
    private $number;
    private $size;
    private $file;
    private $path;
    private $heidiconId;
    private $heidiconUuid;
    private $heidiconSystemObjectId;
    private $find;
    private $imageSpecialists;
    
    public function __construct() {
        $this->imageSpecialists = new \Doctrine\Common\Collections\ArrayCollection();
    }

    public function setId($id) {
        $this->id = $id;
    }
    public function getId() {
        return $this->id;
    }

    public function setType($type) {
        $this->type = $type;
    }
    public function getType() {
        return $this->type;
    }

    public function setNumber($number) {
        $this->number = $number;
    }
    public function getNumber() {
        return $this->number;
    }

    public function setSize($size) {
        $this->size = $size;
    }
    public function getSize() {
        return $this->size;
    }

    public function setFile($file) {
        $this->file = $file;
    }
    public function getFile() {
        return $this->file;
    }

    public function setPath($path) {
        $this->path = $path;
    }
    public function getPath() {
        return $this->path;
    }

    public function setHeidiconId(?int $heidiconId): self {
        $this->heidiconId = $heidiconId;
        return $this;
    }
    public function getHeidiconId(): ?int {
        return $this->heidiconId;
    }

    public function setHeidiconUuid(?string $heidiconUuid): self {
        $this->heidiconUuid = $heidiconUuid;
        return $this;
    }
    public function getHeidiconUuid(): ?string {
        return $this->heidiconUuid;
    }

    public function setHeidiconSystemObjectId(?int $heidiconSystemObjectId): self {
        $this->heidiconSystemObjectId = $heidiconSystemObjectId;
        return $this;
    }
    public function getHeidiconSystemObjectId(): ?int {
        return $this->heidiconSystemObjectId;
    }

    public function setFind(\App\Entity\Find $find){
        $this->find = $find;
    }
    public function getFind(){
        return $this->find;
    }

    public function addImageSpecialist(?\App\Entity\ImageSpecialist $imageSpecialist) {
        if ($imageSpecialist === null) {
            return;
        }
        if (!$this->imageSpecialists->contains($imageSpecialist)) {
            $this->imageSpecialists[] = $imageSpecialist;
            $imageSpecialist->setImage($this);
        }
    }
    
    public function removeImageSpecialist(\App\Entity\ImageSpecialist $imageSpecialist) {
        $this->imageSpecialists->removeElement($imageSpecialist);
    }
    
    public function setImageSpecialists($imageSpecialists) {
        // Convert to array if it's a collection for easier comparison
        $newSpecialists = is_array($imageSpecialists) ? $imageSpecialists : $imageSpecialists->toArray();
        $existingSpecialists = $this->imageSpecialists->toArray();

        // Remove specialists that are no longer in the new collection
        foreach ($this->imageSpecialists->toArray() as $existingSpecialist) {
            if (!in_array($existingSpecialist, $newSpecialists, true)) {
                $this->removeImageSpecialist($existingSpecialist);
            }
        }

        // Add new specialists if they are not already present
        foreach ($newSpecialists as $specialist) {
            if (!in_array($specialist, $existingSpecialists, true)) {
                $this->addImageSpecialist($specialist);
            }
        }
    }
    
    public function getImageSpecialists() {
        return $this->imageSpecialists;
    }
}
