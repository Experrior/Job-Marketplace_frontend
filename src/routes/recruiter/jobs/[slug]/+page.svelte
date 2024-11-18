<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { writable } from 'svelte/store';
  import JobDescription from '$lib/JobDescription.svelte';


  const job = {
    id: '1',
    slug: 'frontend-developer',
    title: 'Frontend Developer',
    company: 'Tech Solutions',
    companyLogo: '/logos/logo1.png',
    location: 'New York, NY',
    category: 'Engineering',
    description:
      'Seeking a skilled Frontend Developer with experience in modern web technologies. Must be proficient in Svelte and have a strong eye for design.',
    requiredExperience: 'Minimum 3 years of experience in frontend development.',
    requiredSkills: {
      HTML: 5,
      CSS: 5,
      JavaScript: 4,
      Svelte: 4,
      'Responsive Design': 3
    },
    employment_type: 'Full-time',
    work_location: 'Remote',
    salary: '80000'
  };

  function getRandomTime() {
  return Math.floor(Math.random() * (680 - 40 + 1)) + 40;
}
const sortBy = writable('score');
  const sortedApplicants = writable([]);
  let applicantsToShow = 5;

  let applicants = [];

  onMount(() => {
    applicants = [
      {
        applicantName: 'Alice Johnson',
        score: 85,
        time: getRandomTime(),
        photo: '/images/profile4.png',
        cv: '/cvs/alice.pdf'
      },
      {
        applicantName: 'Bob Smith',
        score: 90,
        time: getRandomTime(),
        photo: '/images/profile2.png',
        cv: '/cvs/bob.pdf'
      },
      {
        applicantName: 'Charlie Davis',
        score: 75,
        time: getRandomTime(),
        photo: '/images/profile1.png',
        cv: '/cvs/charlie.pdf'
      },
      {
        applicantName: 'Diana Prince',
        score: 95,
        time: getRandomTime(),
        photo: '/images/profile4.png',
        cv: '/cvs/diana.pdf'
      },
      {
        applicantName: 'Ethan Hunt',
        score: 89,
        time: getRandomTime(),
        photo: '/images/profile3.png',
        cv: '/cvs/ethan.pdf'
      }

    ];

    sortApplicants();
  });

  function getDuration(totalSeconds) {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  }

  function sortApplicants() {
    let sorted = [...applicants];
    const currentSort = $sortBy;

    if (currentSort === 'score') {
      sorted.sort((a, b) => b.score - a.score);
    } else if (currentSort === 'time') {
      sorted.sort((a, b) => a.time - b.time);
    }

    sortedApplicants.set(sorted);
  }

  sortBy.subscribe(() => {
    sortApplicants();
  });


  function handleSortChange(criteria) {
    sortBy.set(criteria);
  }
</script>

<div class="app-bar">
  <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
  <button
    class="user-icon"
    on:click={() => goto('/settings')}
    aria-label="Go to settings">
    <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
      <circle cx="12" cy="8" r="4" />
      <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
    </svg>
  </button>
</div>


