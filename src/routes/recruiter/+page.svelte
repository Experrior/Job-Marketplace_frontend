<script>
  import { goto } from "$app/navigation";
  import AppBar from "../../lib/AppBar.svelte";
  import { user } from "$lib/stores/user";
  import { onMount } from "svelte";
  import axios from "axios";

  let quizzes = [];
  let jobs = [];
  let showDisabledJobs = false;
  let showDisabledQuizzes = false;

  const apiGateway = import.meta.env.VITE_GATEWAY_URL;
  console.log("USING GATEWAY:", apiGateway);

  const apiEndpoint = `${apiGateway}/job-service/graphql`;
  const headers = {
    "Content-Type": "application/json",
    Authorization: `Bearer ${$user.jwt}`,
  };

  async function fetchGraphQLData(query) {
    try {
      const response = await axios.post(apiEndpoint, { query }, { headers });
      return response.data.data;
    } catch (error) {
      alert(error);
      console.error("GraphQL Error:", error);
      return null;
    }
  }

  async function fetchQuizzes() {
    const data = await fetchGraphQLData(`
      query {
        quizzesByRecruiter {
          quizId
          quizName
          createdAt
          isDeleted
        }
      }
    `);

    if (data) {
      quizzes = data.quizzesByRecruiter || [];
      console.log("Fetched quizzes:", quizzes);
    }
  }

  async function fetchJobs() {
    const data = await fetchGraphQLData(`
      query {
        jobsByRecruiter {
          jobId
          title
          description
          location
          salary
          createdAt
          quizId
          isDeleted
        }
      }
    `);

    if (data) {
      jobs = data.jobsByRecruiter || [];
      console.log("Fetched jobs:", jobs);
    }
  }

  onMount(() => {
    fetchQuizzes();
    fetchJobs();
  });

  function navigateTo(path) {
    goto(path);
  }

  function showApplicants(slug) {
    navigateTo(`/recruiter/jobs/${slug}`);
  }

  function editJobOffer(slug) {
    navigateTo(`/recruiter/jobs/edit/${slug}`);
  }

  function navigateToQuiz(slug) {
    navigateTo(`/recruiter/quizzes/${slug}`);
  }

  function toggleShowDisabledJobs() {
    showDisabledJobs = !showDisabledJobs;
  }

  function toggleShowDisabledQuizzes() {
    showDisabledQuizzes = !showDisabledQuizzes;
  }

  async function disableJobOffer(jobId) {
    const mutation = `
    mutation {
      deleteJob(jobId: "${jobId}") {
        success,
        message
      }
    }
  `;

    try {
      const response = await axios.post(apiEndpoint, { query: mutation }, { headers });
      const result = response.data.data.deleteJob;
      if (result.success) {
        alert("Job offer disabled successfully.");
        fetchJobs(); // Refresh the job list
      } else {
        alert(`Failed to disable job offer: ${result.message}`);
      }
    } catch (error) {
      alert("An error occurred while disabling the job offer.");
      console.error("GraphQL Error:", error);
    }
  }

  async function enableJobOffer(jobId) {
    console.log("Enabling job offer:", jobId);
    const mutation = `
    mutation {
      restoreJob(jobId: "${jobId}") {
        jobId
        title
        description
        location
        salary
        createdAt
        isDeleted
      }
    }
  `;

    try {
      const response = await axios.post(apiEndpoint, { query: mutation }, { headers });
      const result = response.data.data.restoreJob;
      if (result) {
        alert("Job offer enabled successfully.");
        fetchJobs(); // Refresh the job list
      } else {
        alert("Failed to enable job offer.");
      }
    } catch (error) {
      alert("An error occurred while enabling the job offer.");
      console.error("GraphQL Error:", error);
    }
  }

  async function disableQuiz(quizId) {
    const mutation = `
    mutation {
      deleteQuiz(quizId: "${quizId}") {
        success,
        message
      }
    }
  `;

    try {
      const response = await axios.post(apiEndpoint, { query: mutation }, { headers });
      const result = response.data.data.deleteQuiz;
      if (result.success) {
        alert("Quiz disabled successfully.");
        fetchQuizzes(); // Refresh the quiz list
      } else {
        alert(`Failed to disable quiz: ${result.message}`);
      }
    } catch (error) {
      alert("An error occurred while disabling the quiz.");
      console.error("GraphQL Error:", error);
    }
  }


  async function enableQuiz(quizId) {
    const mutation = `
    mutation {
      restoreQuiz(quizId: "${quizId}") {
        quizId
        quizName
        createdAt
        isDeleted
      }
    }
  `;

    try {
      const response = await axios.post(apiEndpoint, { query: mutation }, { headers });
      const result = response.data.data.restoreQuiz;
      if (result) {
        alert("Quiz enabled successfully.");
        fetchQuizzes(); // Refresh the quiz list
      } else {
        alert("Failed to enable quiz.");
      }
    } catch (error) {
      alert("An error occurred while enabling the quiz.");
      console.error("GraphQL Error:", error);
    }
  }
</script>


<AppBar/>

