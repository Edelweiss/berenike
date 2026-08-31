/**
 * Bucket Autocomplete for Find Forms
 * Provides search-as-you-type functionality for bucket selection
 * Format: SITE+SEASON-TRENCH/LOCUS/BUCKET (e.g., BE98-127/999/1)
 */
(function() {
    'use strict';
    
    $(document).ready(function() {
        const $searchInput = $('.bucket-autocomplete');
        const $bucketSelect = $('#find_bucket');
        let selectedBucketId = null;
        
        if ($searchInput.length === 0) {
            return;
        }
        
        // Initialize with current value if editing
        if ($bucketSelect.val()) {
            selectedBucketId = $bucketSelect.val();
            const selectedText = $bucketSelect.find('option:selected').text();
            if (selectedText && selectedText.trim() !== '') {
                $searchInput.val(selectedText);
            }
        }
        
        // Create autocomplete results container
        const $resultsContainer = $('<div>')
            .addClass('bucket-autocomplete-results')
            .css({
                'position': 'absolute',
                'z-index': 1000,
                'background': 'white',
                'border': '1px solid #ccc',
                'max-height': '300px',
                'overflow-y': 'auto',
                'display': 'none',
                'box-shadow': '0 2px 4px rgba(0,0,0,0.2)',
                'width': $searchInput.outerWidth() + 'px'
            });
        
        $searchInput.after($resultsContainer);
        
        // Position results container
        function positionResults() {
            const offset = $searchInput.offset();
            const height = $searchInput.outerHeight();
            $resultsContainer.css({
                'top': (offset.top + height) + 'px',
                'left': offset.left + 'px',
                'width': $searchInput.outerWidth() + 'px'
            });
        }
        
        // Debounce function
        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }
        
        // Search buckets
        const searchBuckets = debounce(function(query) {
            if (query.length < 2) {
                $resultsContainer.hide();
                return;
            }
            
            $.ajax({
                url: window.BUCKET_SEARCH_URL || '/berenike/find/search-buckets',
                method: 'GET',
                data: { q: query },
                success: function(results) {
                    displayResults(results);
                },
                error: function() {
                    $resultsContainer.hide();
                }
            });
        }, 300);
        
        // Display search results
        function displayResults(results) {
            $resultsContainer.empty();
            
            if (results.length === 0) {
                $resultsContainer
                    .append($('<div>').css('padding', '8px').text('No buckets found'))
                    .show();
                positionResults();
                return;
            }
            
            results.forEach(function(bucket) {
                const $item = $('<div>')
                    .css({
                        'padding': '8px 12px',
                        'cursor': 'pointer',
                        'border-bottom': '1px solid #eee'
                    })
                    .text(bucket.label)
                    .data('bucket-id', bucket.id)
                    .hover(
                        function() { $(this).css('background-color', '#f0f0f0'); },
                        function() { $(this).css('background-color', 'white'); }
                    )
                    .click(function() {
                        selectBucket(bucket.id, bucket.label);
                    });
                
                $resultsContainer.append($item);
            });
            
            $resultsContainer.show();
            positionResults();
        }
        
        // Select a bucket
        function selectBucket(bucketId, label) {
            selectedBucketId = bucketId;
            $searchInput.val(label);
            $bucketSelect.val(bucketId);
            $resultsContainer.hide();
            
            // Mark the select as having a valid selection
            $bucketSelect.addClass('bucket-selected');
        }
        
        // Event handlers
        $searchInput.on('input', function() {
            const query = $(this).val();
            
            // Clear selection if user modifies the input
            if (selectedBucketId) {
                $bucketSelect.val('');
                selectedBucketId = null;
                $bucketSelect.removeClass('bucket-selected');
            }
            
            searchBuckets(query);
        });
        
        $searchInput.on('focus', function() {
            const query = $(this).val();
            if (query.length >= 2) {
                searchBuckets(query);
            }
        });
        
        // Hide results when clicking outside
        $(document).on('click', function(e) {
            if (!$(e.target).closest('.bucket-autocomplete, .bucket-autocomplete-results').length) {
                $resultsContainer.hide();
            }
        });
        
        // Reposition on window resize
        $(window).on('resize', function() {
            if ($resultsContainer.is(':visible')) {
                positionResults();
            }
        });
        
        // Form validation: ensure a bucket is selected
        $searchInput.closest('form').on('submit', function(e) {
            if ($searchInput.val() && !$bucketSelect.val()) {
                e.preventDefault();
                alert('Please select a bucket from the dropdown suggestions.');
                $searchInput.focus();
                return false;
            }
        });
    });
})();
