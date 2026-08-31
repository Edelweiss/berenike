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
            ->add('locusSearch', TextType::class, [
                'mapped' => false,
                'required' => false,
                'label' => 'Locus Search',
                'attr' => [
                    'placeholder' => 'Type: SITE+SEASON-TRENCH/LOCUS (e.g., BE98-127/999)',
                    'class' => 'locus-autocomplete',
                    'autocomplete' => 'off',
                ],
            ])
            ->add('locus', EntityType::class, [
                'class' => Locus::class,
                'choice_label' => function (Locus $locus) {
                    return $locus . '';
                },
                'required' => true,
                'label' => 'Locus',
                'attr' => [
                    'style' => 'display: none;',
                ],
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
