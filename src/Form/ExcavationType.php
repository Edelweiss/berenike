<?php

namespace App\Form;

use App\Entity\Excavation;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;

class ExcavationType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('site', TextType::class, [
                'required' => true,
                'label' => 'Site',
            ])
            ->add('season', TextType::class, [
                'required' => true,
                'label' => 'Season',
            ])
            ->add('trench', TextType::class, [
                'required' => true,
                'label' => 'Trench',
            ])
            ->add('year', IntegerType::class, [
                'required' => false,
                'label' => 'Year',
            ])
            ->add('context', TextareaType::class, [
                'required' => false,
                'label' => 'Context',
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Excavation::class,
        ]);
    }
}
