<script>
  import { goto } from '$app/navigation';
  import CategoryFilter from './CategoryFilter.svelte';
  import JobCard from './JobCard.svelte';
  import ChatBox from './ChatBox.svelte';
  import { user } from "../stores/user.js";
  import axios from 'axios';
  import { onMount } from 'svelte';
  import FaRegUserCircle from 'svelte-icons/fa/FaRegUserCircle.svelte'
  import AppBar from './AppBar.svelte';

  let searchQuery = '';
  let selectedCategory = '';
  let filteredJobs = [];
  let currentPage = 1;
  let jobsPerPage = 10;
  let totalPages = 1;


  let allJobs = [];
  onMount(async () => {
    const response = await axios.get('http://localhost:8080/job-service/getJobs')
    const totalElements = response.data.content
    console.log('aaaaaaaa 8765432')
    console.log(response.data.content)

    allJobs = response.data.content

//     try {
//           const response = await axios.post('http://localhost:8080/job-service/graphql', {
//       query: `query MyQuery {
//   jobs(limit: 50) {
//     totalElements
//     totalPages
//     content {
//       companyId
//       companyName
//       jobId
//       requiredExperience
//       salary
//       requiredSkills
//       title
//       workLocation
//       employmentType
//       location
//         }
//       }
//     }`
//  }, {
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': `Bearer ${$user.jwt}`
//         }
//       })
      
//       console.log("XD")
//       console.log(response.data)
//       console.log(response.data.data)
//       const totalElements = response.data.data.jobs.totalElements
//       console.log(totalElements)
//       console.log(response.data.data.jobs.content)
//       allJobs = response.data.data.jobs.content
//     }catch  (error) {
//       console.log("XD2")
//       console.log(error)
//     }

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


<AppBar/>

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

  main {
    margin-top: 60px;
    display: flex;
    flex-direction: column;
    height: calc(100vh - 60px);
  }


  .search-container {

    padding: 1rem;
    background-color: #f9f9f9;
    border-bottom: 1px solid #ddd;
  }


  .job-list-container {
    flex: 1;
    overflow-y: auto;
    padding: 1rem;
  }

  .job-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

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


  input[type='text'] {
    width: 100%;
    padding: 0.5rem;
    margin-bottom: 1rem;
    font-size: 1rem;
  }


  h1 {
    margin-bottom: 1rem;
  }
</style>
