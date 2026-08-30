<?php

namespace App\Form;

use App\Entity\Find;
use App\Entity\Bucket;
use App\Entity\Image;
use Symfony\Component\Form\AbstractType;
use Symfony\Component\Form\FormBuilderInterface;
use Symfony\Component\OptionsResolver\OptionsResolver;
use Symfony\Component\Form\Extension\Core\Type\DateType;
use Symfony\Component\Form\Extension\Core\Type\TextType;
use Symfony\Component\Form\Extension\Core\Type\IntegerType;
use Symfony\Component\Form\Extension\Core\Type\TextareaType;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\Extension\Core\Type\CollectionType;
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
                'attr' => [
                    'min' => 1,
                    'placeholder' => 'Enter a positive number or leave empty',
                    'oninvalid' => 'this.setCustomValidity("TM must be a positive number")',
                    'oninput' => 'setCustomValidity("")'
                ]
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
            ->add('trench', TextType::class, [
                'required' => false,
                'label' => 'Trench',
            ])
            ->add('date', DateType::class, [
                'required' => false,
                'widget' => 'single_text',
                'label' => 'Date',
            ])
            ->add('year', ChoiceType::class, [
                'required' => true,
                'label' => 'Year',
                'choices' => array_combine(
                    range(1995, date('Y')),
                    range(1995, date('Y'))
                ),
            ])
            ->add('month', ChoiceType::class, [
                'required' => false,
                'label' => '',
                'placeholder' => '-- none --',
                'choices' => array_combine(
                    range(1, 12),
                    range(1, 12)
                ),
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
            ->add('literature', TextareaType::class, [
                'required' => false,
                'label' => 'Literature',
            ])
            ->add('remarks', TextareaType::class, [
                'required' => false,
                'label' => 'Remarks',
            ])
            ->add('bucket', EntityType::class, [
                'class' => Bucket::class,
                'choice_label' => function (Bucket $bucket) {
                    return $bucket . '';
                },
                'query_builder' => function ($repository) {
                    return $repository->createQueryBuilder('b')
                        ->leftJoin('b.locus', 'l')
                        ->leftJoin('l.excavation', 'e')
                        ->orderBy('e.site', 'ASC')
                        ->addOrderBy('SUBSTRING(e.season, LENGTH(e.season) - 3, 4)', 'DESC')
                        ->addOrderBy('e.trench + 0', 'ASC')
                        ->addOrderBy('l.number + 0', 'ASC')
                        ->addOrderBy('b.number', 'ASC');
                },
                'required' => true,
                'label' => 'Bucket',
            ])
            ->add('images', EntityType::class, [
                'class' => Image::class,
                'choice_label' => function (Image $image) {
                    if ($image->getAssetKey()) {
                        return sprintf('Asset #%d (%s)', $image->getId(), $image->getFile() ?: $image->getAssetKey());
                    }
                    return sprintf('Image #%d (Legacy)', $image->getId());
                },
                'query_builder' => function ($repository) {
                    return $repository->createQueryBuilder('i')
                        ->where('i.assetKey IS NOT NULL')
                        ->orderBy('i.id', 'DESC');
                },
                'multiple' => true,
                'required' => false,
                'label' => 'Link Existing Assets',
                'by_reference' => false,
                'attr' => [
                    'size' => 10,
                ],
            ])
            ->add('newImageUploads', CollectionType::class, [
                'entry_type' => FindImageUploadType::class,
                'allow_add' => true,
                'allow_delete' => true,
                'by_reference' => false,
                'label' => 'Upload New Images',
                'required' => false,
                'mapped' => false, // Not directly mapped to entity, handled in controller
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