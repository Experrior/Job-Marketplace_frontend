<script>
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation';
    import { writable } from 'svelte/store';
  
    // Mocked Job Data
    const job = {
      id: '1',
      slug: 'frontend-developer',
      title: 'Frontend Developer',
      company: 'Tech Solutions',
      companyLogo: '/logos/logo1.png',
      location: 'New York, NY',
      category: 'Engineering',
      tags: ['HTML', 'CSS', 'JavaScript', 'Svelte'],
      description:
        'Seeking a skilled Frontend Developer with experience in modern web technologies. Must be proficient in Svelte and have a strong eye for design.',
      requiredExperience: 'Minimum 3 years of experience in frontend development.',
      requiredSkills: {
        HTML: 5,
        CSS: 5,
        JavaScript: 4,
        Svelte: 4,
        'Responsive Design': 3
      }
    };
  
    // Mocked Applicants Data
    let applicants = [
      { applicantName: 'Alice Johnson', score: 85, time: '2024-04-25T10:30:00Z' },
      { applicantName: 'Bob Smith', score: 90, time: '2024-04-24T09:15:00Z' },
      { applicantName: 'Charlie Davis', score: 75, time: '2024-04-26T14:45:00Z' },
      { applicantName: 'Diana Prince', score: 95, time: '2024-04-23T08:00:00Z' },
      { applicantName: 'Ethan Hunt', score: 80, time: '2024-04-27T16:20:00Z' }
      // Add more applicants as needed
    ];
  
    // Stores for sorting
    const sortBy = writable('score'); // Default sort by score
    const sortedApplicants = writable([]);
  
    // Helper function to calculate duration since application
    function getDuration(time) {
      const now = new Date();
      const applicationTime = new Date(time);
      let diffInSeconds = Math.floor((now - applicationTime) / 1000);
  
      // Ensure the difference is not negative
      if (diffInSeconds < 0) diffInSeconds = 0;
  
      const hours = Math.floor(diffInSeconds / 3600);
      diffInSeconds -= hours * 3600;
      const minutes = Math.floor(diffInSeconds / 60);
      const seconds = diffInSeconds - minutes * 60;
  
      // Pad with zeros if necessary
      const formattedHours = hours.toString().padStart(2, '0');
      const formattedMinutes = minutes.toString().padStart(2, '0');
      const formattedSeconds = seconds.toString().padStart(2, '0');
  
      return `${formattedHours}:${formattedMinutes}:${formattedSeconds}`;
    }
  
    // Function to sort applicants
    function sortApplicants() {
      let sorted = [...applicants];
      const currentSort = $sortBy;
  
      if (currentSort === 'score') {
        sorted.sort((a, b) => b.score - a.score);
      } else if (currentSort === 'time') {
        sorted.sort((a, b) => new Date(b.time) - new Date(a.time));
      }
  
      sortedApplicants.set(sorted);
    }
  
    // Subscribe to sortBy changes
    sortBy.subscribe(() => {
      sortApplicants();
    });
  
    // Initial sort
    onMount(() => {
      sortApplicants();
    });
  
    // Handler for changing sort criteria
    function handleSortChange(criteria) {
      sortBy.set(criteria);
    }
  </script>
  
  <!-- App Bar -->
  <div class="app-bar">
    <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
    <button
      class="user-icon"
      on:click={() => goto('/settings')}
      aria-label="Go to settings"
    >
      <!-- User icon as SVG -->
      <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
        <circle cx="12" cy="8" r="4" />
        <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
      </svg>
    </button>
  </div>
  
  <!-- Main Content -->
  <div class="scrollable-page">
    <img src="/images/job_background.webp" alt="Job Background" class="full-width-image" />
  
    {#if job}
      <!-- Job Description Section -->
      <div class="job-description">
        <img src="{job.companyLogo}" alt="{job.company} Logo" class="company-logo" />
  
        <!-- Job Title and Company -->
        <h1>{job.title}</h1>
        <p><strong>{job.company}</strong> - {job.location}</p>
  
        <!-- Tags -->
        {#if job.tags && job.tags.length > 0}
          <div class="tags">
            {#each job.tags as tag}
              <div class="tag">{tag}</div>
            {/each}
          </div>
        {/if}
  
        <!-- Job Description -->
        <h2>Job Description</h2>
        <p>{job.description}</p>
  
        <!-- Required Experience -->
        <h2>Required Experience</h2>
        <p>{job.requiredExperience}</p>
  
        <!-- Required Skills -->
        <h2>Required Skills</h2>
        <ul class="required-skills">
          {#each Object.entries(job.requiredSkills) as [skill, level]}
            <li>
              <span class="skill-name">{skill}</span>
              <span class="skill-level">
                {#each Array(level) as _, index}
                  <span class="star">&#9733;</span>
                {/each}
                {#each Array(5 - level) as _, index}
                  <span class="star empty">&#9734;</span>
                {/each}
              </span>
            </li>
          {/each}
        </ul>
      </div>
  
      <!-- Applicants Overview Section -->
      <div class="applicants-overview">
        <h2>Applicants Overview</h2>
        <p>Total Applicants: {applicants.length}</p>
  
        <!-- Sorting Options -->
        <div class="sorting-options">
          <span>Sort by:</span>
          <button
            class="{ $sortBy === 'score' ? 'active' : '' }"
            on:click={() => handleSortChange('score')}
            aria-label="Sort applicants by score"
          >
            Score
          </button>
          <button
            class="{ $sortBy === 'time' ? 'active' : '' }"
            on:click={() => handleSortChange('time')}
            aria-label="Sort applicants by time"
          >
            Time
          </button>
        </div>
  
        <!-- Applicants Table -->
        <table class="applicants-table">
          <thead>
            <tr>
              <th>Applicant Name</th>
              <th>Score</th>
              <th>Application Duration (HH:MM:SS)</th>
            </tr>
          </thead>
          <tbody>
            {#each $sortedApplicants as applicant}
              <tr>
                <td>{applicant.applicantName}</td>
                <td>{applicant.score}</td>
                <td>{getDuration(applicant.time)}</td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    {:else}
      <p class="error-message">Job not found.</p>
    {/if}
  </div>
  
  <style>
    /* App Bar Styles */
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
  
    /* Scrollable Page Styles */
    .scrollable-page {
      padding-top: 60px; /* To prevent content being hidden behind the fixed app bar */
      padding-bottom: 2rem;
    }
  
    /* Job Description Styles */
    .job-description {
      max-width: 800px;
      margin: 2rem auto 2rem;
      padding: 1.5rem;
      background-color: #f0f0f0;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
  
    /* Image Styles */
    .full-width-image {
      width: 100%;
      max-height: 350px;
      object-fit: cover;
      display: block;
      margin-bottom: 2rem;
    }
  
    .company-logo {
      width: 100px;
      height: 100px;
      object-fit: contain;
      margin-bottom: 1rem;
    }
  
    .job-description h1 {
      margin-top: 0;
    }
  
    .job-description p {
      margin: 0.5rem 0;
    }
  
    .tags {
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
      margin-bottom: 1rem;
    }
  
    .tag {
      background-color: #e0e0e0;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      font-size: 0.9rem;
    }
  
    /* Required Skills Styles */
    .required-skills {
      list-style: none;
      padding: 0;
      margin: 1rem 0;
    }
  
    .required-skills li {
      display: flex;
      margin-bottom: 0.5rem;
    }
  
    .skill-name {
      flex: 2;
    }
  
    .skill-level {
      display: flex;
      width: 100px;
      flex: 0.5;
    }
  
    .star {
      color: #f1c40f;
      margin-right: 5px;
      font-size: 20px;
    }
  
    .star.empty {
      color: #ccc;
      font-size: 20px;
    }
  
    /* Applicants Overview Styles */
    .applicants-overview {
      max-width: 1000px;
      margin: 0 auto;
      padding: 1.5rem;
      background-color: #ffffff;
      border-radius: 8px;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
  
    .applicants-overview h2 {
      margin-top: 0;
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
  
    .error-message {
      color: red;
      text-align: center;
      margin-top: 2rem;
      font-size: 1.2rem;
    }
  
    /* Responsive Adjustments */
    @media (max-width: 768px) {
      .job-description,
      .applicants-overview {
        margin: 1rem;
        padding: 1rem;
      }
  
      .applicants-table th,
      .applicants-table td {
        padding: 0.5rem;
      }
  
      .sorting-options {
        flex-direction: column;
        align-items: flex-start;
      }
  
      .sorting-options button {
        width: 100%;
      }
    }
  </style>
  