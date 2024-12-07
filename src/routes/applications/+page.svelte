<script>
    import { onMount } from 'svelte';
    import { user, verifyUser } from "$lib/stores/user.js";
    import { goto } from "$app/navigation";
    import AppBar from "$lib/AppBar.svelte";

    let applications = [];
    let error = '';

    const API_URL = "http://localhost:8080/job-service/graphql";

    async function callGraphQL(query, variables = {}) {
        if (!verifyUser()) {
            goto('/login');
            return null;
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

    async function fetchApplications() {
        const query = `
      query {
        userApplications {
          applicationId
          userId
          resumeUrl
          job {
            jobId
            title
            location
            workLocation
            employmentType
            companyId
            salary
            createdAt
          }
          createdAt
          status
          quizResult {
            score
          }
        }
      }
    `;

        try {
            const result = await callGraphQL(query);
            console.log(result)

            if (result && result.userApplications) {
                applications = result.userApplications;
            } else {
                error = 'Could not load applications. Please try again later.';
            }
        } catch (err) {
            error = 'Failed to fetch applications. Please try again later.';
            console.error(err);
        }
    }

    function openJob(jobId) {
        goto(`/job/${jobId}`);
    }

    onMount(async () => {
        if (verifyUser()) {
            await fetchApplications();
        } else {
            goto('/login');
        }
    });
</script>

<main>
    <AppBar/>
    <div class="page-container">
        <h2>My Applications</h2>

        {#if error}
            <p class="error">{error}</p>
        {:else if applications.length === 0}
            <p class="empty-message">You have not applied to any jobs yet.</p>
        {:else}
            <div class="applications-list">
                {#each applications as application}
                    <div class="application-card">
                        <div class="card-header" on:click={() => openJob(application.job.jobId)}>
                            <h2 class="job-title">{application.job.title}</h2>
                            <span class="status-pill {application.status.toLowerCase()}">{application.status}</span>
                        </div>
                        <div class="card-body">
                            <p><strong>Location:</strong> {application.job.location || 'Not specified'}</p>
                            <p><strong>Work Type:</strong> {application.job.workLocation || 'Not specified'}</p>
                            <p><strong>Employment Type:</strong> {application.job.employmentType || 'Not specified'}</p>
                            <p><strong>Salary:</strong> {application.job.salary ? `$${application.job.salary.toLocaleString()}` : 'Not disclosed'}</p>
                            {#if application.quizResult}
                                <p><strong>Quiz Score:</strong> {application.quizResult.score}</p>
                            {/if}
                            <p><strong>Application Date:</strong> {new Date(application.createdAt).toLocaleDateString()}</p>
                        </div>
                        <div class="card-footer">
                            <a href={application.resumeUrl} target="_blank" class="resume-link">View Resume</a>
                        </div>
                    </div>
                {/each}
            </div>
        {/if}
    </div>
</main>

<style>
    main {
        margin-top: 30px;
        background: #f5f7fa;
        padding: 2rem;
        font-family: Arial, sans-serif;
        height: 100vh; /* Ensure it takes the full viewport height */
        overflow-y: auto; /* Allow vertical scrolling */
    }

    .page-container {
        max-width: 1200px;
        margin: 30px auto;
    }

    h1 {
        font-size: 2.5rem;
        margin-bottom: 1.5rem;
        color: #333;
        text-align: center;
    }

    .error {
        color: #ff5252;
        text-align: center;
        margin-top: 2rem;
    }

    .empty-message {
        text-align: center;
        color: #777;
        margin-top: 2rem;
        font-size: 1.2rem;
    }

    .applications-list {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 1.5rem;
    }

    .application-card {
        background: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        display: flex;
        flex-direction: column;
    }

    .card-header {
        padding: 1rem;
        background: #007bff;
        color: #fff;
        display: flex;
        justify-content: space-between;
        align-items: center;
        cursor: pointer;
    }

    .job-title {
        font-size: 1.25rem;
        margin: 0;
    }

    .status-pill {
        padding: 0.25rem 0.5rem;
        border-radius: 12px;
        font-size: 0.9rem;
        font-weight: bold;
        text-transform: uppercase;
    }

    .status-pill.pending {
        background: #ffc107;
        color: #fff;
    }

    .status-pill.approved {
        background: #28a745;
        color: #fff;
    }

    .status-pill.rejected {
        background: #dc3545;
        color: #fff;
    }

    .card-body {
        padding: 1rem;
        color: #555;
        flex-grow: 1;
    }

    .card-footer {
        padding: 1rem;
        background: #f8f9fa;
        text-align: right;
    }

    .resume-link {
        color: #007bff;
        text-decoration: none;
        font-weight: bold;
    }

    .resume-link:hover {
        text-decoration: underline;
    }
</style>

