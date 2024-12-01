// export async function load({ params, parent }) {
//   console.log('Params:', params); // Logs route params, e.g., { jobId: '123' }
//     console.log(parent)
//   const parentData = await parent();
//   console.log('Parent Data:', parentData); // Logs data returned from parent load function

//   const jobs = parentData.jobs || []; // Extract jobs from parent
//   const job = jobs.find((job) => job.jobId === params.jobId);

//   if (!job) {
//     console.error('Job not found for ID:', params.jobId);
//     throw new Error('Job not found');
//   }

//   console.log('Selected Job:', job);
//   return { props: { job } };
// }
