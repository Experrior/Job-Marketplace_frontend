<script>
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';

    // Sample data store for experiences
    let experiences = writable([]);

    let newExperience = {
        company_name: '',
        role: '',
        start_date: '',
        end_date: ''
    };

    let isEditing = false;
    let editingIndex = null;

    function addExperience() {
        if (isEditing) {
            experiences.update(items => {
                items[editingIndex] = { ...newExperience };
                return items;
            });
            isEditing = false;
            editingIndex = null;
        } else {
            experiences.update(items => [...items, { ...newExperience }]);
        }
        newExperience = {
            company_name: '',
            role: '',
            start_date: '',
            end_date: ''
        };
    }

    function editExperience(index) {
        experiences.subscribe(items => {
            newExperience = { ...items[index] };
        })();
        isEditing = true;
        editingIndex = index;
    }

    function deleteExperience(index) {
        experiences.update(items => items.filter((_, i) => i !== index));
    }
</script>

<div class="personal-data-widget">
    <h2>Experiences</h2>
    <form on:submit|preventDefault={addExperience}>
        <div class="form-group">
            <label for="company_name">Company Name</label>
            <input id="company_name" type="text" bind:value={newExperience.company_name} required />
        </div>
        <div class="form-group">
            <label for="role">Role</label>
            <input id="role" type="text" bind:value={newExperience.role} required />
        </div>
        <div class="form-group">
            <label for="start_date">Start Date</label>
            <input id="start_date" type="date" bind:value={newExperience.start_date} required />
        </div>
        <div class="form-group">
            <label for="end_date">End Date</label>
            <input id="end_date" type="date" bind:value={newExperience.end_date} required />
        </div>
        <button type="submit" class="btn">
            {isEditing ? 'Update Experience' : 'Add Experience'}
        </button>
    </form>

    <ul class="experience-list">
        {#each $experiences as experience, index}
            <li class="experience-item">
                <div>
                    <strong>{experience.role}</strong> at {experience.company_name}
                    <p>{experience.start_date} - {experience.end_date}</p>
                </div>
                <div class="actions">
                    <button class="edit-btn" on:click={() => editExperience(index)}>Edit</button>
                    <button class="delete-btn" on:click={() => deleteExperience(index)}>Delete</button>
                </div>
            </li>
        {/each}
    </ul>
</div>

<style>
    .experiences-container {
        max-width: 600px;
        margin: 0 auto;
    }

    h2 {
        margin-bottom: 1rem;
        color: #333;
    }

    /* form {
        background-color: #fff;
        padding: 1rem;
        border-radius: 5px;
        margin-bottom: 2rem;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    } */

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

    .experience-list {
        list-style: none;
        padding: 0;
    }

    .experience-item {
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
