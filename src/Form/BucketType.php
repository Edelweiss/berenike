<?php

namespace App\Form;

use App\Entity\Bucket;
use App\Entity\Locus;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;

class BucketType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('number', TextType::class, [
                'required' => true,
                'label' => 'Number'
            ])
            ->add('dating', TextType::class, [
                'required' => false,
                'label' => 'Dating'
            ])
            ->add('remarks', TextareaType::class, [
                'required' => false,
                'label' => 'Remarks'
            ])
            ->add('locus', EntityType::class, [
                'class' => Locus::class,
                'choice_label' => function (Locus $locus) {
                    return $locus . '';
                },
                'query_builder' => function ($repository) {
                    return $repository->createQueryBuilder('l')
                        ->leftJoin('l.excavation', 'e')
                        ->orderBy('e.site', 'ASC')
                        ->addOrderBy('SUBSTRING(e.season, LENGTH(e.season) - 3, 4)', 'DESC')
                        ->addOrderBy('e.trench + 0', 'ASC')
                        ->addOrderBy('l.number + 0', 'ASC');
                },
                'required' => true,
                'label' => 'Locus'
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Bucket::class,
        ]);
    }
}
