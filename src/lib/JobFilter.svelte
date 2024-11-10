<script>
    import JobCard from './JobCard.svelte';
    export let filteredJobs = [];
</script>

<div class="job-list">
    {#if filteredJobs.length > 0}
        {#each filteredJobs as job}
            <JobCard {job} />
        {/each}
    {:else}
        <p>No jobs found for your search criteria.</p>
    {/if}
</div>

<style>
    .job-list {
        display: grid;
        gap: 1rem;
    }
</style>
