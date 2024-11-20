<script>
  import { goto } from '$app/navigation';
  import CategoryFilter from './CategoryFilter.svelte';
  import JobCard from './JobCard.svelte';
  import ChatBox from './ChatBox.svelte';
  import { user } from "../stores/user.js";
  import axios from 'axios';
  import { onMount } from 'svelte';

  let searchQuery = '';
  let selectedCategory = '';
  let filteredJobs = [];
  let currentPage = 1;
  let jobsPerPage = 10;
  let totalPages = 1;


  let allJobs = [];
  onMount(async () => {
    try {
          const response = await axios.post('http://localhost:8080/job-service/graphql', {
      query: `query MyQuery {
  jobs(limit: 50) {
    totalElements
    totalPages
    content {
      companyId
      companyName
      jobId
      requiredExperience
      salary
      requiredSkills
      title
      workLocation
      employmentType
      location
        }
      }
    }`
 }, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${$user.jwt}`
        }
      })
      
      console.log("XD")
      console.log(response.data)
      console.log(response.data.data)
      const totalElements = response.data.data.jobs.totalElements
      console.log(totalElements)
      console.log(response.data.data.jobs.content)
      allJobs = response.data.data.jobs.content
    }catch  (error) {
      console.log("XD2")
      console.log(error)
    }

    filteredJobs = allJobs;
    console.log(filteredJobs)
    totalPages = Math.ceil(filteredJobs.length / jobsPerPage);
    console.log('as')
    console.log(filteredJobs)
  }
  );

  function filterJobs() {
  filteredJobs = allJobs.filter((job) => {
    const matchesQuery =
      job.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      job.companyName.toLowerCase().includes(searchQuery.toLowerCase());
    // Remove matchesCategory if category filtering is not needed
    return matchesQuery;
  });
  totalPages = Math.ceil(filteredJobs.length / jobsPerPage);
  currentPage = 1;
}


  function changePage(pageNumber) {
    if (pageNumber >= 1 && pageNumber <= totalPages) {
      currentPage = pageNumber;
    }
  }

  $: paginatedJobs = filteredJobs.slice(
  (currentPage - 1) * jobsPerPage,
  currentPage * jobsPerPage
);

  console.log('xd4')
  console.log(paginatedJobs)
</script>


<div class="app-bar">
  <div class="nav-links">
    <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
    <!-- <a href="/test1" class="app-name" aria-label="Go to home">Test1</a> -->
    {#if $user.role === 'recruiter'}
      <a href="/recruiter/jobs" class="app-name" aria-label="Create job">My job offers</a>
    {/if}
    <!-- <text>{$user.role}</text> -->
    <!-- <text>{$user.jwt}</text> -->
  </div>

    <button class="user-icon" on:click={() => goto('/settings')} aria-label="Go to settings">
      <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
          <circle cx="12" cy="8" r="4" />
          <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
      </svg>
  </button>
</div>


<main>
  <div class="search-container">
    <h1>Find Your Next Job</h1>
    <input
      type="text"
      placeholder="Search for jobs..."
      bind:value={searchQuery}
      on:input={filterJobs}
    />
  </div>


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

    <ChatBox />
  </div>
</main>

<style>
  body {
    margin: 0;
    padding: 0;
    overflow-x: hidden; /* Optional */
  }

  /* App Bar Styles */
  .app-bar {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    background-color: #007bff;
    padding: 0.5rem 1rem;
    color: white;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .app-name {
    color: white;
    text-decoration: none;
    font-size: 1.5rem;
  }

  .user-icon {
    background: none;
    border: none;
    cursor: pointer;
  }

  /* Main Content Styles */
  main {
    margin-top: 60px; /* Adjust to the height of your app bar */
    display: flex;
    flex-direction: column;
    height: calc(100vh - 60px); /* Full viewport height minus app bar */
  }

  /* Search Container Styles */
  .search-container {
    /* Keep search bar and filters visible */
    padding: 1rem;
    background-color: #f9f9f9;
    /* Optional: Add a bottom border or shadow for visual separation */
    border-bottom: 1px solid #ddd;
  }

  /* Job List Container Styles */
  .job-list-container {
    flex: 1; /* Take the remaining space */
    overflow-y: auto; /* Make this container scrollable */
    padding: 1rem;
  }

  /* Job List Styles */
  .job-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  /* Pagination Styles */
  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 1rem;
    margin: 1rem 0;
  }

  .pagination button {
    padding: 0.5rem 1rem;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  .pagination button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
  }

  /* Input Styles */
  input[type='text'] {
    width: 100%;
    padding: 0.5rem;
    margin-bottom: 1rem;
    font-size: 1rem;
  }

  /* Heading Styles */
  h1 {
    margin-bottom: 1rem;
  }
</style>
