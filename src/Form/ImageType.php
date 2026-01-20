<?php

namespace App\Form;

use App\Entity\Image;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\CollectionType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;

class ImageType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('type', ChoiceType::class, [
                'required' => true,
                'label' => 'Image Type',
                'choices' => [
                    'Photo' => 'photo',
                    'Drawing' => 'drawing',
                ],
            ])
            ->add('number', TextType::class, [
                'required' => false,
                'label' => 'Number',
            ])
            ->add('size', TextareaType::class, [
                'required' => true,
                'label' => 'Size',
                'attr' => ['rows' => 2],
            ])
            ->add('file', TextType::class, [
                'required' => true,
                'label' => 'File',
            ])
            ->add('path', TextType::class, [
                'required' => true,
                'label' => 'Path',
            ])
            ->add('heidiconId', TextType::class, [
                'required' => false,
                'label' => 'HeidICON ID',
                'attr' => [
                    'placeholder' => 'Enter a positive number or leave empty',
                    'pattern' => '[1-9][0-9]*',
                    'title' => 'Must be a positive integer (greater than 0)'
                ]
            ])
            ->add('heidiconUuid', TextType::class, [
                'required' => false,
                'label' => 'HeidICON UUID',
                'attr' => [
                    'placeholder' => 'e.g., b17bf1dd-a7e7-42c2-b441-8f57cbd9e20e',
                    'pattern' => '[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
                    'title' => 'Format: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
                ]
            ])
            ->add('heidiconSystemObjectId', TextType::class, [
                'required' => false,
                'label' => 'HeidICON System Object ID',
                'attr' => [
                    'placeholder' => 'Enter a positive number or leave empty',
                    'pattern' => '[1-9][0-9]*',
                    'title' => 'Must be a positive integer (greater than 0)'
                ]
            ])
            ->add('imageSpecialists', CollectionType::class, [
                'entry_type' => ImageSpecialistType::class,
                'entry_options' => ['label' => false],
                'allow_add' => true,
                'allow_delete' => true,
                'by_reference' => false,
                'label' => 'Image Specialists',
                'attr' => ['class' => 'image-specialists-collection'],
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Image::class,
        ]);
    }
}