<div class="main-container">

  <div class="top-buttons">
    <button on:click={() => goto('/recruiter/jobs/new')} class="create-button">Create New Job Offer</button>
    <button on:click={() => goto('/recruiter/quizzes/new')} class="create-button">Create New Quiz</button>
  </div>

  <div class="scrollable-page">
    <main class="lists-container">
      <!-- Job List -->
      <div class="job-list-container">
        <div class="list-header">
          <h2>Job Offers</h2>
          <select on:change={toggleShowDisabledJobs} class="filter-dropdown">
            <option value="active" selected={!showDisabledJobs}>Show Active Jobs</option>
            <option value="disabled" selected={showDisabledJobs}>Show Disabled Jobs</option>
          </select>
        </div>

        {#each jobs.filter(job => showDisabledJobs ? job.isDeleted : !job.isDeleted) as job}
          <div class="job-card {job.isDeleted ? 'disabled' : ''}">
            <div class="job-info">
              <div class="job-details">
                <h3>{job.title}</h3>
                <p>{job.location}</p>
                <p>Salary $: {job.salary ? job.salary : 'undisclosed'}</p>
              </div>
            </div>
            <div class="job-actions">
              <button on:click={() => showApplicants(job.jobId)}>Applicants</button>
              <button on:click={() => editJobOffer(job.jobId)}>Edit</button>
              {#if !job.isDeleted}
                <button on:click={() => disableJobOffer(job.jobId)}>Disable</button>
              {:else}
                <button on:click={() => enableJobOffer(job.jobId)}>Enable</button>
              {/if}
            </div>
          </div>
        {/each}
      </div>

      <!-- Quiz List -->
      <div class="quiz-list-container">
        <div class="list-header">
          <h2>Quizzes</h2>
          <select on:change={toggleShowDisabledQuizzes} class="filter-dropdown">
            <option value="active" selected={!showDisabledQuizzes}>Show Active Quizzes</option>
            <option value="disabled" selected={showDisabledQuizzes}>Show Disabled Quizzes</option>
          </select>
        </div>

        {#each quizzes.filter(quiz => showDisabledQuizzes ? quiz.isDeleted : !quiz.isDeleted) as quiz}
          <div class="quiz-card {quiz.isDeleted ? 'disabled' : ''}">
            <div class="quiz-info">
              <h3>{quiz.quizName.split('.json')[0]}</h3>
              <p>Created: {quiz.createdAt.split('.')[0]}</p>
            </div>
            <div class="quiz-actions">
              {#if !quiz.isDeleted}
                <button on:click={() => disableQuiz(quiz.quizId)}>Disable</button>
              {:else}
                <button on:click={() => enableQuiz(quiz.quizId)}>Enable</button>
              {/if}
            </div>
          </div>
        {/each}
      </div>
    </main>
  </div>
</div>

<style>
  .main-container {
    margin-top: 60px;
  }

  .top-buttons {
    display: flex;
    gap: 1rem;
    padding: 1rem;
    background-color: #f9f9f9;
    position: sticky;
    top: 60px;
    z-index: 999;
  }

  .create-button {
    width: 100%;
    padding: 0.75rem;
    margin-top: 0.5rem;
    border: none;
    border-radius: 4px;
    background-color: #28a745;
    color: white;
    cursor: pointer;
  }

  .create-button:hover {
    background: #218838;
  }

  .filter-dropdown {
    padding: 0.5rem;
    border: 1px solid #ccc;
    border-radius: 4px;
    background: #fff;
    font-size: 1rem;
    margin-bottom: 1rem;
  }

  .job-card, .quiz-card {
    padding: 0.5rem; /* Decreased padding */
    margin: 0;
    background: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    margin-bottom: 0.5rem; /* Decreased margin */
    display: flex;
    justify-content: space-between;
    align-items: center;
    transition: box-shadow 0.3s;
    cursor: pointer;
    font-size: 0.9rem; /* Decreased font size */
  }

  .job-card:hover, .quiz-card:hover {
    box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
  }

  .job-card.disabled, .quiz-card.disabled{
    background: #f8d7da;
    color: #721c24;
  }

  .job-card.disabled:hover, .quiz-card.disabled:hover {
    background: #f2cbcf; /* Darker red background */
    color: #721c24; /* Light pink text */
  }

  .scrollable-page {
      max-height: calc(100vh);
      overflow: hidden; /* Prevent outer scrolling */
  }

  main {
      padding: 1rem;
      height: 100%;
  }

  .lists-container {
      display: flex;
      gap: 1rem;
      height: calc(100vh); /* Adjust based on header and buttons height */
  }

  .job-list-container, .quiz-list-container {
      flex: 1;
      overflow-y: auto;
      margin-top: 60px;
      margin-bottom: 50px;
      padding: 1rem;
      padding-right: 0.5rem;
  }

  .job-card:hover, .quiz-card:hover {
      background-color: #f9f9f9; /* Light gray background on hover */
  }

  .quiz-info h3, .quiz-info p {
      margin: 0;
      padding: 0;
      color: black;
  }

  .quiz-info h3 {
      font-size: 1rem;
      margin-bottom: 0.5rem;
  }

  .quiz-info p {
      font-size: 1rem;
      color: #555;
  }

 .quiz-info {
    display: flex;
    align-items: center;
    gap: 1rem;
  }

  .job-actions, .quiz-actions {
    display: flex;
    gap: 0.5rem;
  }

  .job-actions button, .quiz-actions button {
    padding: 0.5rem 1rem;
    border: none;
    border-radius: 4px;
    font-size: 0.9rem;
    cursor: pointer;
  }

  .job-actions button:nth-child(1),
  .quiz-actions button:nth-child(3) {
    background: #007bff;
    color: white;
  }

  .job-actions button:nth-child(2),
  .quiz-actions button:nth-child(2) {
    background: #ffc107;
    color: black;
  }

  .job-actions button:nth-child(3),
  .quiz-actions button:nth-child(1) {
    background: #dc3545;
    color: white;
  }

  .quiz-actions button:nth-child(3) {
    background: #6c757d; /* Disabled Quiz button color */
    color: white;
  }

  .job-actions button:hover, .quiz-actions button:hover {
    opacity: 0.9;
  }

  .quiz-list-container h2 {
      margin-bottom: 1rem;
      text-align: left;
  }


  @media (max-width: 768px) {
    .lists-container {
      flex-direction: column;
    }
  }

</style>