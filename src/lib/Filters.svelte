<script>
    export let filters;
    // export let onApplyFilters;
    export let companies = [];
    import { createEventDispatcher } from 'svelte';
    
    const dispatch = createEventDispatcher();
    function applyFilters() {
        dispatch('applyFilters', { filters });
    }
    // Manage selected skills
    let filteredCompanies = [];
    let dropdownVisible = false;


    function handleWorkLocationChange(event) {
        filters.workLocation = event.target.value;
    }

    function handleEmploymentTypeChange(event) {
        filters.employmentType = event.target.value;
    }

    function handleExperienceLevel(event) {
        filters.experienceLevel = event.target.value;
    }

    function filterCompanies() {
        const query = filters.companyName?.toLowerCase() || '';
        if (query) {
            filteredCompanies = companies.filter((company) =>
                company.name.toLowerCase().startsWith(query)
            );
        } else {
            filteredCompanies = [];
        }
    }


    $: filterCompanies();

    function selectCompany(company) {
        filters.companyName = company.name;
        filters.companyId = company.id;
        filteredCompanies = [];
        dropdownVisible = false
    }
</script>

<div class="filter-section">
    <h2>Filters</h2>
    <div class="company-filter-container">
        <label>
            Company
            <div class="input-dropdown-wrapper">
                <input
                        type="text"
                        bind:value={filters.companyName}
                        on:input={() => {
                    dropdownVisible = true;
                    filterCompanies();
                }}
                on:focus={() => (dropdownVisible = true)}
                on:blur={() => setTimeout(() => (dropdownVisible = false), 100)}
                placeholder="Search for a company..."
                />
                {#if dropdownVisible && filteredCompanies.length > 0}
                    <ul class="dropdown">
                        {#each filteredCompanies as company}
                            <li on:click={() => selectCompany(company)}>
                                {company.name}
                            </li>
                        {/each}
                    </ul>
                {/if}
            </div>
        </label>
    </div>

    <label>
        Location
        <input type="text" bind:value={filters.location} />
    </label>
    <label>
        Work Type
        <select bind:value={filters.workLocation} on:change={handleWorkLocationChange}>
            <option value="">Any</option>
            <option value="remote">Remote</option>
            <option value="onsite">On Site</option>
            <option value="hybrid">Hybrid</option>
        </select>
    </label>
    <label>
        Employment Type
        <select bind:value={filters.employmentType} on:change={handleEmploymentTypeChange}>
            <option value="">Any</option>
            <option value="full_time">Full Time</option>
            <option value="part_time">Part Time</option>
            <option value="contract">Contract</option>
            <option value="internship">Internship</option>
            <option value="temporary">Temporary</option>
            <option value="freelance">Freelance</option>
        </select>
    </label>
    <label>
        Experience Level
        <select bind:value={filters.experienceLevel} on:change={handleExperienceLevel}>
            <option value="">Any</option>
            <option value="intern">Intern</option>
            <option value="junior">Junior</option>
            <option value="mid">Mid</option>
            <option value="senior">Senior</option>
            <option value="lead">Lead</option>
            <option value="manager">Manager</option>
            <option value="director">Director</option>
            <option value="executive">Executive</option>
        </select>
    </label>
    <label class="has-salary-container">
        <span>Has Salary</span>
        <input type="checkbox" bind:checked={filters.hasSalary}  />
    </label>
    <label>
        Min Salary
        <input type="number" bind:value={filters.minSalary} />
    </label>
    <label>
        Max Salary
        <input type="number" bind:value={filters.maxSalary} />
    </label>
    <button on:click={applyFilters}>Apply Filters</button>
</div>

<style>
    .filter-section {
        flex: 0.7;
        background-color: #ffffff;
        border-radius: 0.375rem;
        padding: 1.5rem;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
        gap: 0.3rem;
    }

    .filter-section label {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;
    }

    .filter-section select,
    .filter-section input,
    .filter-section button {
        padding: 0.75rem 1rem;
        font-size: 1rem;
        border: 1px solid #ddd;
        border-radius: 0.375rem;
    }

    .filter-section button {
        background-color: #758c96;
        color: white;
        border: none;
        cursor: pointer;
    }

    .filter-section button:hover {
        background-color: #8697C4;
    }

    .has-salary-container {
        display: flex;
        flex-direction: row !important;
        align-items: center;
        justify-content: flex-start;
        gap: 0.5rem;
        margin-top: 0.5rem;
        margin-bottom: 1rem;
    }

    .has-salary-container span {
        font-size: 1rem;
        color: #333;
    }

    .has-salary-container input[type="checkbox"] {
        width: 1.2rem;
        height: 1.2rem;
        cursor: pointer;
        accent-color: #758c96;
        border: 1px solid #ddd;
        border-radius: 4px;
    }

    .company-filter-container {
        position: relative;
        width: 100%;
    }

    .input-dropdown-wrapper {
        position: relative;
        width: 100%;
    }

    .input-dropdown-wrapper input {
        width: 100%;
        box-sizing: border-box;
    }

    .dropdown {
        position: absolute;
        top: 80%;
        left: 0;
        width: 100%;
        background-color: white;
        border: 1px solid #ddd;
        border-radius: 0.375rem;
        max-height: 10rem;
        overflow-y: auto;
        z-index: 10;
        list-style-type: none;
        padding: 0;
        margin-bottom: 0;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    }

    .dropdown li {
        padding: 0.5rem 0.75rem;
        margin: 0;
        cursor: pointer;
        font-size: 1rem;
        text-align: left;
        white-space: nowrap;
    }

    .dropdown li:hover {
        background-color: #e0e0e0;
    }

    .dropdown li:active {
        background-color: #d9d9d9;
    }
</style>
