<script>
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { goto } from '$app/navigation';
  import AppBar from '../../../lib/AppBar.svelte';
  import {user, verifyUser} from '$lib/stores/user'
  import axios from 'axios';
  import Cookie from 'js-cookie';

  let jobNotFound = false;
  let jobId = $page.params.slug;
  var newJob = {};
  let loading = true;
  let error = null;
  let skillsList = [];
  let resume = {};
  let resumes = [];
  let job= {};
  //TODO add only verified can apply
    // let isLoggedIn = false;
  // onMount(() => {
  //   let isLoggedIn = verifyUser()
  // })
  onMount(async () => {
    verifyUser()
    console.log($user.jwt)


    const query = `
    query XD($jobIdi: ID!){
        jobById(jobId: $jobIdi){
          jobId
          title
          location
          employmentType
          workLocation
          requiredExperience
          salary
          companyId
          companyName
          requiredSkills
          description
          createdAt
          quizId
        }
    }
    `;
    const variables = {
      jobIdi: jobId

    };
    console.log('gusadfasdfasdf')
    console.log(jobId)
    try{
        await fetch('http://localhost:8080/job-service/graphql',{
        method: 'POST',

        headers:{
                "Content-Type": "application/json",
                'Authorization': `Bearer ${$user.jwt}`
                },
                body: JSON.stringify({
                query: query,
                variables: variables
                })
        },
        {
        },
          {}
        ).then(r => r.json()).then(data => newJob = data.data.jobById)




        console.log()
        console.log('gw')
        console.log(response)
        newJob = response.data.data.jobById
        
        console.log('done update')
        console.log(skillsList)
        console.log(newJob)
        if (newJob){
        skillsList = [...newJob.requiredSkills.matchAll(/Skill\(name=([^,]+), level=(\d+)/g)]
        .map(match => ({
        name: match[1],
        level: Number(match[2])
        }));
        }

    } catch (err) {

        console.log(err);
        error = err.message || 'An error occurred while fetching the job.';
        jobNotFound =true;
    } finally {
        loading = false;
    }


try{
    const response = await axios.post('http://localhost:8080/user-service/myResumes', {},
    {headers:
        {Authorization: "Bearer "+$user.jwt,
        "Content-Type": "application/json",
        }
    }
    );
    console.log(response)
    resumes = response.data
    }catch (error) {
        console.log(error)
    }


  });

  console.log("test1")
  console.log(newJob)

  function formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(dateString).toLocaleDateString(undefined, options);
  }

  async function takeQuiz(){

    console.log("KAOSODASDIABSD")
    console.log(localStorage.getItem('jwt'))
    console.log($user.jwt)



    // resume.resumeUrl
    // const response = await axios.get(resume.resumeUrl, {}, {
    //       headers: {
    //         'Content-Type': 'multipart/form-data',
    //       },
    //     })
    // console.log('test1')
    //   console.log(response)

    //todo fix, now is workaround
      Cookie.set('s3Path', resume.resumeUrl)
      Cookie.set('resumeName', resume.resumeName)
      Cookie.set('jobId',jobId)
      
// const response1 = axios.post(`http://localhost:8080/job-service/applications/${jobId}/apply`,{},
//       {headers:{
//                     'Authorization': `Bearer ${$user.jwt}`
//                   }}
//       )
//       console.log('938ryfvjdbkuhi')
//       console.log(response1)

    goto(`/quiz/${newJob.quizId}`)
  }

  // skillsList = [...skillsList.matchAll(/Skill\(name=([^,]+), level=(\d+)/g)]
  // .map(match => ({
  //   name: match[1],
  //   level: Number(match[2])
  // }));
  console.log('smiec')
  console.log(skillsList)
</script>

<AppBar/>



<div class="scrollable-page">
    <img src="/images/job_background.webp" alt="Job Background" class="full-width-image" />

