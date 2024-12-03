<script>
    import { onMount } from "svelte";
    import axios from "axios";
    import { user, verifyUser } from "$lib/stores/user";

    let cvs = [];

    onMount(async () => {
        verifyUser();
        const query = `query {
            userResumes {
                resumeId
                resumeName
                s3ResumePath
                resumeUrl
                createdAt
            }
        }`;

        try {
            const response = await axios.post(
                "http://localhost:8080/user-service/graphql",
                { query: query },
                {
                    headers: {
                        Authorization: "Bearer " + $user.jwt,
                        "Content-Type": "application/json",
                    },
                }
            );
            console.log("Response resumes:", response.data.data.userResumes);
            cvs = response.data.data.userResumes;
        } catch (error) {
            console.error(error);
        }
    });

    function viewCV(resumeUrl) {
        if (resumeUrl) {
            window.open(resumeUrl, "_blank");
        } else {
            console.error("No resume URL available for this CV.");
        }
    }

    async function deleteCV(resumeId) {
        const confirmed = confirm("Are you sure you want to delete this CV?");
        if (!confirmed) return;

        try {
            const response = await axios.post(
                "http://localhost:8080/user-service/resume/remove",
                null,
                {
                    headers: {
                        Authorization: "Bearer " + $user.jwt,
                        "Content-Type": "application/json",
                    },
                    params: {
                        resumeId: resumeId,
                    },
                }
            );
            console.log("Delete response:", response);

            // Remove the deleted CV from the list
            cvs = cvs.filter((cv) => cv.resumeId !== resumeId);
        } catch (error) {
            console.error("Error deleting CV:", error);
        }
    }
</script>

<div class="cv-overview-container">
    <h2>My Resumes</h2>
    {#if cvs.length > 0}
        <ul class="cv-list">
            {#each cvs as cv}
                <li class="cv-item">
                    <div class="cv-info">
                        <strong>{cv.resumeName}</strong>
                        <p>Date Created: {cv.createdAt}</p>
                    </div>
                    <div class="cv-actions">
                        <button class="btn view-btn" on:click={() => viewCV(cv.resumeUrl)}>View</button>
                        <button class="btn delete-btn" on:click={() => deleteCV(cv.resumeId)}>Delete</button>
                    </div>
                </li>
            {/each}
        </ul>
    {:else}
        <p>No CVs available.</p>
    {/if}
</div>

<style>
    .cv-overview-container {
        max-width: 800px;
        margin: 0 auto;
    }

    h2 {
        margin-bottom: 1.5rem;
        color: #333;
    }

    .cv-list {
        list-style: none;
        padding: 0;
    }

    .cv-item {
        display: flex;
        justify-content: space-between;
        background-color: #f9f9f9;
        padding: 1rem;
        border-radius: 5px;
        margin-bottom: 0.5rem;
        align-items: center;
    }

    .cv-info {
        flex: 1;
    }

    .cv-actions button {
        margin-left: 0.5rem;
    }

    .view-btn {
        background-color: #007bff;
        color: #fff;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .delete-btn {
        background-color: #d9534f;
        color: #fff;
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
</style>
