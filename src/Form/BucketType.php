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
                'choice_label' => 'number',
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
