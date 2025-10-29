<?php

namespace App\Form;

use App\Entity\Excavation;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Validator\Constraints as Assert;

class ExcavationType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $currentYear = (int)date('Y');
        
        $builder
            ->add('site', ChoiceType::class, [
                'required' => true,
                'label' => 'Site',
                'choices' => [
                    'AG' => 'AG',
                    'BA' => 'BA',
                    'BE' => 'BE',
                    'KM' => 'KM',
                    'NU' => 'NU',
                    'SH' => 'SH',
                    'SK' => 'SK',
                    'UA' => 'UA',
                    'WA' => 'WA',
                    'WK' => 'WK',
                ],
            ])
            ->add('season', TextType::class, [
                'required' => false,
                'label' => 'Season',
                'constraints' => [
                    new Assert\Regex([
                        'pattern' => '/^\d{4}(\/\d{4})*$/',
                        'message' => 'Season must be in format YYYY or YYYY/YYYY/...',
                    ]),
                ],
            ])
            ->add('trench', TextType::class, [
                'required' => true,
                'label' => 'Trench',
            ])
            ->add('year', ChoiceType::class, [
                'required' => false,
                'label' => 'Year',
                'placeholder' => '-- none --',
                'choices' => array_combine(
                    range(1995, $currentYear + 1),
                    range(1995, $currentYear + 1)
                ),
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
