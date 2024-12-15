<script>
  import JobCard from './JobCard.svelte';
  import Filters from './Filters.svelte';
  import AppBar from './AppBar.svelte';
  import { onMount } from 'svelte';
  import axios from 'axios';
  import ChatBox from "$lib/ChatBox.svelte";
  import { user, verifyUser } from "$lib/stores/user.js";
  import { fetchSavedOffers } from './services.jobService.js';


  const apiGateway = import.meta.env.VITE_GATEWAY_URL;
  console.log("USING GATEWAY:", apiGateway);

  let searchQuery = '';
  let filteredJobs = [];
  let currentPage = 1;
  let jobsPerPage = 10;
  let totalPages = 1;

  let allJobs = [];
  let companies = [];
  let followedJobIds = new Set();

  let companiesLoaded = false;
  let loading = true;
  let filters = {
    location: '',
    requiredExperience: '',
    requiredSkills: [],
    companyId: '',
    hasSalary: false,
    minSalary: null,
    maxSalary: null,
  };

  let skillsList = [
    'JavaScript', 'Python', 'Java', 'React', 'Vue', 'Angular', 'Node.js', 'Express.js', 'Django',
    'Flask', 'Spring', 'Hibernate', 'JPA', 'SQL', 'NoSQL', 'MongoDB', 'PostgreSQL', 'MySQL',
    'Docker', 'Kubernetes', 'AWS', 'Azure', 'GCP', 'CI/CD', 'Jenkins', 'Git', 'Agile', 'Scrum',
    'Kanban', 'TDD', 'BDD', 'DDD', 'Microservices', 'REST', 'GraphQL', 'OAuth', 'JWT', 'SAML',
    'SSE', 'WebSockets', 'WebRTC', 'HTML', 'CSS'
  ];

  onMount(async () => {
    await fetchCompanies();
    if (verifyUser()) {
      await fetchRecommendations();
      const savedOffers = await fetchSavedOffers($user.jwt);
      followedJobIds = new Set(savedOffers.map((job) => job.jobId));
    }else{

      await fetchJobs();
    }

    loading = false;
  });

  function cleanFilters(filters) {
    const cleanedFilters = {};
    Object.keys(filters).forEach((key) => {
      const value = filters[key];
      if (Array.isArray(value) && value.length > 0) {
        cleanedFilters[key] = value;
      } else if (value !== null && value !== '' && value !== false) {
        cleanedFilters[key] = value;
      }
    });
    return cleanedFilters;
  }

  function isNewJob(createdAt) {
    const now = new Date();
    const jobDate = new Date(createdAt);
    const timeDifference = now - jobDate; // Difference in milliseconds
    const oneDayInMilliseconds = 24 * 60 * 60 * 1000;
    return timeDifference <= oneDayInMilliseconds;
  }

  async function fetchJobs() {
    try {
      const activeFilters = cleanFilters(filters);
      const response = await axios.post(
              `${apiGateway}/job-service/getJobs`,
              activeFilters,
              { params: { limit: 50 } }
      );
      if (response.status === 200) {
        allJobs = response.data.content.map(job => ({
          ...job,
          isNew: isNewJob(job.createdAt),
          logoUrl: companies.find(company => company.id === job.companyId)?.logoUrl
        }));
        filteredJobs = allJobs;
        totalPages = Math.ceil(filteredJobs.length / jobsPerPage);
        console.log(filteredJobs)
      } else {
        console.error('Error fetching jobs:', response.status, response.statusText);
      }
    } catch (error) {
      console.error('Network or server error:', error);
    }
  }

/**
 * Converts a snake_case string to camelCase.
 * @param {string} str - The snake_case string.
 * @returns {string} - The camelCase string.
 */
 const snakeToCamel = (str) => {
  return str.replace(/_([a-z])/g, (match, p1) => p1.toUpperCase());
};

/**
 * Converts all keys of an object from snake_case to camelCase.
 * @param {Object} obj - The input object with snake_case keys.
 * @returns {Object} - The new object with camelCase keys.
 */
const convertKeysToCamel = (obj) => {
  return Object.entries(obj).reduce((acc, [key, value]) => {
    const camelKey = snakeToCamel(key);
    acc[camelKey] = value;
    return acc;
  }, {});
};


const convertKeysToCamelRecursive = (data) => {
  if (Array.isArray(data)) {
    return data.map(item => convertKeysToCamelRecursive(item));
  } else if (data !== null && typeof data === 'object') {
    return Object.entries(data).reduce((acc, [key, value]) => {
      const camelKey = snakeToCamel(key);
      acc[camelKey] = convertKeysToCamelRecursive(value);
      return acc;
    }, {});
  }
  return data;
};



  async function fetchRecommendations() {
    if (true)
    {
      try {
        const response = await axios.get(
                `${apiGateway}/analytics/recommendations/${$user.userId}`
        );
        if (response.status === 200) {

          const camelCasedData = convertKeysToCamelRecursive(response.data);

          allJobs = camelCasedData.map(job => ({
            ...job,
            isNew: isNewJob(job.createdAt),
            logoUrl: companies.find(company => company.id === job.companyId)?.logoUrl
          }));
          filteredJobs = allJobs;
          totalPages = Math.ceil(filteredJobs.length / jobsPerPage);
          console.log("FILTERED:",filteredJobs);
        } else {
          console.error('Error fetching jobs:', response.status, response.statusText);
        }
      } catch (error) {
        console.error('Network or server error:', error);
      }
    }
  }

  async function fetchCompanies() {
    try {
      const response = await axios.get(`${apiGateway}/user-service/getCompanies`);
      if (response.status === 200) {
        companies = response.data.map((company) => ({
          id: company.companyId,
          name: company.name,
          logoUrl: company.logoUrl
        }));
        companiesLoaded = true;
      } else {
        console.error('Error fetching companies:', response.status, response.statusText);
      }
    } catch (error) {
      console.error('Network or server error:', error);
    }
  }

  async function applyFilters() {
    console.log('test2')
    await fetchJobs();
  }

  function changePage(pageNumber) {
    if (pageNumber >= 1 && pageNumber <= totalPages) {
      currentPage = pageNumber;
    }
  }

  function toggleSkill(skill) {
    if (filters.requiredSkills.includes(skill)) {
      filters.requiredSkills = filters.requiredSkills.filter((s) => s !== skill);
    } else {
      filters.requiredSkills = [...filters.requiredSkills, skill];
    }

    applyFilters();
  }

  $: paginatedJobs = filteredJobs.slice(
          (currentPage - 1) * jobsPerPage,
          currentPage * jobsPerPage
  );
 
