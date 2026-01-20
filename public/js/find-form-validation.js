/**
 * Find Form Validation
 * Handles TM input validation
 */
(function($) {
    'use strict';

    function initFindFormValidation() {
        var tmInput = $('input[name$="[tm]"]');
        tmInput.on('input', function() {
            var value = $(this).val();
            if (value !== '') {
                if (parseInt(value) <= 0) {
                    this.setCustomValidity('TM must be a positive number');
                } else {
                    this.setCustomValidity('');
                }
            } else {
                this.setCustomValidity(''); // Empty value is allowed
            }
        });
    }

    // Initialize when document is ready
    $(document).ready(function() {
        initFindFormValidation();
    });

})(jQuery);
