<script>
  import {user, verifyUser} from "$lib/stores/user.js";
  import {goto} from "$app/navigation";
  export let job;
  export let isLiked = false;
  export let onUnlike;
  export let useToast = true; // Default to true for backward compatibility
  export let logoUrl;

  const API_URL = "http://localhost:8080/job-service/graphql";

  async function callGraphQL(query, variables = {}) {
    if (!verifyUser()) {
      goto('/login');
    }
    try {
      const response = await fetch(API_URL, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${$user.jwt}`,
        },
        body: JSON.stringify({ query, variables }),
      });
      const data = await response.json();
      if (data.errors) {
        console.error("GraphQL errors:", data.errors);
        return null;
      }
      return data.data;
    } catch (error) {
      console.error("Error calling GraphQL API:", error);
      return null;
    }
  }

  function navigateToJob() {
    window.location.href = `/job/${job.jobId}?companyLogo=${encodeURIComponent(logoUrl)}`;
  }

  async function toggleLike(event) {
    event.stopPropagation(); // Prevent card click propagation

    if (!isLiked) {
      // Liking a job
      const query = `
            mutation ToggleFollowJob($jobId: ID!) {
                toggleFollowJob(jobId: $jobId) {
                    success
                    message
                    isFollowed
                }
            }`;
      const variables = { jobId: job.jobId };

      try {
        const result = await callGraphQL(query, variables);
        if (result?.toggleFollowJob?.success) {
          isLiked = result.toggleFollowJob.isFollowed;
        } else {
          console.error("Failed to like job:", result?.toggleFollowJob?.message || "Unknown error");
        }
      } catch (error) {
        console.error("Error while liking job:", error);
      }
    } else {
      // Unliking a job
      if (useToast) {
        // Use toast for unliking
        if (typeof onUnlike === 'function') {
          onUnlike(job.jobId);
        }
      } else {
        // Immediate unlike without toast
        const query = `
                mutation ToggleFollowJob($jobId: ID!) {
                    toggleFollowJob(jobId: $jobId) {
                        success
                        message
                        isFollowed
                    }
                }`;
        const variables = { jobId: job.jobId };

        try {
          const result = await callGraphQL(query, variables);
          if (result?.toggleFollowJob?.success) {
            isLiked = result.toggleFollowJob.isFollowed;
          } else {
            console.error("Failed to unlike job:", result?.toggleFollowJob?.message || "Unknown error");
          }
        } catch (error) {
          console.error("Error while unliking job:", error);
        }
      }
    }
  }




</script>

<div class="job-card" on:click={navigateToJob}>
  <div class="company-logo">
    <img src={logoUrl} alt="{job.companyName} Logo" />
  </div>

  <div class="job-info">
    <div class="job-header">
      <h3 class="job-title">{job.title}</h3>
      {#if job.isNew}
        <span class="new-label">New</span>
      {/if}
    </div>
    <p class="company-name">{job.companyName}</p>
    <div class="job-details">
      <span class="detail"><strong>Location:</strong> {job.location || 'Not specified'}</span>
      <span class="detail"><strong>Work Type:</strong> {job.workLocation || 'Not specified'}</span>
      <span class="detail"><strong>Employment Type:</strong> {job.employmentType || 'Not specified'}</span>
      <span class="salary">{job.salary ? `$${job.salary.toLocaleString()}` : 'Salary undisclosed'}</span>
    </div>
    {#if job.requiredSkills?.length > 0}
      <div class="skills">
        {#each job.requiredSkills as skill}
          <div class="skill">
            <span class="skill-name">{skill.name}</span>
            <span class="skill-level">Level {skill.level}</span>
          </div>
        {/each}
      </div>
    {/if}
  </div>
  <button class="like-button" on:click={toggleLike} aria-label="Toggle Like">
    <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            width="24"
            height="24"
            class={isLiked ? "liked" : "unliked"}
    >
      <path
              d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"
      />
    </svg>
  </button>

</div>

<style>
  .job-card {
    display: flex;
    align-items: center;
    margin: 0.5rem 0;
    padding: 1rem 1rem;
    border: 1px solid #e5e5e5;
    border-radius: 8px;
    background-color: #ffffff;
    transition: box-shadow 0.3s ease, transform 0.2s ease;
    cursor: pointer;
    gap: 1.5rem;
    min-height: 120px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
    position: relative;
  }

  .job-card:hover {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
    transform: translateY(-2px);
  }

  .company-logo {
    width: 60px; /* Adjust the width as needed */
    height: 60px; /* Adjust the height to match the width */
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%; /* Circular logo */
    overflow: hidden;
    /*background-color: #f5f5f5; !* Light grey background for fallback *!*/
    /*box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); !* Optional shadow for a modern look *!*/
  }

  .company-logo img {
    max-width: 100%;
    max-height: 100%;
    object-fit: cover; /* Ensures the image is properly cropped */
    object-position: center; /* Centers the image within the container */
  }


  .job-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .job-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .job-title {
    font-size: 1.2rem;
    font-weight: 600;
    margin: 0;
    color: #333333;
  }

  .company-name {
    font-size: 0.9rem;
    color: #555555;
    margin: 0.25rem 0 0;
  }

  .job-details {
    display: flex;
    flex-wrap: wrap;
    gap: 1rem;
    font-size: 0.85rem;
    color: #666666;
  }

  .new-label {
    background-color: #ff5252;
    color: #ffffff;
    font-size: 0.75rem;
    font-weight: bold;
    padding: 0.25rem 0.5rem;
    border-radius: 12px;
    margin-left: 1rem;
    text-transform: uppercase;
  }

  .detail {
    display: inline-block;
  }

  .salary {
    font-size: 1rem;
    font-weight: 600;
    color: #666666;
  }

  .skills {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-top: 0.5rem;
  }

  .skill {
    display: flex;
    align-items: center;
    gap: 0.25rem;
    background-color: #cee5f2;
    color: #666666;
    font-size: 0.85rem;
    padding: 0.25rem 0.5rem;
    border-radius: 12px;
    white-space: nowrap;
  }

  .skill-name {
    font-weight: 600;
  }

  .skill-level {
    font-size: 0.8rem;
    color: #555;
  }

  .like-button {
    position: absolute;
    bottom: 1rem;
    right: 1rem;
    background: transparent;
    border: none;
    width: 40px;
    height: 30px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    border-radius: 50%;
  }

  .like-button:hover {
    background: rgba(255, 82, 82, 0.1);
    transform: scale(1.1);
    box-shadow: 0 6px 12px rgba(255, 82, 82, 0.2);
  }

  .like-button:active {
    transform: scale(0.9);
    box-shadow: 0 3px 6px rgba(255, 82, 82, 0.3);
  }

  .liked {
    fill: #ff5252;
    transition: fill 0.3s ease, transform 0.3s ease;
  }

  .liked:hover {
    transform: scale(1.2);
    fill: #e60000;
  }

  .unliked {
    fill: #cccccc;
    transition: fill 0.3s ease, transform 0.3s ease;
  }

  .unliked:hover {
    fill: #ff5252;
    transform: scale(1.1);
  }

</style>
