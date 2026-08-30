<?php

namespace App\Form;

use App\Entity\Image;
use App\Entity\Find;
use App\Entity\Specialist;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\FileType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\CollectionType;
use Symfony\Bridge\Doctrine\Form\Type\EntityType;
use Symfony\Component\Validator\Constraints\File;

class AssetType extends AbstractType
{
    public function buildForm(FormBuilderInterface $builder, array $options)
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
                'required' => true,
                'label' => 'Type',
                'choices' => [
                    'Photo' => 'photo',
                    'Scan' => 'scan',
                    'Drawing' => 'drawing',
                    'Other' => 'other',
                ],
                'placeholder' => 'Select type',
            ])
            ->add('number', TextType::class, [
                'required' => false,
                'label' => 'Number',
            ])
            ->add('heidiconId', IntegerType::class, [
                'required' => false,
                'label' => 'HeidICON ID',
            ])
            ->add('heidiconUuid', TextType::class, [
                'required' => false,
                'label' => 'HeidICON UUID',
            ])
            ->add('heidiconSystemObjectId', IntegerType::class, [
                'required' => false,
                'label' => 'HeidICON System Object ID',
            ])
            ->add('finds', EntityType::class, [
                'class' => Find::class,
                'choice_label' => function(Find $find) {
                    return sprintf(
                        '#%d - %s %s',
                        $find->getId(),
                        $find->getInventoryNumber() ?: 'N/A',
                        $find->getObject() ?: ''
                    );
                },
                'multiple' => true,
                'expanded' => false,
                'required' => false,
                'label' => 'Linked Finds',
                'attr' => ['size' => 5],
            ])
            ->add('imageSpecialists', CollectionType::class, [
                'entry_type' => ImageSpecialistType::class,
                'allow_add' => true,
                'allow_delete' => true,
                'by_reference' => false,
                'label' => 'Specialists',
                'required' => false,
            ]);
    }

    public function configureOptions(OptionsResolver $resolver)
    {
        $resolver->setDefaults([
            'data_class' => Image::class,
            'is_edit' => false,
        ]);
    }
}
