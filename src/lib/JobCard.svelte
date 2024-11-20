<script>
  export let job;

  function navigateToJob() {
    // Navigate to job details page; adjust the route as needed
    window.location.href = `/jobs/${job.jobId}`;
  }

  // Function to parse requiredSkills string into an array of skill objects
  function parseRequiredSkills(skillsString) {
    // Remove the enclosing square brackets
    skillsString = skillsString.slice(1, -1);

    // Split the string into individual skill strings
    const skillStrings = skillsString.split('), ');

    // Map each skill string to a skill object
    const skills = skillStrings.map((skillStr) => {
      // Remove 'Skill(' prefix and ')' suffix if present
      skillStr = skillStr.replace('Skill(', '').replace(')', '');

      // Split the skill string into name and level
      const [namePart, levelPart] = skillStr.split(', ');

      // Extract the name and level values
      const name = namePart.split('=')[1];
      const level = levelPart.split('=')[1];

      return { name, level: parseInt(level) };
    });

    return skills;
  }

  // Parse requiredSkills string
  let requiredSkills = [];
  if (job.requiredSkills) {
    requiredSkills = parseRequiredSkills(job.requiredSkills);
  }
</script>

<div class="job-card">
  <!-- Location -->
  <span class="job-location">{job.location}</span>

  <!-- Company Logo Placeholder -->
  <div
    class="company-logo"
    style="background-color: #f0f0f0; display: flex; align-items: center; justify-content: center;"
  >
    <span>{job.companyName ? job.companyName.charAt(0) : 'C'}</span>
  </div>

  <!-- Job Information -->
  <div class="job-info">
    <div class="job-header">
      <h2 class="job-title">{job.title}</h2>
    </div>
    <p><strong>{job.companyName}</strong></p>
    <p><strong>Employment Type:</strong> {job.employmentType}</p>
    <p><strong>Work Location:</strong> {job.workLocation}</p>
    <p><strong>Salary:</strong> {job.salary ? `$${job.salary}` : 'Undisclosed'}</p>

    <!-- Required Skills -->
    {#if requiredSkills.length > 0}
      <div class="tags">
        {#each requiredSkills as skill}
          <div class="tag">
            {skill.name} (Level {skill.level})
          </div>
        {/each}
      </div>
    {/if}
  </div>

  <!-- Apply Button -->
  <button class="apply-button" on:click={navigateToJob}>Apply Now</button>
</div>

<style>

.apply-button {
    position: absolute;
    bottom: 1rem;
    right: 1rem;
    padding: 1rem 2rem; /* Increased padding to make the button bigger */
    font-size: 1rem; /* Increased font size */
    border: none;
    background-color: #007bff; /* Changed color for better visibility */
    color: white;
    border-radius: 4px;
    cursor: pointer;
  }

  .apply-button:hover {
    background-color: blue;
  }

  .job-card {
    position: relative;
    border: 1px solid #ddd;
    padding: 1rem;
    display: flex;
    align-items: flex-start;
    gap: 1rem;
    border-radius: 8px;
    background-color: #fff;
  }

  .job-location {
    position: absolute;
    top: 1rem;
    right: 1rem;
    font-size: 0.9rem;
    color: #555;
  }

  .company-logo {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2rem;
    color: #333;
  }

  .job-info {
    flex: 1;
  }

  .job-title {
    margin: 0;
    font-size: 1.5rem;
  }

  .tags {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    margin-top: 0.5rem;
  }

  .tag {
    background-color: #e0e0e0;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.9rem;
  }

  button {
    margin-top: 1rem;
    padding: 0.75rem 1.5rem;
    border: none;
    background-color: #007bff;
    color: white;
    border-radius: 4px;
    cursor: pointer;
  }

  button:hover {
    background-color: #0056b3;
  }
</style>
