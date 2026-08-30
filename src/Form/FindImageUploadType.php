<?php

namespace App\Form;

use App\Entity\Specialist;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Validator\Constraints\File;
use Symfony\Component\Validator\Constraints\NotBlank;

/**
 * Form type for uploading new images on the fly when creating/editing a Find
 */
class FindImageUploadType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $currentYear = (int)date('Y');
        $years = range($currentYear + 1, 1995);
        $yearChoices = array_combine($years, $years);
        
        $builder
            ->add('uploadedFile', FileType::class, [
                'required' => true,
                'label' => 'Image File',
                'mapped' => false,
                'constraints' => [
                    new NotBlank([
                        'message' => 'Please select an image file',
                    ]),
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
                        'mimeTypesMessage' => 'Please upload a valid image file (JPEG, PNG, TIFF, or WebP)',
                    ])
                ],
            ])
            ->add('type', ChoiceType::class, [
                'required' => true,
                'label' => 'Image Type',
                'choices' => [
                    'Photo' => 'photo',
                    'Scan' => 'scan',
                    'Drawing' => 'drawing',
                    'Other' => 'other',
                ],
                'data' => 'photo', // Default to photo
            ])
            ->add('specialist', EntityType::class, [
                'class' => Specialist::class,
                'choice_label' => 'name',
                'label' => 'Specialist',
                'required' => false,
                'placeholder' => 'Select a specialist...',
            ])
            ->add('speciality', ChoiceType::class, [
                'label' => 'Speciality',
                'required' => false,
                'placeholder' => 'Select speciality...',
                'choices' => [
                    'Photographer' => 'photographer',
                    'Artist' => 'artist',
                ],
            ])
            ->add('year', ChoiceType::class, [
                'label' => 'Year',
                'required' => false,
                'placeholder' => 'Select year...',
                'choices' => $yearChoices,
            ])
        ;
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => null, // This is a DTO, not mapped to an entity
        ]);
    }
}
