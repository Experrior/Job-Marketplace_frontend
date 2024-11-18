import { writable } from 'svelte/store';
import { browser } from '$app/environment';

// Initial empty array for jobs
const initialJobs = [];

// Create the writable store
const jobs = writable(initialJobs);

// Only run this in the browser
if (browser) {
  // Load jobs from localStorage if available
  const storedJobs = localStorage.getItem('jobs');
  if (storedJobs) {
    try {
      jobs.set(JSON.parse(storedJobs));
    } catch (error) {
      console.error('Failed to parse jobs from localStorage:', error);
    }
  }

  // Subscribe to store changes and update localStorage
  jobs.subscribe((value) => {
    localStorage.setItem('jobs', JSON.stringify(value));
  });
}

export default jobs;
