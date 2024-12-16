<script>
  import 'quill/dist/quill.snow.css';

  export let title = '';
  export let company = '';
  export let companyLogo = '';
  export let location = '';
  export let employment_type = '';
  export let workLocation = '';
  export let salary = '';
  export let description = '';
  export let requiredExperience = '';
  export let requiredSkills = {};
  export let skillsList = {};
  export let employmentType = '';
</script>

<div class="job-description">
  {#if companyLogo}
    <img src="{companyLogo}" alt="{company} Logo" class="company-logo" />
  {/if}

  <h1>{title}</h1>
  {#if company}
    <p>
      <strong>{company}</strong>
    </p>
  {/if}

  <h2>Job Description</h2>
  <div class="quill-content">
    {@html description}
  </div>

  {#if requiredExperience}
    <h2>Required Experience</h2>
    <p class="job-text">{requiredExperience}</p>
  {/if}

  {#if employmentType}
    <p class="job-text"><strong>Type of employment :</strong> {employmentType}</p>
  {/if}

  <div class="job-details">
    {#if employment_type}
      <p><strong>Employment Type:</strong> {employment_type}</p>
    {/if}
    {#if workLocation}
      <p><strong>Work Location:</strong> {workLocation}</p>
    {/if}
    {#if location}
      <p><strong>Location:</strong> {location}</p>
    {/if}
    {#if salary !== null && salary !== ''}
      <p><strong>Salary:</strong> ${salary} / month</p>
    {:else}
      <p><strong>Salary:</strong> Undisclosed</p>
    {/if}
  </div>

  {#if skillsList && Object.keys(skillsList).length > 0}
    <h2>Required Skills</h2>
    <ul class="required-skills">
      {#each skillsList as skill}
        <li>
          <span class="skill-name">{skill.name}</span>
          <span class="skill-level">
            {#each Array(Math.min(5, (skill.level || 0))) as _, i}
              <span class="star">&#9733;</span>
            {/each}
            {#each Array(Math.max(0, 5 - (skill.level || 0))) as _, i}
              <span class="star empty">&#9734;</span>
            {/each}
          </span>
        </li>
      {/each}
    </ul>
  {/if}

  <button class="apply-button">
    Apply Now
  </button>
</div>
  
  <style>
    .job-description {
      max-width: 1600px;
      margin: 0 auto;
      padding: 1.5rem;
      background-color: #f0f0f0;
      border-radius: 8px;
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


.required-skills li {
  display: flex;
  align-items: center;
  margin-bottom: 0.5rem;
}

.skill-name {
  flex: 1;
}

.skill-level {
  display: flex;
  flex: 0;
}

.star, .star.empty {
  font-size: 40px;
  margin-right: 2px;
}

.star {
  color: #f1c40f;
}

.star.empty {
  color: #ccc;
}
  
.star.empty {
  color: #ccc;
  font-size: 40px;
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


.job-text {
  word-wrap: break-word;
  overflow-wrap: break-word;
  margin-bottom: 1rem;
}

.job-details p {
  margin: 0.5rem 0;
}

.job-description h2 {
  margin-top: 1.5rem;
}

</style>
  