<script>
  import { onMount } from 'svelte';
  import { goto } from '$app/navigation';
  import { writable } from 'svelte/store';
  import JobDescription from '$lib/JobDescription.svelte';
  import { user } from "$lib/stores/user";
  import AppBar from '$lib/AppBar.svelte';
  import { page } from '$app/stores';
  import axios from 'axios';
  import ChatBox from '$lib/ChatBox.svelte';

  let jobId = $page.params.slug;
  let applicants = [];
  let job = {};
  let chatList = [];
  let chatId = '';
  let skillsList = [];
  const sortedApplicants = writable([]);
  let sortColumn = 'score';
  let sortDirection = 'asc';
  let applicantsToShow = 5;

  onMount(async () => {
    await fetchApplicants();
    await fetchJobDetails();
    if (job?.requiredSkills) {
      parseSkills(job.requiredSkills);
    }

    console.log("Applicants: ", applicants);
  });

  async function fetchApplicants() {
    const query = `
      query XD($jobId: ID!) {
        jobApplications(jobId: $jobId) {
          applicationId
          userId
          userPictureUrl
          job {
            jobId
            title
            description
            location
            salary
            createdAt
          }
          status
          quizResult {
            score
            timeTaken
          }
          fullName
          resumeUrl
        }
      }
    `;

    try {
      const response = await axios.post('http://localhost:8080/job-service/graphql', {
        query,
        variables: { jobId },
      }, {
        headers: {
          "Content-Type": "application/json",
          'Authorization': `Bearer ${$user.jwt}`
        }
      });
      applicants = response.data.data.jobApplications;
      console.log("Job Applications: ", response.data.data.jobApplications);
      sortApplicants();
    } catch (error) {
      alert(error.message || "An error occurred while fetching applicants.");
    }
  }

  async function fetchJobDetails() {
    const query = `
      query XD($jobIdi: ID!) {
        jobById(jobId: $jobIdi) {
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

    try {
      const response = await fetch('http://localhost:8080/job-service/graphql', {
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          'Authorization': `Bearer ${$user.jwt}`
        },
        body: JSON.stringify({ query, variables: { jobIdi: jobId } })
      });
      const data = await response.json();
      job = data.data.jobById;
    } catch (error) {
      console.error(error);
    }
  }

  function parseSkills(requiredSkills) {
    skillsList = [...requiredSkills.matchAll(/Skill\(name=([^,]+), level=(\d+)/g)]
            .map(match => ({
              name: match[1],
              level: Number(match[2])
            }));
  }

  function sortApplicants() {
    const sorted = [...applicants];

    sorted.sort((a, b) => {
      let comparison = 0;

      if (sortColumn === 'name') {
        comparison = a.fullName.localeCompare(b.fullName);
      } else if (sortColumn === 'score') {
        comparison = (b.quizResult?.score || 0) - (a.quizResult?.score || 0);
      } else if (sortColumn === 'time') {
        comparison = (a.quizResult?.timeTaken || 0) - (b.quizResult?.timeTaken || 0);
      } else if (sortColumn === 'status') {
        comparison = a.status.localeCompare(b.status);
      }

      return sortDirection === 'asc' ? comparison : -comparison;
    });

    sortedApplicants.set(sorted);
  }

  function handleSortChange(column) {
    if (sortColumn === column) {
      sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
      sortColumn = column;
      sortDirection = 'asc';
    }
    sortApplicants();
  }

  function getDuration(totalSeconds) {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  }

  async function startChat(applicantId, applicantName) {
    const fullName = `${$user.firstName} ${$user.lastName}`;
    try {
      const response = await fetch(`http://localhost:8080/chat-service/startChat?targetUserId=${applicantId}&recruiterName=${fullName}&applicantName=${applicantName}`, {
        headers: { "Authorization": `Bearer ${$user.jwt}` }
      });
      const data = await response.text();
      chatList = JSON.parse(data);
      chatId = chatList[0];
    } catch (error) {
      console.error("Error starting chat:", error);
    }
  }

  async function updateStatus(applicationId, newStatus) {
    const mutation = `
      mutation {
        setApplicationStatus(applicationId: "${applicationId}", status: "${newStatus}") {
          success
          message
        }
      }
    `;

    try {
      const response = await axios.post('http://localhost:8080/job-service/graphql', {
        query: mutation
      }, {
        headers: {
          "Content-Type": "application/json",
          'Authorization': `Bearer ${$user.jwt}`
        }
      });

      const result = response.data.data.setApplicationStatus;
      if (result.success) {
        alert('Status updated successfully');
        await fetchApplicants(); // Refresh the applicants list
      } else {
        alert(`Failed to update status: ${result.message}`);
      }
    } catch (error) {
      console.error('Error updating status:', error);
      alert('An error occurred while updating the status.');
    }
  }
