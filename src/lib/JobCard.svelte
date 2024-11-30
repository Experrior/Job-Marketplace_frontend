<script>
  import HeartIcon from './HeartIcon.svelte';

  export let job;

  let isLiked = false;

  function navigateToJob() {
    window.location.href = `/job/${job.jobId}`;
  }

  function toggleLike(event) {
    event.stopPropagation();
    isLiked = !isLiked;
    console.log(`${isLiked ? "Liked" : "Unliked"} job: ${job.jobId}`);
  }
</script>

<div class="job-card" on:click={navigateToJob}>
  <div class="company-logo">
    <img src="/images/visa-logo.png" alt="Visa Logo" />
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

  <!-- Use the HeartIcon component -->
  <HeartIcon {isLiked} toggleLike={toggleLike} />
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
    width: 50px;
    height: 50px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    overflow: hidden;
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
</style>
