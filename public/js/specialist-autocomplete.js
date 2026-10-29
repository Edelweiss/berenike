/**
 * Specialist Autocomplete System
 * Allows searching and selecting specialists by name and adding year/speciality
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('[Specialist Autocomplete] Initializing...');
    
    const specialistSearchUrl = window.SPECIALIST_SEARCH_URL;
    
    if (!specialistSearchUrl) {
        console.error('[Specialist Autocomplete] SPECIALIST_SEARCH_URL not defined');
        return;
    }

    // Find the search input and form fields
    const specialistSearchInput = document.getElementById('asset_specialistSearch');
    const specialistYearInput = document.getElementById('asset_specialistYear');
    const specialistSpecialityInput = document.getElementById('asset_specialistSpeciality');
    const specialistListContainer = document.getElementById('specialists-list');
    const addSpecialistBtn = document.getElementById('add-specialist-btn');
    const newImageSpecialistsField = document.getElementById('new-image-specialists');
    const form = document.querySelector('form');

    if (!specialistSearchInput || !specialistListContainer || !addSpecialistBtn) {
        console.error('[Specialist Autocomplete] Missing required elements');
        return;
    }

    let resultsDropdown = null;
    let selectedSpecialist = null;
    let nextId = 0;
    
    // Store all specialists with unique internal ID
    // Structure: Map<internalId, {id, name, year, speciality, isExisting}>
    const specialistsMap = new Map();
    const existingSpecialistIds = new Set(); // Track which ones are from DB

    // Initialize with existing specialists from the page
    const existingSpecialistElements = document.querySelectorAll('[data-specialist-id]');
    console.log('[Specialist Autocomplete] Found', existingSpecialistElements.length, 'existing specialists');
    
    existingSpecialistElements.forEach((elem) => {
        const specialistId = parseInt(elem.getAttribute('data-specialist-id'));
        const year = elem.getAttribute('data-specialist-year') || '';
        const speciality = elem.getAttribute('data-specialist-speciality') || '';
        const name = elem.getAttribute('data-specialist-name');
        
        const internalId = 'existing_' + nextId;
        nextId++;
        
        specialistsMap.set(internalId, {
            id: specialistId,
            name: name,
            year: year,
            speciality: speciality,
            isExisting: true,
        });
        existingSpecialistIds.add(internalId);
        console.log('[Specialist Autocomplete] Loaded existing specialist:', internalId, name);
    });
    
    renderSpecialistsList();

    // Input event for autocomplete
    specialistSearchInput.addEventListener('input', function(e) {
        const query = this.value.trim();
        
        if (query.length < 1) {
            closeResults();
            return;
        }

        const url = specialistSearchUrl + '?q=' + encodeURIComponent(query);
        
        fetch(url)
            .then(response => response.json())
            .then(data => {
                console.log('[Specialist Autocomplete] Got', data.length, 'results');
                showResults(data);
            })
            .catch(err => {
                console.error('[Specialist Autocomplete] Fetch error:', err);
            });
    });

    // Add specialist button
    addSpecialistBtn.addEventListener('click', function(e) {
        e.preventDefault();
        
        if (!selectedSpecialist) {
            alert('Please select a specialist from the list');
            return;
        }
        
        const year = specialistYearInput ? specialistYearInput.value.trim() : '';
        const speciality = specialistSpecialityInput ? specialistSpecialityInput.value.trim() : 'photographer';
        
        console.log('[Specialist Autocomplete] Adding specialist:', selectedSpecialist.id, year, speciality);
        addSpecialist(selectedSpecialist, year, speciality);
        
        // Clear inputs
        specialistSearchInput.value = '';
        if (specialistYearInput) specialistYearInput.value = '';
        if (specialistSpecialityInput) specialistSpecialityInput.value = '';
        selectedSpecialist = null;
        closeResults();
    });

    // Form submit handler
    if (form) {
        form.addEventListener('submit', function(e) {
            updateNewSpecialistsField();
        });
    }

    function showResults(results) {
        // Remove old dropdown if exists
        if (resultsDropdown) {
            resultsDropdown.remove();
        }

        if (results.length === 0) {
            specialistSearchInput.classList.add('error');
            return;
        }

        specialistSearchInput.classList.remove('error');

        // Create dropdown
        resultsDropdown = document.createElement('div');
        resultsDropdown.className = 'specialist-autocomplete-results ui-widget-content ui-corner-all';
        resultsDropdown.style.cssText = 'position: absolute; top: ' + (specialistSearchInput.offsetTop + specialistSearchInput.offsetHeight) + 'px; left: ' + specialistSearchInput.offsetLeft + 'px; width: ' + specialistSearchInput.offsetWidth + 'px; z-index: 1000; background-color: white; border: 1px solid #ccc; max-height: 300px; overflow-y: auto;';

        results.forEach(specialist => {
            const div = document.createElement('div');
            div.textContent = specialist.label;
            div.style.cssText = 'padding: 8px; border-bottom: 1px solid #ddd; cursor: pointer;';
            
            div.addEventListener('click', function() {
                console.log('[Specialist Autocomplete] Selected specialist:', specialist.id, specialist.label);
                selectSpecialist(specialist);
            });
            
            div.addEventListener('mouseover', function() {
                this.style.backgroundColor = '#f0f0f0';
            });
            
            div.addEventListener('mouseout', function() {
                this.style.backgroundColor = 'transparent';
            });

            resultsDropdown.appendChild(div);
        });

        specialistSearchInput.parentNode.style.position = 'relative';
        specialistSearchInput.parentNode.appendChild(resultsDropdown);
    }

    function closeResults() {
        if (resultsDropdown) {
            resultsDropdown.remove();
            resultsDropdown = null;
        }
    }

    function selectSpecialist(specialist) {
        selectedSpecialist = specialist;
        specialistSearchInput.value = specialist.label;
        closeResults();
    }

    function addSpecialist(specialist, year, speciality) {
        // Check if already exists
        let exists = false;
        specialistsMap.forEach((spec) => {
            if (spec.id == specialist.id && spec.year === year && spec.speciality === speciality) {
                exists = true;
            }
        });
        
        if (exists) {
            alert('This specialist with this year/speciality is already linked');
            return;
        }
        
        const internalId = 'new_' + nextId;
        nextId++;
        
        specialistsMap.set(internalId, {
            id: specialist.id,
            name: specialist.label,
            year: year || '',
            speciality: speciality || 'photographer',
            isExisting: false,
        });
        
        console.log('[Specialist Autocomplete] Added specialist with internalId:', internalId);
        renderSpecialistsList();
        updateNewSpecialistsField();
    }

    function removeSpecialist(internalId) {
        console.log('[Specialist Autocomplete] Removing specialist with internalId:', internalId);
        
        if (!specialistsMap.has(internalId)) {
            console.error('[Specialist Autocomplete] Specialist not found:', internalId);
            return;
        }
        
        const specialist = specialistsMap.get(internalId);
        if (specialist.isExisting) {
            // For existing specialists, we'll send full data to backend for deletion
            // Store deletion info in a separate field
            const deletionField = document.getElementById('deleted-specialists-json');
            if (deletionField) {
                const deletedList = JSON.parse(deletionField.value || '[]');
                deletedList.push({
                    id: specialist.id,
                    year: specialist.year,
                    speciality: specialist.speciality,
                });
                deletionField.value = JSON.stringify(deletedList);
                console.log('[Specialist Autocomplete] Marked for deletion');
            }
        }
        
        specialistsMap.delete(internalId);
        console.log('[Specialist Autocomplete] Removed. Remaining:', specialistsMap.size);
        
        renderSpecialistsList();
        updateNewSpecialistsField();
    }

    function updateNewSpecialistsField() {
        // Collect only new specialists (not existing)
        const newSpecialists = [];
        specialistsMap.forEach((specialist, internalId) => {
            if (!specialist.isExisting) {
                newSpecialists.push({
                    specialistId: specialist.id,
                    year: specialist.year || null,
                    speciality: specialist.speciality || 'photographer',
                });
            }
        });
        
        if (newImageSpecialistsField) {
            newImageSpecialistsField.value = JSON.stringify(newSpecialists);
            console.log('[Specialist Autocomplete] Updated new specialists field with', newSpecialists.length, 'items');
        }
    }

    function renderSpecialistsList() {
        specialistListContainer.innerHTML = '';

        if (specialistsMap.size === 0) {
            const emptyMsg = document.createElement('p');
            emptyMsg.textContent = 'No specialists linked yet.';
            emptyMsg.style.cssText = 'font-size: 0.9em; color: #999;';
            specialistListContainer.appendChild(emptyMsg);
            return;
        }
        
        console.log('[Specialist Autocomplete] Rendering', specialistsMap.size, 'specialists');
        
        specialistsMap.forEach((specialist, internalId) => {
            renderSpecialistItem(specialist, internalId);
        });
    }

    function renderSpecialistItem(specialist, internalId) {
        const item = document.createElement('div');
        item.className = 'specialist-item' + (specialist.isExisting ? '' : ' specialist-item-new');
        item.id = 'specialist-item-' + internalId;
        item.style.cssText = 'display: flex; justify-content: space-between; align-items: center; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 8px; background-color: ' + (specialist.isExisting ? '#f9f9f9' : '#e7f3ff') + '; border-left: 3px solid ' + (specialist.isExisting ? '#ccc' : '#007bff') + ';';

        const label = document.createElement('span');
        label.className = 'specialist-item-label';
        
        // Build canonical title: Name — Speciality (Year)
        let parts = [];
        
        if (specialist.name) {
            parts.push(specialist.name);
        }
        
        if (specialist.speciality) {
            const specialityLabel = specialist.speciality === 'photographer' ? 'Photographer' : 
                                   specialist.speciality === 'artist' ? 'Artist' : 
                                   specialist.speciality;
            parts.push(specialityLabel);
        }
        
        let labelText = parts.join(' — ');
        
        if (specialist.year) {
            labelText += ' (' + specialist.year + ')';
        }
        
        if (!specialist.isExisting) labelText += ' (NEW)';
        
        label.textContent = labelText;
        label.style.cssText = 'flex: 1; font-size: 14px;';

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.textContent = 'Remove';
        removeBtn.className = 'specialist-item-remove';
        removeBtn.style.cssText = 'background-color: #dc3545; color: white; border: none; padding: 4px 8px; border-radius: 3px; cursor: pointer; font-size: 12px; margin-left: 8px;';

        removeBtn.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('[Specialist Autocomplete] Remove button clicked for internalId:', internalId);
            removeSpecialist(internalId);
        });

        removeBtn.addEventListener('mouseover', function() {
            this.style.backgroundColor = '#c82333';
        });

        removeBtn.addEventListener('mouseout', function() {
            this.style.backgroundColor = '#dc3545';
        });

        item.appendChild(label);
        item.appendChild(removeBtn);
        specialistListContainer.appendChild(item);
    }

    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (e.target !== specialistSearchInput && resultsDropdown) {
            closeResults();
        }
    });
    
    console.log('[Specialist Autocomplete] Initialization complete');
});
