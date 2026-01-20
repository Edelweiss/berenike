/**
 * Image Collection Manager
 * Handles dynamic image and specialist form management
 */
(function($) {
    'use strict';

    function initImageCollectionManager() {
        var $imagesContainer = $('#images-collection');
        var imageIndex = $imagesContainer.find('.image-item').length;

        // Add new image
        $('#add-image').on('click', function(e) {
            e.preventDefault();
            
            // Get the image prototype and replace __name__ with the current index
            var imagePrototype = $imagesContainer.data('prototype');
            var newImageForm = imagePrototype.replace(/__name__/g, imageIndex);
            
            // Append the new image form
            var $newImageItem = $(newImageForm);
            $imagesContainer.append($newImageItem);
            
            // Now add one specialist to this new image
            addSpecialistToImage($newImageItem, imageIndex);
            
            imageIndex++;
        });

        // Remove image
        $imagesContainer.on('click', '.remove-image', function(e) {
            e.preventDefault();
            $(this).closest('.image-item').remove();
        });

        // Initialize existing images - add specialists functionality
        $('.image-item').each(function() {
            var $imageItem = $(this);
            // Extract the image index from existing field names
            var imageIdx = extractImageIndex($imageItem);
            setupSpecialistButtons($imageItem, imageIdx);
        });

        function extractImageIndex($imageItem) {
            var nameAttr = $imageItem.find('[name*="[images]"]').first().attr('name');
            if (nameAttr) {
                var match = nameAttr.match(/\[images\]\[(\d+)\]/);
                return match ? parseInt(match[1]) : 0;
            }
            return 0;
        }

        function setupSpecialistButtons($imageItem, imageIdx) {
            var $specialistsContainer = $imageItem.find('.specialists-collection');
            
            // Add specialist button click handler
            $imageItem.find('.add-specialist').off('click').on('click', function(e) {
                e.preventDefault();
                addSpecialistToImage($imageItem, imageIdx);
            });
        }

        function addSpecialistToImage($imageItem, imageIdx) {
            var $specialistsContainer = $imageItem.find('.image-specialists-collection');
            var specialistIndex = $specialistsContainer.find('.specialist-item').length;
            
            // Get the specialist prototype HTML from the template
            var specialistPrototypeHtml = $('#specialist-prototype-template').html();
            
            // Replace the placeholder with actual indices
            // First replace the image index placeholder
            var specialistHtml = specialistPrototypeHtml.replace(/IMAGEINDEX/g, imageIdx);
            // Then replace the specialist index placeholder
            specialistHtml = specialistHtml.replace(/SPECIALISTINDEX/g, specialistIndex);
            
            $specialistsContainer.append(specialistHtml);
        }
    }

    // Initialize when document is ready
    $(document).ready(function() {
        if ($('#images-collection').length > 0) {
            initImageCollectionManager();
        }
    });

})(jQuery);
