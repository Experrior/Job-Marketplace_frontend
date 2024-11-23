// /** @type {import('./$types').PageLoad} */
// export async function load({ params }) {
//   const slug = params.slug;

//   // Define the job object
//   const job = {
//     id: slug, // Use the 'slug' as 'id' if applicable
//     title: 'Senior Software Engineer',
//     company: 'Tech Corp',
//     companyLogo: '/job_logos/logo1.png', // Update the path as needed
//     location: 'San Francisco, CA',
//     category: 'Engineering',
//     tags: ['Python', 'JavaScript', 'Docker'],
//     description: 'Detailed job description goes here.',
//   };

//   // Optional: Handle cases where 'job' might not exist
//   if (!job) {
//     // Throw an error to display a 404 page
//     // throw error(404, 'Job not found');
//   }

//   // Return the 'job' object
//   return { job };
// }
