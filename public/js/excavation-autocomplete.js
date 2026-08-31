/**
 * Excavation/Trench Autocomplete for Locus forms
 * Format: SITE+SEASON-TRENCH (e.g., BE98-127)
 */
(function($) {
    $(document).ready(function() {
        var $searchInput = $('.excavation-autocomplete');
        if ($searchInput.length === 0) return;

        var $hiddenSelect = $('#locus_excavation');
        var $resultsContainer = $('<div class="excavation-autocomplete-results"></div>');
        var searchTimeout = null;
        var currentResults = [];

        // Position and style the results container
        $resultsContainer.css({
            'position': 'absolute',
            'background': 'white',
            'border': '1px solid #ccc',
            'max-height': '300px',
            'overflow-y': 'auto',
            'z-index': 1000,
            'display': 'none',
            'box-shadow': '0 2px 4px rgba(0,0,0,0.2)'
        });

        // Insert after the search input
        $searchInput.after($resultsContainer);

        // Position the results container
        function positionResults() {
            var offset = $searchInput.offset();
            var inputHeight = $searchInput.outerHeight();
            var inputWidth = $searchInput.outerWidth();

            $resultsContainer.css({
                'top': offset.top + inputHeight,
                'left': offset.left,
                'width': inputWidth
            });
        }

        // Search function with debouncing
        $searchInput.on('input', function() {
            clearTimeout(searchTimeout);
            var query = $(this).val().trim();

            if (query.length < 2) {
                $resultsContainer.hide();
                return;
            }

            searchTimeout = setTimeout(function() {
                performSearch(query);
            }, 300);
        });

        function performSearch(query) {
            $.ajax({
                url: window.EXCAVATION_SEARCH_URL || '/berenike/locus/search-excavations',
                method: 'GET',
                data: { q: query },
                dataType: 'json',
                success: function(data) {
                    currentResults = data;
                    displayResults(data);
                },
                error: function() {
                    $resultsContainer.hide();
                }
            });
        }

        function displayResults(results) {
            $resultsContainer.empty();

            if (results.length === 0) {
                $resultsContainer.hide();
                return;
            }

            results.forEach(function(result) {
                var $item = $('<div></div>')
                    .text(result.label)
                    .css({
                        'padding': '8px 12px',
                        'cursor': 'pointer',
                        'border-bottom': '1px solid #eee'
                    })
                    .data('excavation-id', result.id)
                    .data('excavation-label', result.label);

                $item.hover(
                    function() { $(this).css('background-color', '#f0f0f0'); },
                    function() { $(this).css('background-color', 'white'); }
                );

                $item.on('click', function() {
                    selectExcavation($(this).data('excavation-id'), $(this).data('excavation-label'));
                });

                $resultsContainer.append($item);
            });

            positionResults();
            $resultsContainer.show();
        }

        function selectExcavation(id, label) {
            $searchInput.val(label);
            $hiddenSelect.val(id);
            $resultsContainer.hide();
        }

        // Hide results when clicking outside
        $(document).on('click', function(e) {
            if (!$(e.target).closest('.excavation-autocomplete, .excavation-autocomplete-results').length) {
                $resultsContainer.hide();
            }
        });

        // Reposition on window resize
        $(window).on('resize', function() {
            if ($resultsContainer.is(':visible')) {
                positionResults();
            }
        });

        // Form validation
        $searchInput.closest('form').on('submit', function(e) {
            var searchValue = $searchInput.val().trim();
            var selectedValue = $hiddenSelect.val();

            if (searchValue && !selectedValue) {
                e.preventDefault();
                alert('Please select a trench from the dropdown list.');
                return false;
            }
        });

        // Initialize: If hidden select has a value, populate search field
        if ($hiddenSelect.val()) {
            var selectedOption = $hiddenSelect.find('option:selected');
            if (selectedOption.length) {
                $searchInput.val(selectedOption.text());
            }
        }
    });
})(jQuery);
