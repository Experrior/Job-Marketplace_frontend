<script>
    import { onMount } from 'svelte';
    import {user, verifyUser} from "$lib/stores/user.js";
    import {goto} from "$app/navigation";
    import JobCard from "$lib/JobCard.svelte";
    import AppBar from "$lib/AppBar.svelte";

    const API_URL = "http://localhost:8080/job-service/graphql";

    let savedOffers = [];
    let error = '';

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

    async function fetchSavedOffers() {
        const query = `
        query {
            followedJobs {
                jobId
                title
                location
                salary
                createdAt
            }
        }
    `;

        try {
            const result = await callGraphQL(query);

            if (result && result.followedJobs) {
                savedOffers = result.followedJobs;
            } else {
                console.error('GraphQL error:', result.errors);
                error = 'Could not load saved offers. Please try again later.';
            }
        } catch (err) {
            console.error('Failed to fetch saved offers:', err);
            error = 'Could not load saved offers. Please try again later.';
        }
    }


    onMount(fetchSavedOffers);
</script>

<AppBar />

<div class="container">
    {#if savedOffers.length === 0 && !error}
        <p class="no-offers">You haven't saved any offers yet.</p>
    {:else}
        <div class="job-list-container">
            <ul class="job-list">
                {#each savedOffers as job}
                    <JobCard {job} isLiked={true} />
                {/each}
            </ul>
        </div>
    {/if}
</div>

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
        max-height: calc(100vh - 8rem); /* Dynamic max-height relative to viewport */
        overflow-y: auto; /* Enable vertical scrolling */
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
