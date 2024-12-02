<script>
    import { goto } from '$app/navigation';
    import JobDescription from '$lib/JobDescription.svelte';

    import AppBar from '$lib/AppBar.svelte';

    let title = '';
  let companyLogo = '';
  let location = '';
  let category = '';
  let employment_type = '';
  let work_location = '';
  let salary = '';
  let description = '';
  let requiredExperience = '';
  let requiredSkills = {};
  let skillName = '';
  let skillLevel = '';
  let skillsList = [];

  const employmentTypes = [
    'Full-time',
    'Part-time',
    'Contract Work',
    'Internship',
    'B2B',
    'Specific-task contract',
    'Freelance'
  ];

  const workLocations = ['remote', 'hybrid', 'stationary'];
    
  
    function addSkill() {
      if (skillName && skillLevel) {
        requiredSkills[skillName] = +skillLevel;
        skillsList = Object.entries(requiredSkills);
        skillName = '';
        skillLevel = '';
      }
    }
  
    function submit() {
    const job = {
      title,
      companyLogo,
      location,
      category,
      employment_type,
      work_location,
      salary: salary ? parseInt(salary) : null,
      description,
      requiredExperience,
      requiredSkills,
    };
    console.log(job);
    goto(`/jobs/${title.toLowerCase().replace(/\s+/g, '-')}`);
  }
  </script>
  
  <AppBar/>


  <div class="scrollable-page">
    <img src="/images/job_background.webp" alt="Job Background" class="full-width-image" />
  

    <div class="main-content">

      <form on:submit|preventDefault={submit} class="job-form">
        <div class="form-header">
          <h1>Create New Job Offer</h1>
          {#if companyLogo}
            <img src="{companyLogo}" alt="Company Logo" class="company-logo" />
          {/if}
        </div>
        <div class="form-group">
          <label for="title">Job Title</label>
          <input id="title" bind:value={title} placeholder="e.g., Senior Software Engineer" required />
        </div>
  
        <div class="form-group">
            <label for="location">Location</label>
            <input id="location" bind:value={location} placeholder="e.g., San Francisco, CA" required />
          </div>
      
          <div class="form-group">
            <label for="employment_type">Employment Type</label>
            <select id="employment_type" bind:value={employment_type} required>
              <option value="" disabled selected>Select employment type</option>
              {#each employmentTypes as type}
                <option value="{type}">{type}</option>
              {/each}
            </select>
          </div>
      
          <div class="form-group">
            <label for="work_location">Work Location</label>
            <select id="work_location" bind:value={work_location} required>
              <option value="" disabled selected>Select work location</option>
              {#each workLocations as loc}
                <option value="{loc}">{loc.charAt(0).toUpperCase() + loc.slice(1)}</option>
              {/each}
            </select>
          </div>
      
          <div class="form-group">
            <label for="salary">Salary ($)</label>
            <input id="salary" type="number" min="0" bind:value={salary} placeholder="e.g., 70000" />
          </div>
  
  
        <div class="form-group">
          <label for="category">Category</label>
          <input id="category" bind:value={category} placeholder="e.g., Engineering" />
        </div>
  
        <div class="form-group">
          <label for="description">Job Description</label>
          <textarea id="description" bind:value={description} placeholder="Describe the job role" required></textarea>
        </div>
  
        <div class="form-group">
          <label for="requiredExperience">Required Experience</label>
          <textarea id="requiredExperience" bind:value={requiredExperience} placeholder="Detail the required experience"></textarea>
        </div>
  
        <div class="form-group skills-section">
          <h2>Add Required Skills</h2>
          <div class="skill-inputs">
            <input bind:value={skillName} placeholder="Skill Name" />
            <input bind:value={skillLevel} type="number" min="1" max="5" placeholder="Level (1-5)" />
            <button type="button" on:click={addSkill}>Add Skill</button>
          </div>
          {#if skillsList.length}
            <ul class="skills-list">
              {#each skillsList as [skill, level]}
                <li>{skill}: Level {level}</li>
              {/each}
            </ul>
          {/if}
        </div>
  
        <button type="submit" class="submit-button">Submit Job Offer</button>
      </form>
  
  <div class="live-preview">
    <JobDescription
      {title}
      company=""
      {companyLogo}
      {location}
      {employment_type}
      {work_location}
      {salary}
      {description}
      {requiredExperience}
      {requiredSkills}
    />
  </div>
</div>
</div>
  
  <style>

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
      max-width: 1600px;
      margin: -80px auto 2rem;
      padding: 1rem;
      position: relative;
      z-index: 1;
    }
  
    .job-form {
      flex: 1;
      margin-right: 1rem;
      background-color: #f8f9fa;
      padding: 1.5rem;
      border-radius: 8px;
    }
  
    .form-header {
      display: flex;
      align-items: center;
      margin-bottom: 1.5rem;
    }
  
    .form-header h1 {
      flex: 1;
    }
  
    .company-logo {
      width: 80px;
      height: 80px;
      object-fit: contain;
    }
  
    .form-group {
      margin-bottom: 1rem;
    }
  
    .form-group label {
      display: block;
      margin-bottom: 0.5rem;
      font-weight: bold;
    }
  
    .form-group input,
    .form-group textarea {
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ced4da;
      border-radius: 4px;
    }
  
    .form-group textarea {
      resize: vertical;
    }
  
    .skills-section {
      margin-top: 2rem;
    }
  
    .skills-section h2 {
      margin-bottom: 1rem;
    }
  
    .skill-inputs {
      display: flex;
      gap: 0.5rem;
      margin-bottom: 1rem;
    }
  
    .skill-inputs input {
      flex: 1;
    }
  
    .skill-inputs button {
      padding: 0.5rem 1rem;
      background-color: #007bff;
      border: none;
      color: white;
      border-radius: 4px;
      cursor: pointer;
    }
  
    .skills-list {
      list-style: none;
      padding: 0;
    }
  
    .skills-list li {
      background-color: #e9ecef;
      padding: 0.5rem;
      border-radius: 4px;
      margin-bottom: 0.5rem;
    }
  
    .submit-button {
      width: 100%;
      padding: 0.75rem;
      background-color: #28a745;
      border: none;
      color: white;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1rem;
    }
  
    .live-preview {
      flex: 1;
      background-color: #ffffff;
      padding: 1.5rem;
      border-radius: 8px;
      border: 1px solid #ced4da;
      overflow-y: auto;
    }
  
    @media (max-width: 228px) {
      .main-content {
        flex-direction: column;
      }
  
      .job-form {
        margin-right: 0;
        margin-bottom: 1rem;
      }
  
      .live-preview {
        max-height: none;
      }
    }
  </style>
  