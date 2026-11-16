<?php

namespace App\Form;

use App\Entity\Image;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Validator\Constraints\File;

class AssetType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options): void
    {
        $isEdit = $options['is_edit'];

        if (!$isEdit) {
            $builder->add('uploadedFile', FileType::class, [
                'label' => 'Image File',
                'mapped' => false,
                'required' => true,
                'constraints' => [
                    new File([
                        'maxSize' => '50M',
                        'mimeTypes' => [
                            'image/jpeg',
                            'image/jpg',
                            'image/png',
                            'image/tiff',
                            'image/tif',
                            'image/webp',
                        ],
                        'mimeTypesMessage' => 'Please upload a valid image file (JPEG, PNG, TIFF, WebP)',
                    ])
                ],
            ]);
        }

        $builder
            ->add('type', ChoiceType::class, [
                'required' => false,
                'label' => 'Image Type',
                'choices' => [
                    'Photo' => 'photo',
                    'Drawing' => 'drawing',
                ],
                'data' => 'photo',
            ])
            ->add('number', TextType::class, [
                'required' => false,
                'label' => 'Number',
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
        ;
    }

    public function configureOptions(OptionsResolver $resolver): void
    {
        $resolver->setDefaults([
            'data_class' => Image::class,
            'is_edit' => false,
        ]);
    }
}
