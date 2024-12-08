<script>
    import { onMount } from 'svelte';
    import { user, verifyUser } from "$lib/stores/user.js";
    import { goto } from "$app/navigation";
    import JobCard from "$lib/JobCard.svelte";
    import AppBar from "$lib/AppBar.svelte";
    import Toast from "$lib/Toast.svelte";
    import {get} from "svelte/store";
    import {companyCache} from "../stores/companyCache.js";
    import axios from "axios";

    const API_URL = "http://localhost:8080/job-service/graphql";

    let savedOffers = [];
    let savedOffersCopy = [];
    let pendingRemovals = [];
    let error = '';
    let showToast = false;
    let toastMessage = "";
    let toastJobId;

    async function callGraphQL(query, variables = {}) {
        if (!verifyUser()) {
            goto('/login');
        }
        try {
            const response = await fetch(API_URL, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "Authorization": `Bearer ${$user.jwt}`,
                },
                body: JSON.stringify({query, variables}),
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

    async function fetchSavedOffers() {
        const query = `
        query {
            followedJobs {
                jobId
                title
                location
                salary
                companyId
                createdAt
            }
        }`;

        try {
            const result = await callGraphQL(query);

            if (result && result.followedJobs) {
                savedOffers = await Promise.all(result.followedJobs.map(async (job) => {
                    const companyDetails = await fetchCompanyDetails(job.companyId);
                    return {
                        ...job,
                        company: companyDetails
                    };
                }));
                savedOffersCopy = [...savedOffers];
            } else {
                console.error('GraphQL error:', result.errors);
                error = 'Could not load saved offers. Please try again later.';
            }
        } catch (err) {
            console.error('Failed to fetch saved offers:', err);
            error = 'Could not load saved offers. Please try again later.';
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

    function handleUnlike(jobId) {
        toastMessage = "Job removed. Undo?";
        toastJobId = jobId;
        showToast = true;

        // Find and store the full job object in pendingRemovals
        const jobToRemove = savedOffers.find(job => job.jobId === jobId);
        if (jobToRemove) {
            pendingRemovals.push(jobToRemove);
        }

        // Temporarily remove job from the UI
        savedOffers = savedOffers.filter(job => job.jobId !== jobId);
    }


    function cancelToast() {
        showToast = false;

        const restoredJobId = toastJobId;
        if (restoredJobId) {
            // Find the job in pendingRemovals with full data
            const jobToRestore = pendingRemovals.find(job => job.jobId === restoredJobId);
            if (jobToRestore) {
                pendingRemovals = pendingRemovals.filter(job => job.jobId !== restoredJobId);

                // Reinsert the job into savedOffers in the correct position
                const originalIndex = savedOffersCopy.findIndex(job => job.jobId === restoredJobId);
                savedOffers = [
                    ...savedOffers.slice(0, originalIndex),
                    jobToRestore,
                    ...savedOffers.slice(originalIndex),
                ];
            }
        }

        toastJobId = null;
    }


    async function confirmRemove() {
        const confirmedJobId = toastJobId;
        if (confirmedJobId) {
            // Remove the job from pendingRemovals
            pendingRemovals = pendingRemovals.filter(id => id !== confirmedJobId);

            // Backend request
            const query = `
        mutation RemoveFollowedJob($jobId: ID!) {
            removeFollowedJob(jobId: $jobId) {
                success
                message
            }
        }`;
            const variables = { jobId: confirmedJobId };

            try {
                const result = await callGraphQL(query, variables);

                if (!result?.removeFollowedJob?.success) {
                    console.error("Failed to remove job:", result?.removeFollowedJob?.message || "Unknown error");
                    // Optionally, restore the job in the UI if the backend request fails
                }
            } catch (err) {
                console.error("Error while removing job:", err);
            }
        }

        // Reset toast
        showToast = false;
        toastJobId = null;
    }


    onMount(fetchSavedOffers);
</script>

<AppBar/>

<div class="container">
    {#if savedOffers.length === 0 && !error}
        <p class="no-offers">You haven't saved any offers yet.</p>
    {:else}
        <div class="job-list-container">
            <ul class="job-list">
                {#each savedOffers as job}
                    <JobCard {job} isLiked={true} useToast={true} logoUrl={job.company.logoUrl} companyName={job.company.name} onUnlike={handleUnlike} />                {/each}
            </ul>
        </div>
    {/if}
</div>

{#if showToast}
    <Toast
            message={toastMessage}
            duration={3000}
            onCancel={cancelToast}
            onExpire={confirmRemove}
    />
{/if}

<style>
    .container {
        display: flex;
        justify-content: center;
        align-items: center;
        width: 100%;
        margin-top: 4rem;
    }

    .job-list-container {
        padding: 1rem;
        border-radius: 0.375rem;
        width: 70%;
        max-height: calc(100vh - 8rem);
        overflow-y: auto;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .job-list {
        display: flex;
        flex-direction: column;
        gap: 0;
        margin: 0;
        padding: 0;
    }

    .no-offers {
        color: #555;
        font-size: 1rem;
        margin-top: 1rem;
    }
</style>
