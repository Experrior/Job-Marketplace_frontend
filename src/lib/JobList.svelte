<script>
    import JobCard from './JobCard.svelte';
    export let filteredJobs = [];
  
    // Pagination variables
    let currentPage = 1;
    const itemsPerPage = 20;
    let totalPages = Math.ceil(filteredJobs.length / itemsPerPage);
  
    // Derived variable to get jobs for the current page
    $: paginatedJobs = filteredJobs.slice(
      (currentPage - 1) * itemsPerPage,
      currentPage * itemsPerPage
    );
  
    // Function to change pages
    function changePage(page) {
      if (page >= 1 && page <= totalPages) {
        currentPage = page;
      }
    }
  </script>
  
  <style>
    .job-list-container {
      max-height: 600px; /* Adjust as needed */
      overflow-y: auto;
      padding: 1rem;
      border: 1px solid #ccc;
    }
  
    .job-list {
      display: grid;
      gap: 1rem;
    }
  
    .pagination {
      margin-top: 1rem;
      display: flex;
      justify-content: center;
      align-items: center;
    }
  
    .pagination button {
      padding: 0.5rem 1rem;
      margin: 0 0.25rem;
      background-color: #007bff;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 5px;
    }
  
    .pagination button:disabled {
      background-color: #ccc;
      cursor: not-allowed;
    }
  
    .pagination span {
      margin: 0 0.5rem;
    }
  </style>
  
  <div class="job-list-container">
    {#if paginatedJobs.length > 0}
      <div class="job-list">
        {#each paginatedJobs as job}
          <JobCard {job} />
        {/each}
      </div>
    {:else}
      <p>No jobs found for your search criteria.</p>
    {/if}
  </div>
  
  <!-- Pagination Controls -->
  {#if totalPages > 1}
    <div class="pagination">
      <button on:click={() => changePage(currentPage - 1)} disabled={currentPage === 1}>
        Previous
      </button>
      <span>Page {currentPage} of {totalPages}</span>
      <button on:click={() => changePage(currentPage + 1)} disabled={currentPage === totalPages}>
        Next
      </button>
    </div>
  {/if}
  