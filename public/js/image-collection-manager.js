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
            
            // Find the specialists collection div and add the "Add Specialist" button if it's not present
            var $specialistsContainer = $newImageItem.find('.image-specialists-collection');
            if ($specialistsContainer.length > 0 && $specialistsContainer.next('.add-specialist').length === 0) {
                var addSpecialistButton = '<button type="button" class="add-specialist ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">' +
                    '<span class="ui-button-text">Add Specialist</span>' +
                    '</button>';
                $specialistsContainer.after(addSpecialistButton);
            }
            
            $imagesContainer.append($newImageItem);
            
            // Setup the Add Specialist button for the new image
            setupSpecialistButtons($newImageItem, imageIndex);
            
            // Now add one specialist to this new image
            addSpecialistToImage($newImageItem, imageIndex);
            
            imageIndex++;
        });

        // Remove image
        $imagesContainer.on('click', '.remove-image', function(e) {
            e.preventDefault();
            $(this).closest('.image-item').remove();
        });

        // Remove specialist
        $imagesContainer.on('click', '.remove-specialist', function(e) {
            e.preventDefault();
            $(this).closest('.specialist-item').remove();
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
            setupFormValidation();
        }
    });

    /**
     * Setup form validation for specialist fields
     */
    function setupFormValidation() {
        // Find the form that contains the images collection
        var $form = $('#images-collection').closest('form');
        
        if ($form.length === 0) {
            return;
        }

        // Add custom validation on form submit
        $form.on('submit', function(e) {
            var isValid = true;
            var errorMessages = [];

            // Validate all specialist items
            $('.specialist-item').each(function(index) {
                var $specialistItem = $(this);
                var $specialist = $specialistItem.find('select[name*="[specialist]"]');
                var $speciality = $specialistItem.find('select[name*="[speciality]"]');
                var $year = $specialistItem.find('select[name*="[year]"]');

                var hasSpecialist = $specialist.val() !== '';
                var hasSpeciality = $speciality.val() !== '';
                var hasYear = $year.val() !== '';

                // If any field is filled, all must be filled
                if (hasSpecialist || hasSpeciality || hasYear) {
                    if (!hasSpecialist) {
                        isValid = false;
                        $specialist.css('border', '2px solid red');
                        errorMessages.push('Specialist field is required when adding a specialist (Item #' + (index + 1) + ')');
                    } else {
                        $specialist.css('border', '');
                    }

                    if (!hasSpeciality) {
                        isValid = false;
                        $speciality.css('border', '2px solid red');
                        errorMessages.push('Speciality field is required when adding a specialist (Item #' + (index + 1) + ')');
                    } else {
                        $speciality.css('border', '');
                    }

                    if (!hasYear) {
                        isValid = false;
                        $year.css('border', '2px solid red');
                        errorMessages.push('Year field is required when adding a specialist (Item #' + (index + 1) + ')');
                    } else {
                        $year.css('border', '');
                    }
                } else {
                    // All fields are empty, which is fine - clear any previous error styling
                    $specialist.css('border', '');
                    $speciality.css('border', '');
                    $year.css('border', '');
                }
            });

            if (!isValid) {
                e.preventDefault();
                alert('Please fill in all required fields for specialists:\n\n' + errorMessages.join('\n'));
                return false;
            }

            return true;
        });

        // Clear error styling when user changes the value
        $(document).on('change', '.specialist-item select', function() {
            $(this).css('border', '');
        });
    }

})(jQuery);