</script>

<AppBar />

<main>
  <div class="content">
    {#if loading}
      <p>Loading...</p>
    {:else}
      <div class="job-list-section">
        <!-- Search Bar -->
        <div class="search-bar">
          <input
                  type="text"
                  placeholder="Search for jobs..."
                  bind:value={searchQuery}
                  on:input={() => {
              filteredJobs = allJobs.filter((job) =>
                job.jobTitle.toLowerCase().includes(searchQuery.toLowerCase())
              );
            }}
          />
        </div>

        <!-- Skills Bar -->
        <div class="skills-bar">
          {#each skillsList as skill}
            <div
                    class="skill-chip {filters.requiredSkills.includes(skill) ? 'selected' : ''}"
                    on:click={() => toggleSkill(skill)}
            >
              {skill}
            </div>
          {/each}
        </div>

        <!-- Job List Container -->
        <div class="job-list-container">
          {#if paginatedJobs.length > 0}
            <div class="job-list">
              {#each paginatedJobs as job}
                <JobCard
                        {job}
                        isLiked={followedJobIds.has(job.jobId)}
                        logoUrl={job.logoUrl}
                        useToast={false}
                />
              {/each}
            </div>
          {:else}
            <p>No jobs found for your search criteria.</p>
          {/if}

          <!-- Pagination -->
          {#if totalPages > 1}
            <div class="pagination">
              <button
                      on:click={() => changePage(currentPage - 1)}
                      disabled={currentPage === 1}
              >
                Previous
              </button>
              <span>Page {currentPage} of {totalPages}</span>
              <button
                      on:click={() => changePage(currentPage + 1)}
                      disabled={currentPage === totalPages}
              >
                Next
              </button>
            </div>
          {/if}
        </div>
      </div>

      <!-- Filters -->
      {#if companiesLoaded}
        <Filters
                {companies}
                {filters}
                {skillsList}
                on:applyFilters={applyFilters}
        />
      {:else}
        <p>Loading filters...</p>
      {/if}
    {/if}
  </div>
  <ChatBox />
</main>


<style>
  main {
    padding-top: 60px;
    height: calc(100vh);
    overflow-y: auto;
    background-color: #f8f9fa;
  }

  .content {
    display: flex;
    flex: 1;
    gap: 2rem;
    padding: 2rem;
  }

  .job-list-section {
    overflow-x: hidden;
    flex: 3;
    display: flex;
    flex-direction: column;
  }

  .search-bar input {
    width: 100%;
    padding: 0.75rem 1rem;
    font-size: 1rem;
    border: 1px solid #ddd;
    border-radius: 0.375rem;
    background-color: #ffffff;
    color: #333;
  }

  .search-bar input::placeholder {
    color: #aaa;
  }

  .skills-bar {
    display: flex;
    gap: 0.5rem;
    margin-top: 1rem;
    overflow-x: auto; /* Enable horizontal scrolling only for the skills bar */
    white-space: nowrap; /* Prevent skills from wrapping to a new line */
    padding-bottom: 0.5rem; /* Optional: Add space below */
    -ms-overflow-style: none; /* Hide scrollbar for Internet Explorer and Edge */
    scrollbar-width: none; /* Hide scrollbar for Firefox */
  }

  .skills-bar::-webkit-scrollbar {
    display: none; /* Hide scrollbar for Chrome, Safari, and Edge */
  }

  .skill-chip {
    flex: 0 0 auto; /* Prevent chips from shrinking or wrapping */
    padding: 0.5rem 1rem;
    border: 1px solid #848d91;
    border-radius: 16px;
    cursor: pointer;
    font-size: 0.9rem;
    color: #848d91;
    background-color: #ffffff;
    transition: background-color 0.2s, color 0.2s;
  }

  .skill-chip:hover {
    background-color: #848d91;
    color: #ffffff;
  }

  .skill-chip.selected {
    background-color: #758c96;
    color: #ffffff;
  }

  .job-list-container {
    flex: 1;
    overflow-y: auto;
    background-color: #ffffff;
    padding: 1rem;
    border-radius: 0.375rem;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  }

  .job-list {
    display: flex;
    flex-direction: column;
    gap: 0;
    margin: 0;
    padding: 0;
  }

  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 1rem;
    margin: 1.5rem 0 0;
  }

  .pagination button {
    padding: 0.5rem 1rem;
    font-size: 0.9rem;
    color: #007bff;
    background-color: transparent;
    border: 1px solid #007bff;
    border-radius: 0.375rem;
    cursor: pointer;
  }

  .pagination button:disabled {
    color: #ccc;
    border-color: #ccc;
    cursor: not-allowed;
  }
</style>