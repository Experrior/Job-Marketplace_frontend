<!-- CVOverview.svelte -->
<script>
    // Import necessary modules and stores
    import { onMount } from 'svelte';
    let cvs = [];

    // Fetch CV data (replace with actual data fetching logic)
    onMount(() => {
        cvs = [
            { id: 1, title: 'CV - John Doe', date: '2023-10-01' },
            { id: 2, title: 'CV - Jane Smith', date: '2023-11-15' },
        ];
    });

    function viewCV(id) {
        // Logic to view the CV
    }

    function deleteCV(id) {
        // Logic to delete the CV
    }
</script>

<div class="cv-overview-container">
    <h2>CV Overview</h2>
    {#if cvs.length > 0}
        <ul class="cv-list">
            {#each cvs as cv}
                <li class="cv-item">
                    <div class="cv-info">
                        <strong>{cv.title}</strong>
                        <p>Date Created: {cv.date}</p>
                    </div>
                    <div class="cv-actions">
                        <button class="btn view-btn" on:click={() => viewCV(cv.id)}>View</button>
                        <button class="btn delete-btn" on:click={() => deleteCV(cv.id)}>Delete</button>
                    </div>
                </li>
            {/each}
        </ul>
    {:else}
        <p>No CVs available.</p>
    {/if}
</div>

<style>
    .cv-overview-container {
        max-width: 800px;
        margin: 0 auto;
    }

    h2 {
        margin-bottom: 1.5rem;
        color: #333;
    }

    .cv-list {
        list-style: none;
        padding: 0;
    }

    .cv-item {
        display: flex;
        justify-content: space-between;
        background-color: #f9f9f9;
        padding: 1rem;
        border-radius: 5px;
        margin-bottom: 0.5rem;
        align-items: center;
    }

    .cv-info {
        flex: 1;
    }

    .cv-actions button {
        margin-left: 0.5rem;
    }

    .view-btn {
        background-color: #007bff;
        color: #fff;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .delete-btn {
        background-color: #d9534f;
        color: #fff;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
</style>
