<script>
  import { goto } from '$app/navigation';
  import JobDescription from '$lib/JobDescription.svelte';
  import axios from 'axios';
  import { user, verifyUser } from '$lib/stores/user';
  import { onMount } from 'svelte';
  import Quill from 'quill';
  import 'quill/dist/quill.snow.css';
  import AppBar from "$lib/AppBar.svelte";

  const apiGateway = import.meta.env.VITE_GATEWAY_URL;
  console.log("USING GATEWAY:", apiGateway);

  console.log(verifyUser());

  let title = '';
  let companyLogo = '';
  let location = '';
  let category = '';
  let employmentType = '';
  let workLocation = '';
  let salary = '';
  let description = '';
  let requiredExperience = 0;
  let experienceLevel = '';
  let skillName = '';
  let skillLevel = 1;
  let skillsList = [];
  let quizName = '';
  let skillChange = false;
  let quizzes = [];
  let quillInstance;

  const apiGateway = import.meta.env.VITE_GATEWAY_URL;
  console.log("USING GATEWAY:", apiGateway);
  onMount(async () => {
    // Initialize Quill editor
    quillInstance = new Quill('#quill-editor', {
      theme: 'snow',
      placeholder: 'Describe the job role...',
      modules: {
        toolbar: [
          [{ header: [1, 2, false] }],
          ['bold', 'italic', 'underline'],
          [{ list: 'ordered' }, { list: 'bullet' }],
          ['link', 'blockquote', 'code-block']
        ]
      }
    });

    // Set initial value for the description
    quillInstance.on('text-change', () => {
      description = quillInstance.root.innerHTML;
    });

    // Fetch quizzes
    try {
      const response = await axios.post(
              `${apiGateway}/job-service/graphql`,
              {
                query: `query {
            quizzesByRecruiter {
              quizId
              quizName
            }
          }`
        },
        {
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${$user.jwt}`
          }
        }
      );
      quizzes = response.data.data.quizzesByRecruiter;
    } catch (error) {
      alert(error);
    }
  });

  const categories = [
    "Web Development",
    "Mobile Development",
    "Gamedev",
    "Embedded",
    "Analytics",
    "Machine Learning",
    "Cloud Computing",
    "Networks",
    "Cybersecurity",
    "Administration",
    "ERP",
    "Consulting",
    "Compilers"
  ];

  const categoriesMapping = {
    'Web Development': 'WEB_DEVELOPMENT',
    'Mobile Development': 'MOBILE_DEVELOPMENT',
    'Gamedev': 'GAMEDEV',
    'Embedded': 'EMBEDDED',
    'Analytics': 'ANALYTICS',
    'Machine Learning': 'MACHINE_LEARNING',
    'Cloud Computing': 'CLOUD_COMPUTING',
    'Networks': 'NETWORKS',
    'Cybersecurity': 'CYBERSECURITY',
    'Administration': 'ADMINISTRATION',
    'ERP': 'ERP',
    'Consulting': 'CONSULTING',
    'Compilers': 'COMPILERS'
  };

  const employmentTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Internship',
    'Temporary',
    'Freelance'
  ];

  const employmentTypeMapping = {
    'Full-time': 'FULL_TIME',
    'Part-time': 'PART_TIME',
    'Contract': 'CONTRACT',
    'Internship': 'INTERNSHIP',
    'Temporary': 'TEMPORARY',
    'Freelance': 'FREELANCE'
  };

  const experienceLevels = ['Intern', 'Junior', 'Mid', 'Senior', 'Lead', 'Manager', 'Director', 'Executive'];

  const workLocations = ['remote', 'hybrid', 'onsite'];

  function addSkill() {
    if (skillName && skillLevel) {
      let newSkill = {};
      newSkill['name'] = skillName;
      newSkill['level'] = skillLevel;
      skillsList.push(newSkill);
      skillName = '';
      skillLevel = '';
      skillChange = !skillChange;
    }
  }

  async function submit() {
    const jobRequestValue = {
      title,
      location,
      category: categoriesMapping[category],
      employmentType: employmentTypeMapping[employmentType],
      workLocation,
      salary: salary ? parseInt(salary) : null,
      description,
      requiredExperience,
      experienceLevel,
      skillsList
    };

    console.log(jobRequestValue);

    let quizId = quizzes.find((item) => item.quizName === quizName)?.quizId || null;

    const mutation = `
        mutation XD($jobDefinition: JobInput!) {
          createJob(jobRequest: $jobDefinition) {
            jobId
            companyId
            title
            category
            description
            requiredSkills
            requiredExperience
            location
            salary
            createdAt
            quizId
          }
        }`;

    const variables = {
      jobDefinition: {
        title: title,
        category: categoriesMapping[category],
        description: description,
        location: location,
        salary: salary,
        requiredSkills: skillsList,
        requiredExperience: requiredExperience,
        experienceLevel: experienceLevel,
        quizId: quizId,
        employmentType: employmentTypeMapping[employmentType],
        workLocation: workLocation
      }
    };

    try {
      const response = await axios.post(
              `${apiGateway}/job-service/graphql`,
              {
                query: mutation,
                variables: variables
              },
              {
                headers: {
                  'Content-Type': 'application/json',
                  Authorization: `Bearer ${$user.jwt}`
                }
              }
      );

      if (response.data.errors) {
        alert(response.data.errors);
      } else {
        const newJobId = response.data.data.createJob.jobId;
        goto(`/job/${newJobId}`);
      }
    } catch (error) {
      console.error(error);
      alert(error);
    }
  }

  function deleteSkill(index) {
    skillsList.splice(index, 1);
    skillsList = [...skillsList];
    skillChange = !skillChange;
  }

  $: if (skillLevel < 1) {
    skillLevel = 1;
  } else if (skillLevel > 5) {
    skillLevel = 5;
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
          <label for="category">Category</label>
          <select id="category" bind:value={category} required>
            <option value="" disabled selected>Select category</option>
            {#each categories as type}
              <option value="{type}">{type}</option>
            {/each}
          </select>
        </div>

        <div class="form-group">
          <label for="employmentType">Employment Type</label>
          <select id="employmentType" bind:value={employmentType} required>
            <option value="" disabled selected>Select employment type</option>
            {#each employmentTypes as type}
              <option value="{type}">{type}</option>
            {/each}
          </select>
        </div>

        <div class="form-group">
          <label for="workLocation">Work Location</label>
          <select id="workLocation" bind:value={workLocation} required>
            <option value="" disabled selected>Select work location</option>
            {#each workLocations as loc}
              <option value="{loc}">{loc.charAt(0).toUpperCase() + loc.slice(1)}</option>
            {/each}
          </select>
        </div>

        <div class="form-group">
          <label for="experienceLevel">Experience Level</label>
          <select id="experienceLevel" bind:value={experienceLevel} required>
            <option value="" disabled selected>Select experience level</option>
            {#each experienceLevels as level}
              <option value="{level}">{level.charAt(0).toUpperCase() + level.slice(1)}</option>
            {/each}
          </select>
        </div>

        <div class="form-group">
          <label for="salary">Salary ($)</label>
          <input id="salary" type="number" min="0" bind:value={salary} placeholder="e.g., 70000" />
        </div>

        <div class="form-group">
          <label for="description">Job Description</label>
          <div id="quill-editor" style="height: 200px;"></div>
        </div>

        <div class="form-group">
          <label for="requiredExperience">Required Experience in Years</label>
          <input id="requiredExperience" type="number" bind:value={requiredExperience} min="0" />
        </div>

        <div class="form-group">
            <label for="quiz">Quiz</label>
            <select id="quiz" bind:value={quizName}>
              <option value="" disabled selected>Select quiz for applicants</option>
              {#each quizzes as quiz}
                <option value="{quiz.quizName}">{quiz.quizName}</option>
              {/each}
            </select>
          </div>
  
        <div class="form-group skills-section">
          <h2>Add Required Skills</h2>
          <div class="skill-inputs">
            <input bind:value={skillName} placeholder="Skill Name" />
            <input bind:value={skillLevel} type=number min=1 max=5 placeholder="Level (1-5)" />
            
            <button type="button" on:click={addSkill}>Add Skill</button>
          </div>
          
          {#key skillChange}
          {#if skillsList.length > 0}
          <h2>Required Skills</h2>
          <ul class="required-skills">
            {#each skillsList as skill, index}
              <li>
                <span class="skill-name">{skill.name}</span>
                <span class="skill-level">
                  <!-- {#each Array(skill.value) as _, i}
                    <span class="star">&#9733;</span>
                  {/each} -->
                  {#each Array(Math.min(5, (skill.level || 0))) as _, i}
                  <span class="star">&#9733;</span>
                {/each}
                  {#each Array(Math.max(0, 5 - (skill.level || 0))) as _, i}
                  <span class="star empty">&#9734;</span>
                {/each}
                </span>
                <!-- Delete Button -->
                <button class="delete-button" on:click={() => deleteSkill(index)}>X</button>
              </li>
            {/each}
          </ul>
        {/if}
        {/key}
        </div>
  
        <button type="submit" class="submit-button">Submit Job Offer</button>
      </form>
    {#key skillChange}
  <div class="live-preview">
    <JobDescription
      {title}
      company=""
      {companyLogo}
      {location}
      {employmentType}
      {workLocation}
      {salary}
      {description}
      {requiredExperience}
      {skillsList}
    />
  </div>
  {/key}
</div>
</div>
  
  <style>

.delete-button {
    background-color: red;
    color: white;
    border: none;
    border-radius: 2px;
    width: 20px;
    height: 20px;
    cursor: pointer;
    margin-left: 10px;
    font-weight: bold;
    line-height: 18px;
    text-align: center;
  }

  .delete-button:hover {
    background-color: darkred;
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
      /* max-height: calc(100vh - 200px); */
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

    /* Style for the select elements */
    select#category,
    select#employmentType,
    select#workLocation,
    select#experienceLevel,
    select#quiz{
      width: 100%;
      padding: 0.75rem;
      border: 1px solid #ced4da;
      border-radius: 4px;
      background-color: #ffffff;
      font-size: 1rem;
      color: #495057;
      margin-bottom: 1rem;
    }

    /* Style for the select elements on focus */
    select#category:focus,
    select#employmentType:focus,
    select#workLocation:focus,
    select#experienceLevel:focus,
    select#quiz:focus {
      border-color: #80bdff;
      outline: none;
      box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
    }

    /* Style for the select elements when disabled */
    select#category:disabled,
    select#employmentType:disabled,
    select#workLocation:disabled,
    select#experienceLevel:disabled,
    select#quiz:disabled {
      background-color: #e9ecef;
      color: #6c757d;
    }


  </style>
  