<script>
    import { onMount } from 'svelte';
    import { page } from '$app/stores';
    import { goto } from '$app/navigation';
    import AppBar from '../../../lib/AppBar.svelte';
    import { user, verifyUser } from '$lib/stores/user';
    import Cookie from 'js-cookie';
    
    let jobNotFound = false;
    let jobId = $page.params.slug;
    let newJob = {};
    let loading = true;
    let error = null;
    let skillsList = [];
    let resume = {};
    let resumes = [];
    let applications = [];
    let hasApplied = false;
    let showError = false;
    let applicationSuccess = false;


    console.log('All env vars:', import.meta.env);
    
    const apiGateway = import.meta.env.VITE_GATEWAY_URL;
    console.log("USING GATEWAY:", apiGateway);
    
    async function fetchGraphQL(endpoint, query, variables = {}) {
        try {
            const response = await fetch(apiGateway + endpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${$user.jwt}`,
                },
                body: JSON.stringify({ query, variables }),
            });

            const { data, errors } = await response.json();
            if (errors) {
                console.error('GraphQL errors:', errors);
                throw new Error(errors.map((err) => err.message).join(', '));
            }
            return data;
        } catch (err) {
            console.error('GraphQL request failed:', err);
            throw err;
        }
    }

    onMount(async () => {
        verifyUser();

        try {
            // Fetch job details
            const jobQuery = `
                query($jobIdi: ID!) {
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
                        description
                        createdAt
                        quizId
                    }
                }
            `;
            const jobData = await fetchGraphQL(
                '/job-service/graphql',
                jobQuery,
                { jobIdi: jobId }
            );
            newJob = jobData.jobById;

            if (newJob) {
                skillsList = [...newJob.requiredSkills.matchAll(/Skill\(name=([^,]+), level=(\d+)/g)].map(
                    (match) => ({
                        name: match[1],
                        level: Number(match[2]),
                    })
                );
            }
        } catch (err) {
            error = err.message || 'An error occurred while fetching the job.';
            jobNotFound = true;
        } finally {
            loading = false;
        }

        try {
            // Fetch user resumes
            const resumesQuery = `
                query {
                    userResumes {
                        resumeId
                        resumeName
                        s3ResumePath
                        resumeUrl
                        createdAt
                    }
                }
            `;
            const resumesData = await fetchGraphQL('/user-service/graphql', resumesQuery);
            resumes = resumesData.userResumes;

            // Fetch user applications
            const applicationsQuery = `
                query {
                    userApplications {
                        job {
                            jobId
                        }
                    }
                }
            `;
            const applicationsData = await fetchGraphQL(
                '/job-service/graphql',
                applicationsQuery
            );
            applications = applicationsData.userApplications;

            hasApplied = applications.some((app) => app.job.jobId === jobId);

            console.log('Applications:', applications);
            console.log('Has applied:', hasApplied);

        } catch (err) {
            console.error('Error fetching user data:', err);
        }
    });

    function formatDate(dateString) {
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(dateString).toLocaleDateString(undefined, options);
    }

    async function takeQuiz() {
        if (!resume.resumeId) {
            showError = true;
            return;
        }
        showError = false;

        if (newJob.quizId) {
            Cookie.set('s3Path', resume.resumeUrl);
            Cookie.set('resumeName', resume.resumeName);
            Cookie.set('jobId', jobId);
            goto(`/quiz?quizId=${newJob.quizId}&resume=${resume.resumeId}&jobId=${jobId}`);
        } else {
            try {
                const applyMutation = `
                    mutation {
                        applyForJob(jobId: "${jobId}", resumeId: "${resume.resumeId}") {
                            applicationId
                            userId
                            job {
                                jobId
                            }
                            status
                            fullName
                            createdAt
                            resumeUrl
                        }
                    }
                `;
                const applicationData = await fetchGraphQL(
                    '/job-service/graphql',
                    applyMutation
                );
                console.log('Application successful:', applicationData);
                applicationSuccess = true;
            } catch (err) {
                console.error('Error applying for job:', err);
                // Handle error (e.g., show an error message)
            }
        }
    }
</script>

<AppBar/>

<div class="scrollable-page">
    <img src="/images/job_background.webp" alt="Job Background" class="full-width-image" />

    {#if loading}
        <p class="loading-message">Loading...</p>
    {:else if error}
        <p class="error-message">Job not found</p>
    {:else if newJob}
        <div class="job-description">
            {#if newJob.companyLogo}
                <img src="{newJob.companyLogo}" alt="{newJob.companyName} Logo" class="company-logo" />
            {/if}

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
                <p class="job-text">{@html newJob.description}</p>
            {/if}

            {#if newJob.requiredExperience}
                <div class="experience-section">
                    <h2>Experience Required</h2>
                    <p class="experience-number">{newJob.requiredExperience} years</p>
                </div>
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

            <div class="form-group">
                <label for="resume">Specify CV</label>
                <select id="resume" bind:value={resume} class="resume-dropdown" required>
                    <option value="" disabled selected>Select a CV</option>
                    {#each resumes as resume}
                        <option value="{resume}">{resume.resumeName}</option>
                    {/each}
                </select>
                {#if showError}
                    <p class="error-message">Specify a resume.</p>
                {/if}
            </div>

            {#if applicationSuccess}
                <div class="success-card">
                    <h2>Application Submitted Successfully!</h2>
                    <p>You have applied for the position of <strong>{newJob.title}</strong> at <strong>{newJob.companyName}</strong>.</p>
                    <p>Recruiters will review your application and get back to you shortly.</p>
                    <div class="next-steps">
                        <h3>Next Steps:</h3>
                        <ul>
                            <li>Prepare for potential interviews.</li>
                            <li>Check your email for updates on your application.</li>
                        </ul>
                    </div>
                    <button class="view-application-button" on:click={() => goto('/applications')}>
                        View My Applications
                    </button>
                </div>
            {:else if hasApplied}
                <p>You have already applied for this position.</p>
                <button class="submit-button" on:click={() => goto('/applications')}>
                    View Application
                </button>
            {:else}
                <button class="submit-button" on:click={takeQuiz}>
                    Apply Now
                </button>
            {/if}

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

    .submit-button {
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

    .submit-button:hover {
        background-color: #8697C4;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        transform: translateY(-2px);
    }

    .loading-message,
    .error-message {
        font-size: 1.1rem;
        color: #666666;
        text-align: left;
        margin-top: 0.5rem;
    }

    .error-message {
        color: #e74c3c;
    }

    .success-card {
        background: #e7f5ff;
        padding: 20px;
        border: 2px solid #90e0ef;
        border-radius: 10px;
        text-align: center;
        max-width: 600px;
        margin: 20px auto;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .success-card h2 {
        color: #0077b6;
        font-size: 1.8rem;
    }

    .success-card p {
        color: #023e8a;
        margin: 10px 0;
    }

    .success-card .next-steps {
        margin-top: 20px;
        text-align: left;
    }

    .success-card .next-steps h3 {
        color: #0077b6;
    }

    .success-card ul {
        color: #023e8a;
        list-style: disc;
        margin-left: 20px;
    }

    .success-card .view-application-button {
        background: #0096c7;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 20px;
        text-transform: uppercase;
    }

    .success-card .view-application-button:hover {
        background: #0077b6;
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
