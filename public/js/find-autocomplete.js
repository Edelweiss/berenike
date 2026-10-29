/**
 * Find Autocomplete System
 * Allows searching and selecting finds by ID, object number, or handle
 */

document.addEventListener('DOMContentLoaded', function() {
    const findsSearchUrl = window.FIND_SEARCH_URL;
    if (!findsSearchUrl) {
        console.warn('FIND_SEARCH_URL not defined');
        return;
    }

    // Find the search input and hidden finds select
    const findSearchInput = document.getElementById('asset_findsSearch');
    const findsSelect = document.getElementById('asset_finds');
    const findListContainer = document.getElementById('finds-list');

    if (!findSearchInput || !findsSelect || !findListContainer) {
        return;
    }

    let resultsDropdown = null;
    let selectedFindsMap = new Map(); // Map of find ID to find data

    // Initialize with already selected finds
    Array.from(findsSelect.selectedOptions).forEach(option => {
        if (option.value) {
            selectedFindsMap.set(parseInt(option.value), {
                id: parseInt(option.value),
                label: option.textContent.trim()
            });
        }
    });
    renderFindsList();

    // Input event for autocomplete
    findSearchInput.addEventListener('input', function(e) {
        const query = this.value.trim();
        
        if (query.length < 1) {
            closeResults();
            return;
        }

        fetch(findsSearchUrl + '?q=' + encodeURIComponent(query))
            .then(response => response.json())
            .then(data => {
                showResults(data);
            })
            .catch(err => {
                console.error('Find search error:', err);
            });
    });

    // Prevent form submission on Enter
    findSearchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
        }
    });

    function showResults(results) {
        // Remove old dropdown if exists
        if (resultsDropdown) {
            resultsDropdown.remove();
        }

        if (results.length === 0) {
            findSearchInput.classList.add('error');
            return;
        }

        findSearchInput.classList.remove('error');

        // Create dropdown
        resultsDropdown = document.createElement('div');
        resultsDropdown.className = 'find-autocomplete-results ui-widget-content ui-corner-all';
        resultsDropdown.style.cssText = 'position: absolute; top: ' + (findSearchInput.offsetTop + findSearchInput.offsetHeight) + 'px; left: ' + findSearchInput.offsetLeft + 'px; width: ' + findSearchInput.offsetWidth + 'px; z-index: 1000; background-color: white; border: 1px solid #ccc;';

        results.forEach(find => {
            const div = document.createElement('div');
            div.textContent = find.label;
            div.style.cssText = 'padding: 8px; border-bottom: 1px solid #ddd; cursor: pointer;';
            
            div.addEventListener('click', function() {
                selectFind(find);
            });
            
            div.addEventListener('mouseover', function() {
                this.style.backgroundColor = '#f0f0f0';
            });
            
            div.addEventListener('mouseout', function() {
                this.style.backgroundColor = 'transparent';
            });

            resultsDropdown.appendChild(div);
        });

        findSearchInput.parentNode.style.position = 'relative';
        findSearchInput.parentNode.appendChild(resultsDropdown);
    }

    function closeResults() {
        if (resultsDropdown) {
            resultsDropdown.remove();
            resultsDropdown = null;
        }
    }

    function selectFind(find) {
        // Add to selected finds
        if (!selectedFindsMap.has(find.id)) {
            selectedFindsMap.set(find.id, find);
            updateFindsSelect();
            renderFindsList();
        }

        // Clear input
        findSearchInput.value = '';
        closeResults();
    }

    function removeFind(findId) {
        selectedFindsMap.delete(findId);
        updateFindsSelect();
        renderFindsList();
    }

    function updateFindsSelect() {
        // Update the hidden select with selected find IDs
        Array.from(findsSelect.options).forEach(option => {
            option.selected = selectedFindsMap.has(parseInt(option.value));
        });
    }

    function renderFindsList() {
        // Clear and rebuild finds list
        findListContainer.innerHTML = '';

        if (selectedFindsMap.size === 0) {
            const emptyMsg = document.createElement('p');
            emptyMsg.textContent = 'No finds linked yet.';
            emptyMsg.style.cssText = 'font-size: 0.9em; color: #999;';
            findListContainer.appendChild(emptyMsg);
            return;
        }

        selectedFindsMap.forEach(find => {
            const item = document.createElement('div');
            item.className = 'find-item';
            item.style.cssText = 'display: flex; justify-content: space-between; align-items: center; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 8px; background-color: #f9f9f9;';

            const label = document.createElement('span');
            label.className = 'find-item-label';
            label.textContent = find.label;
            label.style.cssText = 'flex: 1; font-size: 14px;';

            const removeBtn = document.createElement('button');
            removeBtn.type = 'button';
            removeBtn.textContent = 'Remove';
            removeBtn.className = 'find-item-remove';
            removeBtn.style.cssText = 'background-color: #dc3545; color: white; border: none; padding: 4px 8px; border-radius: 3px; cursor: pointer; font-size: 12px; margin-left: 8px;';

            removeBtn.addEventListener('click', function(e) {
                e.preventDefault();
                removeFind(find.id);
            });

            removeBtn.addEventListener('mouseover', function() {
                this.style.backgroundColor = '#c82333';
            });

            removeBtn.addEventListener('mouseout', function() {
                this.style.backgroundColor = '#dc3545';
            });

            item.appendChild(label);
            item.appendChild(removeBtn);
            findListContainer.appendChild(item);
        });
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (e.target !== findSearchInput && resultsDropdown) {
            closeResults();
        }
    });
});