<<<<<<< HEAD
  {#if loading}
      <p>Loading...</p>
  {:else if error}
      <p class="error-message">You need to log in to view this offer</p>
  {:else if newJob}
      <div class="job-description">
          <img src="{newJob.companyLogo}" alt="{newJob.companyName} Logo" class="company-logo" />
=======
    {#if loading}
        <p class="loading-message">Loading...</p>
    {:else if error}
        <p class="error-message">Job not found</p>
    {:else if newJob}
        <div class="job-description">
            {#if newJob.companyLogo}
                <img src="{newJob.companyLogo}" alt="{newJob.companyName} Logo" class="company-logo" />
            {/if}
>>>>>>> origin

            <h1 class="job-title">{newJob.title}</h1>
            <p class="company-name">{newJob.companyName}</p>

            <div class="job-details">
                {#if newJob.location}
                    <p><strong>Location:</strong> {newJob.location}</p>
                {/if}
                {#if newJob.workLocation}
                    <p><strong>Work Type:</strong> {newJob.workLocation}</p>
                {/if}
                {#if newJob.employmentType}
                    <p><strong>Employment Type:</strong> {newJob.employmentType}</p>
                {/if}
                {#if newJob.salary}
                    <p><strong>Salary:</strong> ${newJob.salary.toLocaleString()}</p>
                {:else}
                    <p><strong>Salary:</strong> Undisclosed</p>
                {/if}
                {#if newJob.createdAt}
                    <p><strong>Posted On:</strong> {formatDate(newJob.createdAt)}</p>
                {/if}
            </div>

            {#if newJob.description}
                <h2>Job Description</h2>
                <p class="job-text">{newJob.description}</p>
            {/if}

            {#if newJob.requiredExperience}
                <h2>Required Experience</h2>
                <p class="job-text">{newJob.requiredExperience}</p>
            {/if}

            {#if skillsList?.length > 0}
                <h2>Required Skills</h2>
                <ul class="required-skills">
                    {#each skillsList as skill}
                        <li class="skill-item">
                            <span class="skill-name">{skill.name}</span>
                            <span class="skill-level">
                {#each Array(skill.level) as _}
                  <span class="star">&#9733;</span>
                {/each}
                                {#each Array(5 - skill.level) as _}
                  <span class="star empty">&#9734;</span>
                {/each}
              </span>
                        </li>
                    {/each}
                </ul>
            {/if}

            {#if resumes?.length > 0}
                <div class="form-group">
                    <label for="resume">Specify CV</label>
                    <select id="resume" bind:value={resume} class="resume-dropdown">
                        <option value="" disabled selected>Select a CV</option>
                        {#each resumes as resume}
                            <option value="{resume}">{resume.resumeName}</option>
                        {/each}
                    </select>
                </div>
            {/if}

            <button class="apply-button" on:click={takeQuiz}>
                Apply Now
            </button>
        </div>
    {:else}
        <p class="error-message">Job not found.</p>
    {/if}
</div>

<style>
    .scrollable-page {
        height: 90vh; /* Make the page fill the entire viewport */
        overflow-y: auto; /* Enable vertical scrolling */
        overflow-x: hidden; /* Prevent horizontal scrolling */
    }

    .full-width-image {
        width: 100%;
        max-height: 300px;
        object-fit: cover;
        display: block;
        position: relative;
        z-index: 0;
    }

    .job-description {
        max-width: 800px;
        margin: -80px auto 2rem;
        padding: 2rem;
        background-color: #ffffff;
        border-radius: 16px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        z-index: 1;
        position: relative;
    }

    .company-logo {
        width: 70px;
        height: 70px;
        object-fit: cover;
        border-radius: 50%;
        margin-bottom: 1rem;
        border: 1px solid #e5e5e5;
    }

    .job-title {
        font-size: 2rem;
        font-weight: 700;
        color: #2c3e50;
        margin: 0;
        text-align: center;
    }

    .company-name {
        font-size: 1.2rem;
        font-weight: 500;
        color: #7f8c8d;
        margin-bottom: 1.5rem;
        text-align: center;
    }

    .job-details p {
        font-size: 1rem;
        color: #4a4a4a;
        margin: 0.5rem 0;
        line-height: 1.6;
    }

    h2 {
        font-size: 1.4rem;
        font-weight: 600;
        color: #34495e;
        margin: 1.5rem 0 1rem;
    }

    .job-text {
        font-size: 1rem;
        line-height: 1.7;
        color: #495057;
        margin-bottom: 1.5rem;
    }

    .required-skills {
        list-style: none;
        padding: 0;
        margin: 1rem 0;
        display: flex;
        flex-wrap: wrap;
        gap: 0.75rem;
    }

    .skill-item {
        display: flex;
        align-items: center;
        background-color: #eef6ff;
        border: 1px solid #d1e9ff;
        padding: 0.5rem 1rem;
        border-radius: 8px;
        font-size: 0.9rem;
        color: #0073e6;
        transition: background-color 0.2s ease, transform 0.2s ease;
        cursor: pointer;
    }

    .skill-item:hover {
        background-color: #cde4ff;
        transform: translateY(-2px);
    }

    .skill-name {
        font-weight: 600;
        color: #0056b3;
        margin-right: 0.5rem;
    }

    .skill-level {
        display: flex;
    }

    .star {
        color: #f4b400;
        font-size: 1rem;
    }

    .star.empty {
        color: #e0e0e0;
    }

    .resume-dropdown {
        width: 100%;
        padding: 0.75rem;
        font-size: 1rem;
        border: 1px solid #e1e1e1;
        border-radius: 12px;
        margin-top: 1rem;
        background-color: #ffffff;
        color: #495057;
        transition: border-color 0.2s ease;
    }

    .resume-dropdown:focus {
        border-color: #007bff;
        outline: none;
        box-shadow: 0 0 4px rgba(0, 123, 255, 0.3);
    }

    .apply-button {
        display: block;
        width: 100%;
        text-align: center;
        padding: 0.75rem;
        font-size: 1.1rem;
        font-weight: 600;
        color: #ffffff;
        background-color: #758c96;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.3s ease, box-shadow 0.3s ease, transform 0.2s ease;
        margin-top: 1rem;
    }

    .apply-button:hover {
        background-color: #8697C4;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        transform: translateY(-2px);
    }

    .loading-message,
    .error-message {
        font-size: 1.2rem;
        color: #666666;
        text-align: center;
        margin-top: 2rem;
    }

    .error-message {
        color: #e74c3c;
    }

    @media (max-width: 768px) {
        .job-description {
            width: 90%;
            margin: -60px auto 1.5rem;
        }

        .company-logo {
            width: 60px;
            height: 60px;
        }

        .job-title {
            font-size: 1.6rem;
        }
    }

</style>
