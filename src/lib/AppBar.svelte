<script>
    import { goto } from '$app/navigation';
    import { user } from "$lib/stores/user.js";
    import FaRegUserCircle from 'svelte-icons/fa/FaRegUserCircle.svelte';
</script>

<div class="app-bar">
    <div class="nav-links">
        <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
        {#if $user.role === 'RECRUITER'}
            <a href="/recruiter" class="app-name recruiter-link" aria-label="Jobs panel">My Jobs Panel</a>
        {/if}
    </div>
    <div class="user-icon" on:click={() => goto('/settings')} role="button" aria-label="Settings">
        <FaRegUserCircle size="24"/>
    </div>
</div>

<style>
    .app-bar {
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1000;
        display: flex;
        align-items: center;
        justify-content: space-between;
        background-color: #ffffff;
        border-bottom: 1px solid #e5e5e5;
        padding: 0.75rem 1.5rem;
        box-sizing: border-box;
    }

    .nav-links {
        display: flex;
        gap: 1.5rem;
    }

    .app-name {
        color: #333333;
        text-decoration: none;
        font-size: 1.25rem;
        font-weight: 600;
        transition: color 0.2s ease-in-out;
    }

    .app-name:hover {
        color: #758c96;
    }

    .recruiter-link {
        font-size: 1rem;
        font-weight: 400;
    }

    .user-icon {
        background: none;
        border: none;
        cursor: pointer;
        color: #333333;
        display: flex;
        align-items: center;
        justify-content: center;
        transition: color 0.2s ease-in-out;
    }

    .user-icon:hover {
        color: #007bff;
    }
</style>
