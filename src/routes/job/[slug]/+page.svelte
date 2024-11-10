<script>
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { goto } from '$app/navigation';

  let slug = $page.params.slug;

  // Rest of your code
  const job = {
      id: '1',
      slug: 'senior-software-engineer',
      title: 'Senior Software Engineer',
      company: 'Tech Corp',
      companyLogo: '/logos/logo2.png',
      location: 'San Francisco, CA',
      category: 'Engineering',
      tags: ['Python', 'JavaScript', 'Docker'],
      description: 'Detailed job description goes here.',
    };

</script>

<div class="app-bar">
  <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
  <button class="user-icon" on:click={() => goto('/settings')} aria-label="Go to settings">
    <!-- User icon as SVG -->
    <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
      <circle cx="12" cy="8" r="4" />
      <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
    </svg>
  </button>
</div>

<div class="image-container">
  <!-- Background Image -->
  <img src="/images/job_background.webp" alt="Job Background" class="full-width-image" />

  <!-- Overlay Text -->
  <div class="overlay-text">
    <h1>Find Your Dream Job</h1>
  </div>

  <!-- Job Description Overlay -->
  {#if job}
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

      <!-- Apply Button -->
      <button class="apply-button" on:click={() => alert('Application process initiated')}>
        Apply Now
      </button>
    </div>
  {:else}
    <p class="error-message">Job not found.</p>
  {/if}
</div>

<style>

  /* App Bar Styles */
.app-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #007bff;
  padding: 0.5rem 1rem;
  color: white;
  width: 100%;
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

/* Image Container Styles */
.image-container {
  position: relative;
  width: 100%;
}

.full-width-image {
  width: 100%;
  height: auto;
  display: block;
}

.overlay-text {
  position: absolute;
  top: 10%;
  left: 50%;
  transform: translate(-50%, -10%);
  color: white;
  text-align: center;
}

/* Job Description Overlay Styles */
.job-description {
  position: absolute;
  top: 50%; /* Adjust as needed */
  left: 50%;
  transform: translate(-50%, -50%);
  width: 80%; /* Adjust width as needed */
  background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent background */
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  overflow: auto;
  max-height: 70%; /* Allow scrolling if content overflows */
}

/* Job Description Content Styles */
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

.apply-button {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  background-color: #28a745;
  color: white;
  cursor: pointer;
  font-size: 1rem;
  margin-top: 1rem;
}

.apply-button:hover {
  background-color: #218838;
}

.error-message {
  color: red;
  text-align: center;
  margin-top: 2rem;
}

/* Responsive Adjustments */
@media (max-width: 768px) {
  .job-description {
    width: 90%;
    top: 55%;
  }

  .company-logo {
    width: 80px;
    height: 80px;
  }
}

</style>