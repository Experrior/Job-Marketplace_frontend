<!-- <script>
  export let data;
  let jobs = data?.jobs || []; // Fallback to empty array if no data
</script>




   <script>
	/** @type {{ data: import('./$types').PageData }} */
	let { data } = $props();
    console.log(data.jobs.content)
    let jobs = data.jobs.content
</script>

<h1>Job Listings</h1>
  
<ul>
  {#each jobs as job}
    <li>
      <a href={`/testing-eco/${job.jobId}`}>
        {job.title} at {job.companyName} ({job.location})
      </a>
    </li>
  {/each}
</ul> -->