</script>


<AppBar/>


<div class="scrollable-page">
  <img src="/images/job_background.webp" alt="Job Background" class="full-width-image" />

  {#if job}
    <div class="main-content">

      <div class="job-description-container">
        <JobDescription
          title={job.title}
          company={job.company}
          companyLogo={job.companyLogo}
          location={job.location}
          employment_type={job.employment_type}
          work_location={job.work_location}
          salary={job.salary}
          description={job.description}
          requiredExperience={job.requiredExperience}
          requiredSkills={job.requiredSkills}
        />
      </div>

      <div class="applicants-overview">
        <h2>Applicants Overview</h2>
        <p>Total Applicants: {applicants.length}</p>
      
        <div class="applicants-number">
          <label for="applicantsToShow">Number of applicants to display:</label>
          <input
            type="number"
            id="applicantsToShow"
            min="1"
            max={applicants.length}
            bind:value={applicantsToShow}
          />
        </div>
      
        <div class="sorting-options">
        </div>

        <table class="applicants-table">
          <thead>
          <tr>
            <th>Photo</th>
            <th
                    class={`sortable ${sortColumn === 'name' ? sortDirection : ''}`}
                    on:click={() => handleSortChange('name')}>
              Applicant Name
            </th>
            <th
                    class={`sortable ${sortColumn === 'score' ? sortDirection : ''}`}
                    on:click={() => handleSortChange('score')}>
              Score
            </th>
            <th
                    class={`sortable ${sortColumn === 'time' ? sortDirection : ''}`}
                    on:click={() => handleSortChange('time')}>
              Time (MM:SS)
            </th>
            <th
                    class={`sortable ${sortColumn === 'status' ? sortDirection : ''}`}
                    on:click={() => handleSortChange('status')}>
              Status
            </th>
            <th>CV</th>
            <th>Start Chat</th>
          </tr>
          </thead>
          <tbody>
          {#each $sortedApplicants.slice(0, applicantsToShow) as applicant}
            <tr>
              <td>
                <img src="{applicant.userPictureUrl || '/images/profile2.png'}" class="applicant-photo" />
              </td>
              <td>{applicant.fullName}</td>
              <td>{applicant.quizResult && applicant.quizResult.score !== undefined ? applicant.quizResult.score : ''}</td>
              <td>{applicant.quizResult && applicant.quizResult.timeTaken !== undefined ? getDuration(applicant.quizResult.timeTaken) : ''}</td>
              <td>
                <select class="status-select" on:change={(e) => updateStatus(applicant.applicationId, e.target.value)}>
                  <option value="PENDING" selected={applicant.status === 'PENDING'}>Pending</option>
                  <option value="APPROVED" selected={applicant.status === 'APPROVED'}>Approved</option>
                  <option value="REJECTED" selected={applicant.status === 'REJECTED'}>Rejected</option>
                  <option value="OFFERED" selected={applicant.status === 'OFFERED'}>Offered</option>
                  <option value="ACCEPTED" selected={applicant.status === 'ACCEPTED'}>Accepted</option>
                  <option value="DECLINED" selected={applicant.status === 'DECLINED'}>Declined</option>
                </select>
              </td>
              <td>
                <a href="{applicant.resumeUrl || '#'}" download class="cv-download-button">
                  {applicant.resumeUrl ? 'Download' : ''}
                </a>
              </td>
              <td>
                <button class="start-chat-button" on:click={() => startChat(applicant.userId, applicant.fullName)}>StartChat</button>
              </td>
            </tr>
          {/each}
          </tbody>
        </table>
      </div>
    </div>
  {:else}
    <p class="error-message">Job not found.</p>
  {/if}
</div>
<ChatBox/>
<style>


.applicants-table th,
  .applicants-table td {
    border: 1px solid #ddd;
    padding: 0.75rem;
    text-align: left;
    vertical-align: middle;
  }

  .applicant-photo {
    width: 50px;
    height: 50px;
    object-fit: cover;
    border-radius: 50%;
  }

  .cv-download-button {
    padding: 0.5rem 1rem;
    background-color: #007bff;
    color: white;
    border-radius: 4px;
    text-decoration: none;
    font-size: 0.9rem;
  }

  .cv-download-button:hover {
    background-color: #0056b3;
  }

  .applicants-table th:first-child,
  .applicants-table td:first-child {
    width: 60px;
  }

  .applicants-table th:last-child,
  .applicants-table td:last-child {
    width: 120px;
  }

  .start-chat-button {
    padding: 0.5rem 1rem;
    background-color: #28a745;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s ease, transform 0.2s ease;
  }

  .start-chat-button:hover {
    background-color: #218838;
    transform: translateY(-2px);
  }

  .status-select {
    padding: 0.5rem;
    border: 1px solid #ced4da;
    border-radius: 4px;
    background-color: white;
    color: #495057;
    cursor: pointer;
    transition: border-color 0.2s ease;
  }

  .status-select:focus {
    border-color: #007bff;
    outline: none;
    box-shadow: 0 0 4px rgba(0, 123, 255, 0.3);
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
    max-width: 1450px;
    margin: -80px auto 2rem;
    padding: 1rem;
    position: relative;
    z-index: 1;
  }

  .job-description-container {
    flex: 0.4;
    margin-right: 1rem;
    background-color: #f8f9fa;
    padding: 1.5rem;
    border-radius: 8px;
    border: 1px solid #ced4da;
    overflow-y: auto;
    max-height: 1200px;
  }


  .applicants-overview {
    flex: 1;
    background-color: #ffffff;
    padding: 1.5rem;
    border-radius: 8px;
    border: 1px solid #ced4da;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  .applicants-overview h2 {
    margin-top: 0;
  }

  .applicants-number {
    margin: 1rem 0;
  }

  .applicants-number label {
    margin-right: 0.5rem;
    font-weight: bold;
  }

  .applicants-number input {
    width: 60px;
    padding: 0.25rem;
    border: 1px solid #ced4da;
    border-radius: 4px;
  }

  .sorting-options {
    display: flex;
    align-items: center;
    margin: 1rem 0;
    gap: 0.5rem;
  }

  .sorting-options button {
    padding: 0.5rem 1rem;
    border: 1px solid #007bff;
    background-color: white;
    color: #007bff;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  .sorting-options button.active,
  .sorting-options button:hover {
    background-color: #007bff;
    color: white;
  }

  .applicants-table {
    width: 100%;
    border-collapse: collapse;
  }

  .applicants-table th,
  .applicants-table td {
    border: 1px solid #ddd;
    padding: 0.75rem;
    text-align: left;
  }

  .applicants-table th {
    background-color: #f8f8f8;
    cursor: pointer;
  }

  .applicants-table tr:nth-child(even) {
    background-color: #f9f9f9;
  }

  .applicants-table tr:hover {
    background-color: #f1f1f1;
  }

  .sortable {
    cursor: pointer;
    position: relative;
  }

  .sortable::after {
    content: '';
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    border: 5px solid transparent;
  }

  .sortable.asc::after {
    border-bottom-color: #000000;
  }

  .sortable.desc::after {
    border-top-color: #000000;
  }

  .sortable:hover {
    color: #000000;
  }

  @media (max-width: 768px) {
    .main-content {
      flex-direction: column;
    }

    .job-description-container {
      margin-right: 0;
      margin-bottom: 1rem;
      max-height: 1600px;
    }
  } 
</style>
