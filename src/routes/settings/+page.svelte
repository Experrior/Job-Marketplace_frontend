<script>
    import PersonalData from '$lib/PersonalData.svelte';
    import AccountInformation from '$lib/AccountInformation.svelte';
    import SavedOffers from '$lib/SavedOffers.svelte';
    import MyApplications from '$lib/MyApplications.svelte';
    import CVCreator from '$lib/CVCreator.svelte';
    import { goto } from '$app/navigation';
    import FaRegUserCircle from 'svelte-icons/fa/FaRegUserCircle.svelte'
    import { user } from "$lib/stores/user.js";
  import AppBar from '../../lib/AppBar.svelte';
  import ChatBox from '../../lib/ChatBox.svelte';
  import CvOverview from '../../lib/CVOverview.svelte';

    //todo add settings
    let offers_notification;
    let newsletter_notification;
    let recruiter_messages;
    let push_notification;
    let currentPage = 'userProfile';
    function handleLogout() {
        goto('/login');
    }

    function goToHome() {
        goto('/');
    }
</script>


<AppBar/>

<div class="settings-container">

    <aside class="sidebar">
        <h2>Settings</h2>
        <ul>
            <li on:click={() => currentPage = 'userProfile'} class:selected={currentPage === 'userProfile'}>
                Your Profile
            </li>
            <li on:click={() => currentPage = 'settings'} class:selected={currentPage === 'settings'}>
                Settings
            </li>
            <li on:click={() => currentPage = 'savedOffers'} class:selected={currentPage === 'savedOffers'}>
                Saved Offers
            </li>
            <li on:click={() => currentPage = 'myApplications'} class:selected={currentPage === 'myApplications'}>
                My Applications
            </li>
            <!-- TODO UNCOMMENT IF-->
            <!-- {#if $user.role === 'applicant'} -->
            <li on:click={() => currentPage = 'cvCreator'} class:selected={currentPage === 'cvCreator'}>
                CV Creator
            </li>
            <li on:click={() => currentPage = 'cvOverview'} class:selected={currentPage === 'cvOverview'}>
                CV Overview
            </li>
            <!-- {/if} -->
        </ul>
        <ChatBox/>
        <button class="logout-btn" on:click={handleLogout}>Log Out</button>
    </aside>

    <main class="content">
        {#if currentPage === 'userProfile'}
            <PersonalData />
        {:else if currentPage === 'settings'}
            <AccountInformation />
        {:else if currentPage === 'savedOffers'}
            <SavedOffers />
        {:else if currentPage === 'myApplications'}
            <MyApplications />
        {:else if currentPage === 'cvCreator'}
        <CVCreator />
        {:else if currentPage === 'cvOverview'}
        <CvOverview />
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
