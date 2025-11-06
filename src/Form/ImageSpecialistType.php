<?php

namespace App\Form;

use App\Entity\ImageSpecialist;
use App\Entity\Specialist;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;

class ImageSpecialistType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('specialist', EntityType::class, [
                'class' => Specialist::class,
                'choice_label' => 'name',
                'required' => false,
                'label' => 'Specialist',
                'placeholder' => '-- Select Specialist --',
            ])
            ->add('speciality', ChoiceType::class, [
                'required' => false,
                'label' => 'Speciality',
                'placeholder' => '-- Select Speciality --',
                'choices' => [
                    'Photographer' => 'photographer',
                    'Artist' => 'artist',
                ],
            ])
            ->add('year', ChoiceType::class, [
                'required' => false,
                'label' => 'Year',
                'placeholder' => '-- Select Year --',
                'choices' => array_combine(
                    range(1995, date('Y') + 1),
                    range(1995, date('Y') + 1)
                ),
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => ImageSpecialist::class,
        ]);
    }
}
