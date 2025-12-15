<?php

namespace App\Form;

use App\Entity\Locus;
use App\Entity\Excavation;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;

class LocusType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('excavation', EntityType::class, [
                'class' => Excavation::class,
                'required' => true,
                'label' => 'Trench',
                'choice_label' => function(Excavation $excavation) {
                    return $excavation . '';
                },
                'query_builder' => function(\Doctrine\ORM\EntityRepository $er) {
                    return $er->createQueryBuilder('e')
                        ->orderBy('e.site', 'ASC')
                        ->addOrderBy('LENGTH(e.trench)', 'ASC')
                        ->addOrderBy('e.trench', 'ASC');
                },
            ])
            ->add('number', TextType::class, [
                'required' => true,
                'label' => 'Number',
            ])
            ->add('description', TextareaType::class, [
                'required' => false,
                'label' => 'Description',
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Locus::class,
        ]);
    }
}
