<script>
import { goto } from '$app/navigation';
  export let job;

  function navigateToJob() {
    goto(`/job/${job.slug || job.id}`);
  }
  </script>
  
  <style>

  
    .job-location {
      position: absolute;
      top: 1rem;
      left: 1rem;
      font-size: 0.9rem;
      color: #666;
    }
  
    .tags {
      margin-top: 0.5rem;
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
    }
  
    .tag {
      background-color: #e0e0e0;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      font-size: 0.8rem;
    }
  
    button {
      padding: 0.5rem 1rem;
      margin-left: auto;
      border: none;
      border-radius: 4px;
      background-color: #007bff;
      color: white;
      cursor: pointer;
    }
  
    button:hover {
      background-color: #0056b3;
    }
  </style>
  
  <div class="job-card">
    <!-- Location -->
    <span class="job-location">{job.location}</span>
  
    <!-- Company Logo -->
    {#if job.companyLogo}
      <img src="{job.companyLogo}" alt="{job.company} Logo" class="company-logo" />
    {:else}
      <!-- Placeholder if no logo -->
      <div
        class="company-logo"
        style="background-color: #f0f0f0; display: flex; align-items: center; justify-content: center;"
      >
        <span>{job.company.charAt(0)}</span>
      </div>
    {/if}
  
    <!-- Job Information -->
    <div class="job-info">
      <div class="job-header">
        <h2 class="job-title">{job.title}</h2>
      </div>
      <p><strong>{job.company}</strong></p>
      <p><strong>Category:</strong> {job.category}</p>
  
      <!-- Tags -->
      {#if job.tags && job.tags.length > 0}
        <div class="tags">
          {#each job.tags as tag}
            <div class="tag">{tag}</div>
          {/each}
        </div>
      {/if}
    </div>
  
    <!-- Apply Button -->
    <button on:click={navigateToJob}>Apply Now</button>
  </div>
  