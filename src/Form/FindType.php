<?php

namespace App\Form;

use App\Entity\Find;
use App\Entity\Bucket;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\DateType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;

class FindType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('inventoryNumber', TextType::class, [
                'required' => false,
                'label' => 'Inventory Number',
            ])
            ->add('tm', IntegerType::class, [
                'required' => false,
                'label' => 'TM',
            ])
            ->add('trench', TextType::class, [
                'required' => false,
                'label' => 'Trench',
            ])
            ->add('date', DateType::class, [
                'required' => false,
                'widget' => 'single_text',
                'label' => 'Date',
            ])
            ->add('year', IntegerType::class, [
                'required' => true,
                'label' => 'Year',
            ])
            ->add('month', IntegerType::class, [
                'required' => true,
                'label' => 'Month',
            ])
            ->add('dateRemarks', TextType::class, [
                'required' => false,
                'label' => 'Date Remarks',
            ])
            ->add('scaRegister', TextType::class, [
                'required' => false,
                'label' => 'SCA Register',
            ])
            ->add('object', TextareaType::class, [
                'required' => false,
                'label' => 'Object',
            ])
            ->add('objectNo', TextType::class, [
                'required' => false,
                'label' => 'Object No',
            ])
            ->add('category', TextType::class, [
                'required' => false,
                'label' => 'Category',
            ])
            ->add('categoryNo', TextType::class, [
                'required' => false,
                'label' => 'Category No',
            ])
            ->add('weight', TextType::class, [
                'required' => false,
                'label' => 'Weight',
            ])
            ->add('quantity', TextType::class, [
                'required' => false,
                'label' => 'Quantity',
            ])
            ->add('dimensions', TextareaType::class, [
                'required' => false,
                'label' => 'Dimensions',
            ])
            ->add('preservation', TextareaType::class, [
                'required' => false,
                'label' => 'Preservation',
            ])
            ->add('description', TextareaType::class, [
                'required' => false,
                'label' => 'Description',
            ])
            ->add('material', TextType::class, [
                'required' => false,
                'label' => 'Material',
            ])
            ->add('materialRemarks', TextareaType::class, [
                'required' => false,
                'label' => 'Material Remarks',
            ])
            ->add('datingAbsolute', TextareaType::class, [
                'required' => false,
                'label' => 'Dating Absolute',
            ])
            ->add('typologyReference', TextareaType::class, [
                'required' => false,
                'label' => 'Typology Reference',
            ])
            ->add('publications', TextareaType::class, [
                'required' => false,
                'label' => 'Publications',
            ])
            ->add('remarks', TextareaType::class, [
                'required' => false,
                'label' => 'Remarks',
            ])
            ->add('bucket', EntityType::class, [
                'class' => Bucket::class,
                'choice_label' => 'id',
                'required' => true,
                'label' => 'Bucket',
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Find::class,
        ]);
    }
}