<div class="scrollable-page">
  <img src="/images/job_background.webp" alt="Job Background" class="full-width-image" />

  {#if job}
    <div class="main-content">

      <div class="job-description-container">
        <JobDescription
          title={job.title}
          company={job.company}
          companyLogo={job.companyLogo}
          location={job.location}
          employment_type={job.employment_type}
          work_location={job.work_location}
          salary={job.salary}
          description={job.description}
          requiredExperience={job.requiredExperience}
          requiredSkills={job.requiredSkills}
        />
      </div>

      <div class="applicants-overview">
        <h2>Applicants Overview</h2>
        <p>Total Applicants: {applicants.length}</p>

        <div class="applicants-number">
          <label for="applicantsToShow">Number of applicants to display:</label>
          <input
            type="number"
            id="applicantsToShow"
            min="1"
            max={applicants.length}
            bind:value={applicantsToShow}
          />
        </div>

        <div class="sorting-options">
          <span>Sort by:</span>
          <button
            class="{ $sortBy === 'time' ? 'active' : '' }"
            on:click={() => handleSortChange('time')}
            aria-label="Sort applicants by time"
          >
            Score
          </button>
          <button
            class="{ $sortBy === 'score' ? 'active' : '' }"
            on:click={() => handleSortChange('score')}
            aria-label="Sort applicants by score"
          >
            Time
          </button>
        </div>

        <table class="applicants-table">
          <thead>
            <tr>
              <th>Photo</th>
              <th>Applicant Name</th>
              <th>Score</th>
              <th>Time (MM:SS)</th>
              <th>CV</th>
            </tr>
          </thead>
          <tbody>
            {#each $sortedApplicants.slice(0, applicantsToShow) as applicant}
            <tr>
              <td>
                <img src="{applicant.photo}" alt="{applicant.applicantName} Photo" class="applicant-photo" />
              </td>
              <td>{applicant.applicantName}</td>
              <td>{applicant.score}</td>
              <td>{getDuration(applicant.time)}</td>
              <td>
                <a href="{applicant.cv}" download class="cv-download-button">Download</a>
              </td>
            </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  {:else}
    <p class="error-message">Job not found.</p>
  {/if}
</div>

<style>


.applicants-table th,
  .applicants-table td {
    border: 1px solid #ddd;
    padding: 0.75rem;
    text-align: left;
    vertical-align: middle;
  }

  .applicant-photo {
    width: 50px;
    height: 50px;
    object-fit: cover;
    border-radius: 50%;
  }

  .cv-download-button {
    padding: 0.5rem 1rem;
    background-color: #007bff;
    color: white;
    border-radius: 4px;
    text-decoration: none;
    font-size: 0.9rem;
  }

  .cv-download-button:hover {
    background-color: #0056b3;
  }

  .applicants-table th:first-child,
  .applicants-table td:first-child {
    width: 60px;
  }

  .applicants-table th:last-child,
  .applicants-table td:last-child {
    width: 120px;
  }

  .app-bar {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    display: flex;
    align-items: center;
    justify-content: space-between;
    background-color: #007bff;
    padding: 0.5rem 1rem;
    color: white;
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

  .full-width-image {
    width: 100%;
    max-height: 250px;
    object-fit: cover;
    display: block;
    position: relative;
    z-index: 0;
  }


  .main-content {
    display: flex;
    max-width: 1200px;
    margin: -80px auto 2rem;
    padding: 1rem;
    position: relative;
    z-index: 1;
  }

  .job-description-container {
    flex: 1;
    margin-right: 1rem;
    background-color: #f8f9fa;
    padding: 1.5rem;
    border-radius: 8px;
    border: 1px solid #ced4da;
    overflow-y: auto;
    max-height: 1200px;
  }


  .applicants-overview {
    flex: 1;
    background-color: #ffffff;
    padding: 1.5rem;
    border-radius: 8px;
    border: 1px solid #ced4da;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  .applicants-overview h2 {
    margin-top: 0;
  }

  .applicants-number {
    margin: 1rem 0;
  }

  .applicants-number label {
    margin-right: 0.5rem;
    font-weight: bold;
  }

  .applicants-number input {
    width: 60px;
    padding: 0.25rem;
    border: 1px solid #ced4da;
    border-radius: 4px;
  }

  .sorting-options {
    display: flex;
    align-items: center;
    margin: 1rem 0;
    gap: 0.5rem;
  }

  .sorting-options button {
    padding: 0.5rem 1rem;
    border: 1px solid #007bff;
    background-color: white;
    color: #007bff;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  .sorting-options button.active,
  .sorting-options button:hover {
    background-color: #007bff;
    color: white;
  }

  .applicants-table {
    width: 100%;
    border-collapse: collapse;
  }

  .applicants-table th,
  .applicants-table td {
    border: 1px solid #ddd;
    padding: 0.75rem;
    text-align: left;
  }

  .applicants-table th {
    background-color: #f8f8f8;
    cursor: pointer;
  }

  .applicants-table tr:nth-child(even) {
    background-color: #f9f9f9;
  }

  .applicants-table tr:hover {
    background-color: #f1f1f1;
  }

  @media (max-width: 768px) {
    .main-content {
      flex-direction: column;
    }

    .job-description-container {
      margin-right: 0;
      margin-bottom: 1rem;
      max-height: 1600px;
    }
  } 
</style>
