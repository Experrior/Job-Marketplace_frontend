<script>
    import LoginPage from '$lib/LoginPage.svelte';
    import JobList from './JobList.svelte';
    import CategoryFilter from './CategoryFilter.svelte';
    import ChatBox from './ChatBox.svelte';
    import { goto } from '$app/navigation';

    let searchQuery = '';
    let categories = ['Engineering', 'Design', 'Marketing', 'Sales', 'Finance'];
    let selectedCategory = '';

    let jobOffers = [
        {
  title: 'Senior Software Engineer',
  company: 'Tech Corp',
  companyLogo: '/logos/logo1.png', // or null if no logo
  location: 'San Francisco, CA',
  category: 'Engineering',
  tags: ['Python', 'JavaScript', 'Docker']
},
{
  title: 'Senior Software Engineer',
  company: 'Tech Corp',
  companyLogo: '/logos/logo1.png', // or null if no logo
  location: 'San Francisco, CA',
  category: 'Engineering',
  tags: ['Python', 'JavaScript', 'Docker']
},
{
  title: 'Senior Software Engineer',
  company: 'Tech Corp',
  companyLogo: '/logos/logo1.png', // or null if no logo
  location: 'San Francisco, CA',
  category: 'Engineering',
  tags: ['Python', 'JavaScript', 'Docker']
},
{
  title: 'Senior Software Engineer',
  company: 'Tech Corp',
  companyLogo: '/logos/logo1.png', // or null if no logo
  location: 'San Francisco, CA',
  category: 'Engineering',
  tags: ['Python', 'JavaScript', 'Docker']
},
{
  title: 'Senior Software Engineer',
  company: 'Tech Corp',
  companyLogo: '/logos/logo1.png', // or null if no logo
  location: 'San Francisco, CA',
  category: 'Engineering',
  tags: ['Python', 'JavaScript', 'Docker']
},
{
  title: 'Senior Software Engineer',
  company: 'Tech Corp',
  companyLogo: '/logos/logo1.png', // or null if no logo
  location: 'San Francisco, CA',
  category: 'Engineering',
  tags: ['Python', 'JavaScript', 'Docker']
},
    ];

    let filteredJobs = jobOffers;

    function filterJobs() {
        filteredJobs = jobOffers.filter(job => {
            return (
                job.title.toLowerCase().includes(searchQuery.toLowerCase()) &&
                (selectedCategory === '' || job.category === selectedCategory)
            );
        });
    }

    $: filterJobs();
</script>

<!-- <div class="overlay">
        <a href="/" class="app-name" aria-label="Go to home">Job Market</a>

    <button class="user-icon" on:click={() => goto('/settings')} aria-label="Go to settings">

        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <circle cx="12" cy="8" r="4" />
            <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
        </svg>
    </button>
    <a href="/settings" aria-label="Go to settings" class="user-icon">
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <circle cx="12" cy="8" r="4" />
            <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
        </svg>
    </a>
</div> -->


<div class="app-bar">
    <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
    <button class="user-icon" on:click={() => goto('/settings')} aria-label="Go to settings">
        <!-- User icon as SVG -->
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <circle cx="12" cy="8" r="4" />
            <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
        </svg>
    </button>
    <button class="quiz-icon" on:click={() => goto('/quizCreate')} aria-label="Go to quizCreate page">
        <!-- Quiz icon as SVG -->
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <rect x="4" y="4" width="16" height="16" rx="4" />
            <path d="M7 8h10v2H7zm0 4h6v2H7zm0 4h10v2H7z" />
        </svg>
    </button>
    <button class="quiz-icon" on:click={() => goto('/quizTake')} aria-label="Go to quizTake page">
        <!-- Quiz icon as SVG -->
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <rect x="4" y="4" width="16" height="16" rx="4" />
            <path d="M7 8h10v2H7zm0 4h6v2H7zm0 4h10v2H7z" />
        </svg>
    </button>
    <button class="test-icon" on:click={() => goto('/test')} aria-label="Go to test page">
        <!-- Test icon as SVG -->
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <rect x="4" y="4" width="16" height="16" rx="4" />
            <path d="M7 8h10v2H7zm0 4h6v2H7zm0 4h10v2H7z" />
        </svg>
    </button>
    <button class="test-icon" on:click={() => goto('/analytics')} aria-label="Go to analytics page">
        <!-- Test icon as SVG -->
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <rect x="4" y="4" width="16" height="16" rx="4" />
            <path d="M7 8h10v2H7zm0 4h6v2H7zm0 4h10v2H7z" />
        </svg>
    </button>
</div>


<main>
    <h1>Find Your Next Job</h1>
    <input
        type="text"
        placeholder="Search for jobs..."
        bind:value={searchQuery}
        on:input={filterJobs}
    />
    <CategoryFilter {categories} bind:selectedCategory={selectedCategory} />
    <JobList {filteredJobs} />
     <ChatBox />
</main>

<style>
    .app-bar {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 60px;
        background-color: #007bff;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 1rem;
        color: white;
        z-index: 1000;
    }

    .app-name {
        font-size: 1.5rem;
        font-weight: bold;
        color: white;
        text-decoration: none;
    }

    .user-icon {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #0056b3;
        border-radius: 50%;
        border: none;
        cursor: pointer;
        color: white;
    }

    .overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        background: rgba(0, 0, 0, 0.6);
        padding: 1rem;
        display: flex;
        align-items: center;
        justify-content: flex-start;
    }

    .overlay a {
        color: white;
        text-decoration: none;
        padding: 0.5rem 1rem;
        background-color: #007bff;
        border-radius: 4px;
    }

    main {
        margin-top: 60px; /* Add space to avoid content hidden by overlay */
        max-width: 800px;
        margin: 60px auto;
        padding: 2rem;
    }

    h1 {
        text-align: center;
        margin-bottom: 1rem;
    }

    input[type="text"] {
        width: 100%;
        padding: 0.5rem;
        margin-bottom: 1rem;
        border-radius: 4px;
        border: 1px solid #ccc;
    }

    .overlay {
        position: fixed;
        top: 0;
        right: 0;
        padding: 1rem;
        background: rgba(0, 0, 0, 0.6);
        z-index: 1000;
        display: flex;
        justify-content: flex-end;
        width: 100%;
    }
</style>
