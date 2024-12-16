<script>
  import { onMount } from "svelte";


    onMount(async()=> {
        const query = `query {
            userApplications {
                applicationId
                userId
                resumeUrl
                job {
                jobId
                title
                location
                salary
                createdAt
                }
                createdAt
                status
                quizResult{
                    score
                }
            }
            }
        `
        const response = fetch()

    })
</script>

<div>
    <h2>My Applications</h2>
    <p>This is the My Applications page.</p>
</div>
