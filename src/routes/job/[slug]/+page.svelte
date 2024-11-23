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
    console.log('guwno')
    console.log(newJob)
    // const stream = response.body.getReader()
    // console.log(stream.read())
    // console.log(response.body)
    // newJob = response.data.data.jobById
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
      Cookie.set('s3Path', resume.resumeUrl, { sameSite: 'strict' })
      Cookie.set('resumeName', resume.resumeName, { sameSite: 'strict' })
      Cookie.set('jobId',jobId, { sameSite: 'strict' })
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

  {#if loading}
      <p>Loading...</p>
  {:else if error}
      <p class="error-message">Job not found</p>
  {:else if newJob}
      <div class="job-description">
          <img src="{newJob.companyLogo}" alt="{newJob.companyName} Logo" class="company-logo" />

          <!-- Job Title and Company -->
          <h1>{newJob.title}</h1>
          <p><strong>{newJob.companyName}</strong></p>

          <h2>Job Description</h2>
          <p>{newJob.description}</p>

          <h2>Required Experience</h2>
          <p>{newJob.requiredExperience}</p>

          <h2>Location</h2>
          <p>{newJob.location}</p>

          <h2>Work Location</h2>
          <p>{newJob.workLocation}</p>

          <h2>Employment Type</h2>
          <p>{newJob.employmentType}</p>

          <h2>Required Skills</h2>
          {#await newJob.requiredSkills}
              <p> loading</p>
        {:then newJob}
          <!-- Required Skills -->
          <!-- {#if newJob.requiredSkills && newJob.requiredSkills.length > 0}
          <div class="form-group">
            <label for="quiz">Quiz</label>
            <select id="quiz" bind:value={quizName}>
              <option value="" disabled selected>Select quiz for applicants</option>
              {#each quizzes as quiz}
                <option value="{quiz.quizName}">{quiz.quizName}</option>
              {/each}
            </select>
          </div> -->
          <!-- {/if} -->
          
      {#if skillsList}
        <ul class="required-skills">
          {#each skillsList as skill}
              <li>
                  <span class="skill-name">{skill.name}</span>
                  <span class="skill-level">
                      {#each Array(skill.level) as _, index}
                          <span class="star">&#9733;</span>
                      {/each}
                      {#each Array(5 - skill.level) as _, index}
                          <span class="star empty">&#9734;</span>
                      {/each}
                  </span>
              </li>
          {/each}
        </ul>
        {/if}

        <!-- {#if verifyUser()} -->
        <div class="form-group">
          <label for="resume">Specify CV</label>
          <select id="resume" bind:value={resume}>
            <option value="" disabled selected>Select which cv to use</option>
            {#each resumes as resume}
              <option value="{resume}">{resume.resumeName}</option>
            {/each}
          </select>
        </div>
        <!-- {/if} -->

        {:catch error}
          <p style="color: red">{error.message}</p>
        {/await}
         
          <!-- {/if} -->

          <!-- Apply Button -->
          <button class="apply-button" on:click={takeQuiz}>
              Apply Now
          </button>
      </div>
  {:else}
      <p class="error-message">Job not found.</p>
  {/if}
</div>
<style>
  /* Existing styles */

  /* Required Skills Styles */
  .required-skills {
    list-style: none;
    padding: 0;
    margin: 1rem 0;
  }

  .required-skills li {
    display: flex;
    /* align-items: center; */
    margin-bottom: 0.5rem;
  }

  .skill-name {
    flex: 2;
  }

  .skill-level {
    display: flex;
    width: 70px;
    flex:0.5;
  }

  .star {
    color: #f1c40f;
    margin-right: 10px;
    font-size: 40px;
    margin-left: -20px;
  }

  .star.empty {
    color: #ccc;
    font-size: 40px;
  }




  /* Job Description Styles */
  .job-description {
    max-width: 800px;
    margin: -80px auto 2rem; /* Negative top margin for overlap */
    padding: 1.5rem;
    background-color: #f0f0f0;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    position: relative;
    z-index: 1; /* Brings job-description above the image */
  }

  /* Image Styles */
  .full-width-image {
    width: 100%;
    max-height: 350px;
    object-fit: cover;
    display: block;
    position: relative;
    z-index: 0; /* Ensures image stays behind job-description */
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

  .requiredSkills {
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
    font-size: 60px;
  }

  /* Responsive Adjustments */
  @media (max-width: 768px) {
    .job-description {
      width: 90%;
      margin: -60px auto 1.5rem; /* Adjusted for smaller screens */
    }

    .company-logo {
      width: 80px;
      height: 80px;
    }
  }
</style>
