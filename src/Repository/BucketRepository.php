<?php

namespace App\Repository;

use App\Entity\Bucket;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Bucket>
 *
 * @method Bucket|null find($id, $lockMode = null, $lockVersion = null)
 * @method Bucket|null findOneBy(array $criteria, array $orderBy = null)
 * @method Bucket[]    findAll()
 * @method Bucket[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class BucketRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Bucket::class);
    }

    public function save(Bucket $bucket, bool $flush = false): void
    {
        $this->getEntityManager()->persist($bucket);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Bucket $bucket, bool $flush = false): void
    {
        $this->getEntityManager()->remove($bucket);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }
}
