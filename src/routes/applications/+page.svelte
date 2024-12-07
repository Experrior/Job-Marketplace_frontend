<script>
    import { onMount } from 'svelte';
    import { user, verifyUser } from "$lib/stores/user.js";
    import { goto } from "$app/navigation";
    import AppBar from "$lib/AppBar.svelte";
    import axios from "axios";
    import { companyCache } from "../../stores/companyCache.js";
    import { get } from 'svelte/store';


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

    async function fetchCompanyDetails(companyId) {
        const cache = get(companyCache);
        if (cache[companyId]) {
            return cache[companyId];
        }

        try {
            const response = await axios.get(`http://localhost:8080/user-service/getCompanyById`, {
                params: { companyId }
            });
            if (response.status === 200) {
                companyCache.update(cache => {
                    cache[companyId] = response.data;
                    return cache;
                });
                return response.data;
            } else {
                console.error('Error fetching company details:', response.status, response.statusText);
                return null;
            }
        } catch (error) {
            console.error('Network or server error:', error);
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
            if (result && result.userApplications) {
                applications = await Promise.all(result.userApplications.map(async (application) => {
                    const companyDetails = await fetchCompanyDetails(application.job.companyId);
                    return {
                        ...application,
                        job: {
                            ...application.job,
                            company: companyDetails
                        }
                    };
                }));
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
                            {#if application.job.company?.logoUrl}
                                <img src={application.job.company.logoUrl} alt="{application.job.company.name} logo" class="company-logo" />
                            {/if}
                            <div class="company-info">
                                <p><strong>Company:</strong> {application.job.company?.name || 'Unknown'}</p>
                            </div>
                            <p><strong>Location:</strong> {application.job.location || 'Not specified'}</p>
                            <p><strong>Work Type:</strong> {application.job.workLocation || 'Not specified'}</p>
                            <p><strong>Employment Type:</strong> {application.job.employmentType || 'Not specified'}</p>
                            <p><strong>Salary:</strong> {application.job.salary ? `$${application.job.salary.toLocaleString()}` : 'Not disclosed'}</p>
                            {#if application.quizResult}
                                <p><strong>Quiz Score:</strong> {application.quizResult.score}</p>
                            {/if}
                            <p><strong>Application Date:</strong> {new Date(application.createdAt).toLocaleDateString()}</p>
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
        position: relative; /* Ensures absolute positioning works for child elements */
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
        position: relative; /* For the resume link positioning */
    }

    .company-info {
        margin-bottom: 1rem;
    }

    .company-logo {
        position: absolute;
        top: 16px;
        right: 16px;
        width: 100px;
    }

    .card-footer {
        padding: 1rem;
        background: #f8f9fa;
        text-align: right;
    }

    .resume-link {
        position: absolute;
        bottom: 16px;
        right: 16px; /* Adjusted to align near the application date */
        color: #007bff;
        text-decoration: none;
        font-weight: bold;
        transform: translateY(-20px); /* Moves the link higher for alignment */
    }

    .resume-link:hover {
        text-decoration: underline;
    }
</style>

