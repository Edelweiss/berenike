<?php

namespace App\Repository;

use App\Entity\Find;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Find>
 *
 * @method Find|null find($id, $lockMode = null, $lockVersion = null)
 * @method Find|null findOneBy(array $criteria, array $orderBy = null)
 * @method Find[]    findAll()
 * @method Find[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class FindRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Find::class);
    }

    public function save(Find $find, bool $flush = false): void
    {
        $this->getEntityManager()->persist($find);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }

    public function remove(Find $find, bool $flush = false): void
    {
        $this->getEntityManager()->remove($find);

        if ($flush) {
            $this->getEntityManager()->flush();
        }
    }
}
