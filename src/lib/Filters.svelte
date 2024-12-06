<script>
    export let filters;
    export let skillsList; // List of available skills to choose from
    export let onApplyFilters;

    // Manage selected skills
    let selectedSkills = filters.requiredSkills || [];

    function toggleSkill(skill) {
        if (selectedSkills.includes(skill)) {
            selectedSkills = selectedSkills.filter((s) => s !== skill);
        } else {
            selectedSkills = [...selectedSkills, skill];
        }
        filters.requiredSkills = selectedSkills;
    }

    function handleWorkLocationChange(event) {
        filters.workLocation = event.target.value;
    }

    function handleEmploymentTypeChange(event) {
        filters.employmentType = event.target.value;
    }

    function handleExperienceLevel(event) {
        filters.experienceLevel = event.target.value;
    }
</script>

<div class="filter-section">
    <h2>Filters</h2>
    <label>
        Company Name
        <input type="text" bind:value={filters.companyId} />
    </label>
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
            <option value="entry">Junior</option>
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
    <button on:click={onApplyFilters}>Apply Filters</button>
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
        display: flex; /* Align elements in a row */
        flex-direction: row !important; /* Ensure horizontal alignment */
        align-items: center; /* Vertically center both elements */
        justify-content: flex-start; /* Align items to the left */
        gap: 0.5rem; /* Add spacing between the label and the checkbox */
        margin-top: 0.5rem;
        margin-bottom: 1rem; /* Optional: Add some spacing below */
    }

    .has-salary-container span {
        font-size: 1rem;
        color: #333; /* Match the text color with other labels */
    }

    .has-salary-container input[type="checkbox"] {
        width: 1.2rem;
        height: 1.2rem;
        cursor: pointer;
        accent-color: #758c96; /* Customize the checkbox color when checked */
        border: 1px solid #ddd;
        border-radius: 4px; /* Optional: Rounded corners for a clean look */
    }



</style>
