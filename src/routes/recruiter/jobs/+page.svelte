<script>
  import { goto } from "$app/navigation";
  import { user } from "../../../stores/user";
  import { onMount } from 'svelte';

  let userRole;
  $: userRole = $user.role;

  // Mock recruiter data
  const recruiter = {
    id: "recruiter1",
    name: "Jane Doe",
    company: "Tech Solutions",
    logo: "/logos/logo1.png",
  };

  // Function to create a list of job offers
  function createListOfCopies(originalObject, numberOfCopies) {
    const listOfCopies = [];

    for (let i = 0; i < numberOfCopies; i++) {
      // Add unique IDs or slugs if necessary
      const jobCopy = { ...originalObject, id: `${originalObject.id}-${i}`, slug: `backend-engineer-${i}` };
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

  const jobs = createListOfCopies(originalObject, 20);

  function showApplicants(slug) {
    goto(`/recruiter/jobs/${slug}`);
  }

  function editJobOffer(slug) {
    goto(`/recruiter/jobs/${slug}/edit`);
  }
</script>

<!-- App Bar -->
<div class="app-bar">
  <div class="nav-links">
    <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
    {#if userRole === "recruiter"}
      <a href="/recruiter/jobs" class="app-name" aria-label="My Jobs">My Jobs</a>
    {/if}
  </div>
  <button
    class="user-icon"
    on:click={() => goto("/settings")}
    aria-label="Go to settings"
  >
    <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
      <circle cx="12" cy="8" r="4" />
      <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
    </svg>
  </button>
</div>

<!-- Main Content -->
<div class="main-container">
  <!-- Top Buttons -->
  {#if userRole === "recruiter"}
    <div class="top-buttons">
      <button on:click={() => goto('/recruiter/jobs/new')} class="create-button">Create New Job Offer</button>
      <button on:click={() => goto('/create-quiz')} class="create-button">Create New Quiz</button>
    </div>
  {/if}

  <!-- Scrollable Job List -->
  <div class="scrollable-page">
    <main>
      <!-- Job List -->
      <div class="job-list-container">
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
                on:click={() => showApplicants(job.slug)}
                aria-label={`Show applicants for ${job.title}`}
              >
                Show Applicants
              </button>
              <button
                class="edit-button"
                on:click={() => editJobOffer(job.slug)}
                aria-label={`Edit ${job.title}`}
              >
                Edit Job Offer
              </button>
            </div>
          </div>
        {/each}
      </div>
    </main>
  </div>
</div>

<style>
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

  .nav-links {
    display: flex;
    align-items: center;
    gap: 1rem;
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

  /* Main Container */
  .main-container {
    margin-top: 60px; /* Adjust to the height of your app bar */
  }

  /* Top Buttons Styles */
  .top-buttons {
    display: flex;
    gap: 1rem;
    padding: 1rem;
    background-color: #f9f9f9;
    position: sticky;
    top: 60px; /* Stick below the app bar */
    z-index: 999; /* Ensure it stays above scrollable content */
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

  /* Scrollable Content */
  .scrollable-page {
    max-height: calc(100vh - 60px - 72px); /* Subtract app bar and buttons height */
    overflow-y: auto;
  }

  main {
    padding: 1rem;
  }

  /* Job List Styles */
  .job-list-container {
    display: flex;
    flex-direction: column;
    gap: 1rem;
  }

  .job-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    border: 1px solid #ddd;
    padding: 1rem;
    border-radius: 8px;
    background-color: #fff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .job-info {
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

  /* Responsive Adjustments */
  @media (max-width: 768px) {
    .job-card {
      flex-direction: column;
      align-items: flex-start;
    }

    .job-actions {
      margin-top: 1rem;
    }
  }
</style>
