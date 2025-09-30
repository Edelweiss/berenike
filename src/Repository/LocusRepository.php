<?php

namespace App\Repository;

use App\Entity\Locus;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Locus>
 *
 * @method Locus|null find($id, $lockMode = null, $lockVersion = null)
 * @method Locus|null findOneBy(array $criteria, array $orderBy = null)
 * @method Locus[]    findAll()
 * @method Locus[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class LocusRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Locus::class);
    }

    public function save(Locus $entity, bool $flush = false): void
    {
        $this->getEntityManager()->persist($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Locus $entity, bool $flush = false): void
    {
        $this->getEntityManager()->remove($entity);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }
}
