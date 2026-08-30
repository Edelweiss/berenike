<?php

namespace App\Repository;

use App\Entity\Image;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Image>
 *
 * @method Image|null find($id, $lockMode = null, $lockVersion = null)
 * @method Image|null findOneBy(array $criteria, array $orderBy = null)
 * @method Image[]    findAll()
 * @method Image[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class ImageRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Image::class);
    }

    public function save(Image $image, bool $flush = false): void
    {
        $this->getEntityManager()->persist($image);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Image $image, bool $flush = false): void
    {
        $this->getEntityManager()->remove($image);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    /**
     * Find all images with asset_key (asset-managed images)
     * 
     * @return Image[]
     */
    public function findAllWithAssets(): array
    {
        return $this->createQueryBuilder('i')
            ->where('i.assetKey IS NOT NULL')
            ->andWhere('i.assetShard IS NOT NULL')
            ->orderBy('i.id', 'DESC')
            ->getQuery()
            ->getResult();
    }

    /**
     * Find images by asset key
     * 
     * @param string $assetKey
     * @return Image|null
     */
    public function findByAssetKey(string $assetKey): ?Image
    {
        return $this->createQueryBuilder('i')
            ->where('i.assetKey = :assetKey')
            ->setParameter('assetKey', $assetKey)
            ->getQuery()
            ->getOneOrNullResult();
    }

    /**
     * Count all images with assets
     * 
     * @return int
     */
    public function countAssetsImages(): int
    {
        return (int) $this->createQueryBuilder('i')
            ->select('COUNT(i.id)')
            ->where('i.assetKey IS NOT NULL')
            ->andWhere('i.assetShard IS NOT NULL')
            ->getQuery()
            ->getSingleScalarResult();
    }
}
