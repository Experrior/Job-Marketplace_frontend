<script>
    import { goto } from '$app/navigation';
    import { user } from "$lib/stores/user.js";

    function navigateToSettings(page) {
        goto(`/settings?tab=${page}`);
    }
    function handleLogout() {
        user.set(null);
        localStorage.removeItem('authToken');

        // Redirect to login page
        goto('/login');
    }

    function handleLogin() {
        goto('/login');
    }
</script>

<div class="app-bar">
    <div class="nav-links">
        <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
        {#if $user }
            {#if $user.role === 'RECRUITER'}
                <a href="/recruiter" class="app-name recruiter-link" aria-label="Jobs panel">My Jobs Panel</a>
            {/if}
        {/if}
        <a on:click={() => goto('/savedOffers')} class="app-link" aria-label="Saved Offers">Saved Offers</a>
        <a on:click={() => goto('/applications')} class="app-link" aria-label="My Applications">My Applications</a>
    </div>

    {#if $user }
        <!-- User Icon and Dropdown (Authenticated) -->
        <div class="user-icon-container">
            <div class="user-icon">
                {#if $user.profilePicture}
                    <img
                            src={$user.profilePicture}
                            alt="User Profile"
                            class="user-photo"
                    />
                {:else if $user.firstName && $user.lastName}
                    <div class="placeholder-photo">
                        <span>{$user.firstName.charAt(0)}{$user.lastName.charAt(0)}</span>
                    </div>
                {/if}
            </div>
            <!-- Dropdown menu -->
            <ul class="dropdown">
                <li on:click={() => navigateToSettings('userProfile')}>Profile</li>
                <li on:click={() => navigateToSettings('settings')}>Settings</li>
                <li on:click={() => navigateToSettings('cvCreator')}>CV Creator</li>
                <li on:click={() => navigateToSettings('cvOverview')}>CV Overview</li>
                <li on:click={handleLogout} class="logout">Logout</li>
            </ul>
        </div>
    {:else}
        <!-- Login Button (Unauthenticated) -->
        <button class="login-btn" on:click={handleLogin}>Login</button>
    {/if}

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

    .app-name,
    .app-link {
        color: #333333;
        text-decoration: none;
        font-size: 1rem;
        font-weight: 600;
        transition: color 0.2s ease-in-out;
        cursor: pointer;
    }

    .app-name:hover,
    .app-link:hover {
        color: #007bff;
    }

    .recruiter-link {
        font-size: 1rem;
        font-weight: 400;
    }

    .user-icon-container {
        position: relative;
        display: inline-block;
    }

    .user-icon-container:hover .dropdown {
        display: block; /* Keep dropdown visible on hover */
    }

    .user-icon {
        background: none;
        border: none;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        width: 40px;
        height: 40px;
        overflow: hidden;
    }

    .user-photo {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 50%;
    }

    .placeholder-photo {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #007bff;
        color: #fff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1rem;
        font-weight: bold;
    }

    .dropdown {
        position: absolute;
        top: 100%; /* Directly below the user icon */
        right: 0;
        background-color: #ffffff;
        border: 1px solid #e5e5e5;
        border-radius: 4px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        display: none; /* Hidden by default */
        list-style: none;
        margin: 0;
        padding: 0;
        z-index: 1000;
        width: 150px;
    }

    .dropdown li {
        padding: 0.75rem 1rem;
        cursor: pointer;
        font-size: 0.9rem;
        color: #333333;
        transition: background-color 0.3s ease-in-out, color 0.3s ease-in-out;
    }

    .dropdown li:hover {
        background-color: #f5f5f5;
        color: #007bff; /* Highlight text color */
    }

    .dropdown li.logout {
        color: #d9534f; /* Red for logout */
        font-weight: bold;
    }

    .dropdown li.logout:hover {
        background-color: #f8d7da; /* Light red background on hover */
        color: #c9302c; /* Darker red for logout text */
    }

    .login-btn {
        padding: 0.5rem 1rem;
        background-color: #758c96;
        color: #fff;
        border: none;
        border-radius: 4px;
        font-size: 1rem;
        cursor: pointer;
        transition: background-color 0.3s ease-in-out;
    }

    .login-btn:hover {
        background-color: #8697C4;
    }
</style>
