<script>
    import PersonalData from '$lib/PersonalData.svelte';
    import AccountInformation from '$lib/AccountInformation.svelte';
    import SavedOffers from '$lib/SavedOffers.svelte';
    import MyApplications from '$lib/MyApplications.svelte';
    import Educations from '$lib/Educations.svelte';
    import Experiences from '$lib/Experiences.svelte';
    import CVCreator from '$lib/CVCreator.svelte';
    import CVOverview from '$lib/CVOverview.svelte';
    import { goto } from '$app/navigation';
    import { onMount } from 'svelte';
    import { user } from "../../stores/user.js";
  import CvCreator from '../../lib/CVCreator.svelte';

    let currentPage = 'personalData';

    function handleLogout() {
        goto('/login');
    }

    function goToHome() {
        goto('/');
    }
</script>

<div class="app-bar">
    <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
    <button class="user-icon" on:click={goToHome} aria-label="Go to settings">
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <circle cx="12" cy="8" r="4" />
            <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
        </svg>
    </button>
</div>

<div class="settings-container">
    <!-- Sidebar with navigation links -->
    <aside class="sidebar">
        <h2>Settings</h2>
        <ul>
            <li on:click={() => currentPage = 'personalData'} class:selected={currentPage === 'personalData'}>
                Personal Data
            </li>
            <li on:click={() => currentPage = 'accountInformation'} class:selected={currentPage === 'accountInformation'}>
                Account Information
            </li>
            <li on:click={() => currentPage = 'educations'} class:selected={currentPage === 'educations'}>
                Educations
            </li>
            <li on:click={() => currentPage = 'experiences'} class:selected={currentPage === 'experiences'}>
                Experiences
            </li>
            <li on:click={() => currentPage = 'savedOffers'} class:selected={currentPage === 'savedOffers'}>
                Saved Offers
            </li>
            <li on:click={() => currentPage = 'myApplications'} class:selected={currentPage === 'myApplications'}>
                My Applications
            </li>
            <li on:click={() => currentPage = 'cvGenerator'} class:selected={currentPage === 'cvGenerator'}>
                CV Generator
            </li>
            <li on:click={() => currentPage = 'cvOverview'} class:selected={currentPage === 'cvOverview'}>
                CV Overview
            </li>
        </ul>

        <!-- Log Out button at the bottom of the sidebar -->
        <button class="logout-btn" on:click={handleLogout}>Log Out</button>
    </aside>

    <!-- Content area to display the selected subpage -->
    <main class="content">
        {#if currentPage === 'personalData'}
            <PersonalData />
        {:else if currentPage === 'accountInformation'}
            <AccountInformation />
        {:else if currentPage === 'educations'}
            <Educations />
        {:else if currentPage === 'experiences'}
            <Experiences />
        {:else if currentPage === 'savedOffers'}
            <SavedOffers />
        {:else if currentPage === 'myApplications'}
            <MyApplications />
        {:else if currentPage === 'cvGenerator'}
            <CvCreator />
        {:else if currentPage === 'cvOverview'}
            <CVOverview />
        {/if}
    </main>
</div>

<style>
    .settings-container {
        display: flex;
        height: calc(100vh - 60px);
        margin-top: 60px;
    }

    .sidebar {
        width: 200px;
        background-color: #f5f5f5;
        padding: 1rem;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        border-right: 1px solid #ddd;
    }

    h2 {
        font-size: 1.2rem;
        margin-bottom: 1rem;
    }

    ul {
        list-style: none;
        padding: 0;
    }

    li {
        padding: 0.5rem 0;
        cursor: pointer;
    }

    li.selected {
        font-weight: bold;
        color: #007bff;
    }

    .logout-btn {
        background-color: #d9534f;
        color: white;
        padding: 0.5rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        margin-top: auto;
    }

    .content {
        flex: 1;
        padding: 2rem;
        overflow-y: auto;
    }
</style>
