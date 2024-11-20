<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';

    // Sample data store for educations
    let educations = writable([]);

    let newEducation = {
        institution_name: '',
        degree: '',
        start_date: '',
        end_date: ''
    };

    let isEditing = false;
    let editingIndex = null;

    function addEducation() {
        if (isEditing) {
            educations.update(items => {
                items[editingIndex] = { ...newEducation };
                return items;
            });
            isEditing = false;
            editingIndex = null;
        } else {
            educations.update(items => [...items, { ...newEducation }]);
        }
        newEducation = {
            institution_name: '',
            degree: '',
            start_date: '',
            end_date: ''
        };
    }

    function editEducation(index) {
        educations.subscribe(items => {
            newEducation = { ...items[index] };
        })();
        isEditing = true;
        editingIndex = index;
    }

    function deleteEducation(index) {
        educations.update(items => items.filter((_, i) => i !== index));
    }
</script>

<div class="personal-data-widget">
    <h2>Educations</h2>
    <form on:submit|preventDefault={addEducation}>
        <div class="form-group">
            <label for="institution_name">Institution Name</label>
            <input id="institution_name" type="text" bind:value={newEducation.institution_name} required />
        </div>
        <div class="form-group">
            <label for="degree">Degree</label>
            <input id="degree" type="text" bind:value={newEducation.degree} required />
        </div>
        <div class="form-group">
            <label for="start_date">Start Date</label>
            <input id="start_date" type="date" bind:value={newEducation.start_date} required />
        </div>
        <div class="form-group">
            <label for="end_date">End Date</label>
            <input id="end_date" type="date" bind:value={newEducation.end_date} required />
        </div>
        <button type="submit" class="btn">
            {isEditing ? 'Update Education' : 'Add Education'}
        </button>
    </form>

    <ul class="education-list">
        {#each $educations as education, index}
            <li class="education-item">
                <div>
                    <strong>{education.degree}</strong> at {education.institution_name}
                    <p>{education.start_date} - {education.end_date}</p>
                </div>
                <div class="actions">
                    <button class="edit-btn" on:click={() => editEducation(index)}>Edit</button>
                    <button class="delete-btn" on:click={() => deleteEducation(index)}>Delete</button>
                </div>
            </li>
        {/each}
    </ul>
</div>

<style>
    .educations-container {
        max-width: 600px;
        margin: 0 auto;
    }

    h2 {
        margin-bottom: 1rem;
        color: #333;
    }

    form {
        background-color: #fff;
        padding: 1rem;
        border-radius: 5px;
        margin-bottom: 2rem;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .form-group {
        display: flex;
        flex-direction: column;
        margin-bottom: 0.75rem;
    }

    label {
        margin-bottom: 0.25rem;
        color: #555;
    }

    input {
        padding: 0.5rem;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    .btn {
        background-color: #007bff;
        color: #fff;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .education-list {
        list-style: none;
        padding: 0;
    }

    .education-item {
        display: flex;
        justify-content: space-between;
        background-color: #f9f9f9;
        padding: 1rem;
        border-radius: 5px;
        margin-bottom: 0.5rem;
        align-items: center;
    }

    .actions button {
        margin-left: 0.5rem;
    }

    .edit-btn {
        background-color: #ffc107;
        color: #fff;
        padding: 0.25rem 0.5rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .delete-btn {
        background-color: #d9534f;
        color: #fff;
        padding: 0.25rem 0.5rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
</style>
