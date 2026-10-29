/**
 * Specialist Autocomplete System
 * Allows searching and selecting specialists by name and adding year/speciality
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('[Specialist Autocomplete] Initializing...');
    
    const specialistSearchUrl = window.SPECIALIST_SEARCH_URL;
    console.log('[Specialist Autocomplete] Search URL:', specialistSearchUrl);
    
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

    console.log('[Specialist Autocomplete] Elements found:', {
        specialistSearchInput: !!specialistSearchInput,
        specialistYearInput: !!specialistYearInput,
        specialistSpecialityInput: !!specialistSpecialityInput,
        specialistListContainer: !!specialistListContainer,
        addSpecialistBtn: !!addSpecialistBtn,
        newImageSpecialistsField: !!newImageSpecialistsField,
        form: !!form,
    });

    if (!specialistSearchInput || !specialistListContainer || !addSpecialistBtn) {
        console.error('[Specialist Autocomplete] Missing required elements');
        return;
    }

    let resultsDropdown = null;
    let selectedSpecialist = null; // Holds the selected specialist data
    let newSpecialistsToAdd = []; // Array of new specialists to add

    // Initialize with existing specialists from the page
    const existingSpecialists = document.querySelectorAll('[data-specialist-id]');
    console.log('[Specialist Autocomplete] Found', existingSpecialists.length, 'existing specialists');
    
    const existingSpecialistMap = new Map();
    existingSpecialists.forEach((elem) => {
        const specialistId = parseInt(elem.getAttribute('data-specialist-id'));
        const year = elem.getAttribute('data-specialist-year') || '';
        const speciality = elem.getAttribute('data-specialist-speciality') || '';
        const name = elem.getAttribute('data-specialist-name');
        
        const key = specialistId + '_' + year + '_' + speciality;
        existingSpecialistMap.set(key, {
            id: specialistId,
            name: name,
            year: year,
            speciality: speciality,
            isNew: false,
        });
        console.log('[Specialist Autocomplete] Pre-loaded existing specialist:', name);
    });
    
    renderSpecialistsList(existingSpecialistMap);

    // Input event for autocomplete
    specialistSearchInput.addEventListener('input', function(e) {
        const query = this.value.trim();
        console.log('[Specialist Autocomplete] Query input:', query);
        
        if (query.length < 1) {
            closeResults();
            return;
        }

        const url = specialistSearchUrl + '?q=' + encodeURIComponent(query);
        console.log('[Specialist Autocomplete] Fetching:', url);
        
        fetch(url)
            .then(response => {
                console.log('[Specialist Autocomplete] Response status:', response.status);
                return response.json();
            })
            .then(data => {
                console.log('[Specialist Autocomplete] Got', data.length, 'results');
                showResults(data);
            })
            .catch(err => {
                console.error('[Specialist Autocomplete] Fetch error:', err);
            });
    });

    // Prevent form submission on Enter
    specialistSearchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Enter') {
            e.preventDefault();
        }
    });

    // Add specialist button click
    addSpecialistBtn.addEventListener('click', function(e) {
        e.preventDefault();
        
        if (!selectedSpecialist) {
            console.log('[Specialist Autocomplete] No specialist selected');
            alert('Please select a specialist first');
            return;
        }
        
        const year = specialistYearInput ? specialistYearInput.value.trim() : '';
        const speciality = specialistSpecialityInput ? specialistSpecialityInput.value.trim() : 'photographer';
        
        console.log('[Specialist Autocomplete] Adding specialist:', selectedSpecialist.id, year, speciality);
        addSpecialist(selectedSpecialist, year, speciality, existingSpecialistMap);
        
        // Clear inputs
        specialistSearchInput.value = '';
        if (specialistYearInput) specialistYearInput.value = '';
        if (specialistSpecialityInput) specialistSpecialityInput.value = '';
        selectedSpecialist = null;
        closeResults();
    });

    // Form submit handler - save new specialists to hidden field
    if (form) {
        form.addEventListener('submit', function(e) {
            if (newSpecialistsToAdd.length > 0 && newImageSpecialistsField) {
                console.log('[Specialist Autocomplete] Saving', newSpecialistsToAdd.length, 'new specialists to form');
                newImageSpecialistsField.value = JSON.stringify(newSpecialistsToAdd);
            }
        });
    }

    function showResults(results) {
        // Remove old dropdown if exists
        if (resultsDropdown) {
            resultsDropdown.remove();
        }

        if (results.length === 0) {
            specialistSearchInput.classList.add('error');
            console.log('[Specialist Autocomplete] No results');
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

    function addSpecialist(specialist, year, speciality, existingMap) {
        const key = specialist.id + '_' + year + '_' + speciality;
        
        if (existingMap.has(key) || newSpecialistsToAdd.some(s => s.specialistId == specialist.id && s.year === year && s.speciality === speciality)) {
            console.log('[Specialist Autocomplete] Specialist already added');
            alert('This specialist with this year/speciality is already linked');
            return;
        }
        
        // Add to new specialists array
        newSpecialistsToAdd.push({
            specialistId: specialist.id,
            year: year || null,
            speciality: speciality || null,
        });
        
        console.log('[Specialist Autocomplete] Added specialist to array, total:', newSpecialistsToAdd.length);
        renderSpecialistsList(existingMap);
    }

    function removeSpecialist(specialistId, year, speciality) {
        console.log('[Specialist Autocomplete] Removing specialist:', specialistId, year, speciality);
        
        newSpecialistsToAdd = newSpecialistsToAdd.filter(s => !(s.specialistId == specialistId && s.year === year && s.speciality === speciality));
        console.log('[Specialist Autocomplete] Removed, remaining:', newSpecialistsToAdd.length);
        
        renderSpecialistsList();
    }

    function renderSpecialistsList(existingMap = null) {
        // Clear and rebuild specialists list
        specialistListContainer.innerHTML = '';

        // Render existing specialists
        if (existingMap) {
            existingMap.forEach((specialist) => {
                renderSpecialistItem(specialist, false);
            });
        }
        
        // Render new specialists
        newSpecialistsToAdd.forEach(specialist => {
            // Fetch specialist name from cache or display ID
            const specialistName = 'Specialist #' + specialist.specialistId;
            renderSpecialistItem({
                id: specialist.specialistId,
                name: specialistName,
                year: specialist.year || '',
                speciality: specialist.speciality || '',
            }, true);
        });

        if ((existingMap ? existingMap.size : 0) + newSpecialistsToAdd.length === 0) {
            const emptyMsg = document.createElement('p');
            emptyMsg.textContent = 'No specialists linked yet.';
            emptyMsg.style.cssText = 'font-size: 0.9em; color: #999;';
            specialistListContainer.appendChild(emptyMsg);
        }
    }

    function renderSpecialistItem(specialist, isNew) {
        const item = document.createElement('div');
        item.className = 'specialist-item' + (isNew ? ' specialist-item-new' : '');
        item.style.cssText = 'display: flex; justify-content: space-between; align-items: center; padding: 8px; border: 1px solid #ddd; border-radius: 4px; margin-bottom: 8px; background-color: ' + (isNew ? '#e7f3ff' : '#f9f9f9') + '; border-left: 3px solid ' + (isNew ? '#007bff' : '#ccc') + ';';
        item.setAttribute('data-specialist-id', specialist.id);
        item.setAttribute('data-specialist-name', specialist.name);
        if (specialist.year) item.setAttribute('data-specialist-year', specialist.year);
        if (specialist.speciality) item.setAttribute('data-specialist-speciality', specialist.speciality);

        const label = document.createElement('span');
        label.className = 'specialist-item-label';
        let labelText = specialist.name;
        if (specialist.year) labelText += ' (' + specialist.year + ')';
        if (specialist.speciality) {
            const specialityLabel = specialist.speciality === 'photographer' ? 'Photographer' : 
                                   specialist.speciality === 'artist' ? 'Artist' : 
                                   specialist.speciality;
            labelText += ' - ' + specialityLabel;
        }
        if (isNew) labelText += ' (NEW)';
        label.textContent = labelText;
        label.style.cssText = 'flex: 1; font-size: 14px;';

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.textContent = 'Remove';
        removeBtn.className = 'specialist-item-remove';
        removeBtn.style.cssText = 'background-color: #dc3545; color: white; border: none; padding: 4px 8px; border-radius: 3px; cursor: pointer; font-size: 12px; margin-left: 8px;';

        removeBtn.addEventListener('click', function(e) {
            e.preventDefault();
            removeSpecialist(specialist.id, specialist.year, specialist.speciality);
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
