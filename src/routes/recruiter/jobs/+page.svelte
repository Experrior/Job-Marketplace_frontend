<script>
  import { goto } from "$app/navigation";
  import { auth } from "../../../stores/auth";

  let userRole;

  $: userRole = $auth.role;
  console.log(userRole);
  auth.setRole("recruiter");
  console.log(userRole);

  const recruiter = {
    id: "recruiter1",
    name: "Jane Doe",
    company: "Tech Solutions",
    logo: "/logos/logo1.png",
  };
  function createListOfCopies(originalObject, numberOfCopies) {
    const listOfCopies = [];

    for (let i = 0; i < numberOfCopies; i++) {
      listOfCopies.push(JSON.parse(JSON.stringify(originalObject)));
    }

    return listOfCopies;
  }
  const originalObject = {
    id: "2",
    slug: "backend-engineer",
    title: "Backend Engineer",
    company: recruiter.company,
    companyLogo: recruiter.logo,
    location: "Remote",
    category: "Engineering",
    tags: ["Node.js", "Express", "MongoDB", "AWS"],
    description:
      "Looking for a Backend Engineer proficient in Node.js and cloud services. Must have experience with database design and API development.",
    requiredExperience: "At least 4 years of backend development experience.",
    requiredSkills: {
      "Node.js": 5,
      Express: 4,
      MongoDB: 4,
      AWS: 3,
      "API Development": 5,
    },
  };
  const jobs = createListOfCopies(originalObject, 20);

  function showApplicants(slug) {
    goto(`/recruiter/jobs/${slug}`);
  }
</script>

<div class="app-bar">
  <div class="nav-links">
    <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
    {#if userRole === "recruiter"}
      <a href="/recruiter/jobs" class="app-name" aria-label="Create job"
        >My jobs</a
      >
    {/if}
    <text>{userRole}</text>
  </div>
<div class="scrollable-page">
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
</div>

<div class="scrollable-page">
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
      <button
        class="show-button"
        on:click={() => showApplicants(job.slug)}
        aria-label={`Show applicants for ${job.title}`}
      >
        Show applicants
      </button>
      <button
      class="edit-button"
      on:click={() => showApplicants(job.slug)}
    >
     Edit job offer
    </button>
    </div>
  {/each}
</div>

<style>
  /* Existing styles */

  .job-card {
    display: flex;
    align-items: center;
    justify-content: space-between;
    border: 1px solid #ddd;
    padding: 1rem;
    margin-bottom: 1rem;
    border-radius: 8px;
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
  }
  .edit-button {
  padding: 0.5rem 1rem;
  background-color: #28a745; /* Green */
  border: none;
  color: white;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
  margin-left: 1rem;
}

.edit-button:hover {
  background-color: #218838;
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
</style>
