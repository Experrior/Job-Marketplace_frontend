<script>
  import { goto } from "$app/navigation";
  import AppBar from "../../lib/AppBar.svelte";
  import { user } from "$lib/stores/user";
  import { onMount } from 'svelte';
  import axios from "axios";

  let userRole;
  $: userRole = $user.role;
  var quizzes = [];
  var jobs = 

onMount(async () => {
  // get quizzes
      try {
          const response = await axios.post('http://localhost:8080/job-service/graphql', {
      query: `query{
    quizzesByRecruiter{
        quizId,
        quizName,
        createdAt,
        isDeleted
    }
}`
 }, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${$user.jwt}`
        }
      })
      console.log(response.data.data.quizzesByRecruiter)
      quizzes = response.data.data.quizzesByRecruiter
      console.log(quizzes)
    }catch (error) {
      alert(error)
    }
    //getJobs
    try {
          const response = await axios.post('http://localhost:8080/job-service/graphql', {
      query: `query {
  jobsByRecruiter {
    jobId
    title
    description
    location
    salary
    createdAt
    quizId
  }
}`
 }, {
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${$user.jwt}`
        }
      })
      console.log(response.data.data.jobsByRecruiter)
      console.log('g12')
      jobs = response.data.data.jobsByRecruiter
      console.log(quizzes)
    }catch (error) {
      alert(error)
    }

})

  const recruiter = {
      id: "recruiter1",
      name: "Jane Doe",
      company: "Tech Solutions",
      logo: "/logos/logo1.png",
  };

  function createListOfCopies(originalObject, numberOfCopies) {
      const listOfCopies = [];

      for (let i = 0; i < numberOfCopies; i++) {
          const jobCopy = { ...originalObject, id: `${originalObject.id}-${i}` };
          listOfCopies.push(jobCopy);
      }

      return listOfCopies;
  }

  const originalObject = {
      id: "2",
      title: "Backend Engineer",
      company: recruiter.company,
      companyLogo: recruiter.logo,
      location: "Remote",
      occupation: "San Diego, USA",
      description:
          "Looking for a Backend Engineer proficient in Node.js and cloud services. Must have experience with database design and API development.",
      requiredExperience: "At least 4 years of backend development experience.",
      requiredSkills: {
          "Node.js": 5,
          "Express": 4,
          "MongoDB": 4,
          "AWS": 3,
          "API Development": 5,
      },
  };

  // const jobs = createListOfCopies(originalObject, 20);

  function showApplicants(slug) {
      goto(`/recruiter/jobs/${slug}`);
  }

  function editJobOffer(slug) {
      goto(`/recruiter/jobs/${slug}/edit`);
  }

  function navigateToQuiz(slug) {
      goto(`/recruiter/quizzes/${slug}`);
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
      <h2>Job offers</h2>
      {#each jobs as job}
        <div class="job-card">
          <div class="job-info">
            <img
              src={job.companyLogo}
              alt="{job.company} Logo"
              class="company-logo"
            />
            <div>
              <h2>{job.title}</h2>
              <p>{job.company} - {job.location}</p>
            </div>
          </div>
          <div class="job-actions">
            <button
              class="show-button"
              on:click={() => showApplicants(job.jobId)}
              aria-label={`Show applicants for ${job.title}`}
            >
              Show Applicants
            </button>
            <button
              class="edit-button"
              on:click={() => editJobOffer(job.jobId)}
              aria-label={`Edit ${job.title}`}
            >
              Edit Job Offer
            </button>
          </div>
        </div>
      {/each}
    </div>

    <!-- Quiz List -->
    <div class="quiz-list-container">
      <h2>Quizzes</h2>
      {#each quizzes as quiz}
        <button class="quiz-card" on:click={() => navigateToQuiz(quiz.quizId)}>
          {#if !quiz.isDeleted}
          <div class="quiz-info">
            <h3>{quiz.quizName.split('.json')[0]}</h3>
            <p>Created: {quiz.createdAt.split('.')[0]}</p>
          </div>
          {/if}
        </button>
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
      padding: 0.75rem 1.5rem;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
  }

  .create-button:hover {
      background-color: #218838;
  }

  .scrollable-page {
      max-height: calc(100vh - 60px - 72px);
      overflow: hidden; /* Prevent outer scrolling */
  }

  main {
      padding: 1rem;
      height: 100%;
  }

  .lists-container {
      display: flex;
      gap: 1rem;
      height: calc(100vh - 132px); /* Adjust based on header and buttons height */
  }

  .job-list-container, .quiz-list-container {
      flex: 1;
      overflow-y: auto;
      margin-top: 60px;
      padding: 1rem;
      padding-right: 0.5rem;
  }

  .quiz-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    /* border: 1px solid #ddd; */
    padding: 1rem;
    border-radius: 8px;
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    margin-bottom: 1rem;
    width: 100%; /* Ensure full width */
    cursor: pointer;
    border: none; /* Remove default button border */
    background: none; /* Remove default button background */
    text-align: left; /* Align text to the left */
    transition: background-color 0.3s ease; /* Smooth hover transition */
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
    font-size: 1.2rem;
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

  .company-logo {
      width: 80px;
      height: 80px;
      object-fit: contain;
      border-radius: 8px;
  }

  .job-actions {
      display: flex;
      gap: 0.5rem;
  }

  .show-button {
      padding: 0.5rem 1rem;
      background-color: #007bff;
      border: none;
      color: white;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s;
  }

  .show-button:hover {
      background-color: #0056b3;
  }

  .edit-button {
      padding: 0.5rem 1rem;
      background-color: #ffc107;
      border: none;
      color: #212529;
      border-radius: 4px;
      cursor: pointer;
      transition: background-color 0.3s;
  }

  .edit-button:hover {
      background-color: #e0a800;
  }

  .quiz-list-container h2 {
      margin-bottom: 1rem;
      text-align: left;
  }

  @media (max-width: 768px) {
      .lists-container {
          flex-direction: column;
      }

      .job-card, .quiz-card {
          flex-direction: column;
          align-items: flex-start;
      }

      .job-actions, .quiz-actions {
          margin-top: 1rem;
      }
  }


  button {
      width: 100%;
      padding: 0.75rem;
      margin-top: 1rem;
      border: none;
      border-radius: 4px;
      background-color: #007bff;
      color: white;
      cursor: pointer;
  }
</style>