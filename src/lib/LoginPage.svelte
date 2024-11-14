<script>
    import { onMount } from 'svelte';
    import { goto } from '$app/navigation'; // SvelteKit's navigation helper
    import ImageRotator from '$lib/ImageRotator.svelte'; // Ensure this component exists
    import SwitchButton from './SwitchButton.svelte';
    import { accessToken, refreshToken, userId } from '$lib/authStore';
    import axios from 'axios';
    import { auth } from '../stores/auth';

    let isApplicant = true;
    let isLogin = true;
    let formData = { email: '', password: '', confirmPassword: '' };
    let errorMessage = '';
    let isCustomCompany = false;

    // Toggle between login and register modes
    function toggleForm() {
        isLogin = !isLogin;
        formData = { email: '', password: '', confirmPassword: '' };
        errorMessage = '';
    }

    // Submit handler for login/register
    async function handleSubmit() {
        if (!isLogin && formData.password !== formData.confirmPassword) {
            errorMessage = 'Passwords do not match.';
            return;
        }

        const url = !isLogin ? 'http://localhost:8080/user-service/register/applicant' : 'http://localhost:8080/user-service/login';
        var response = null
        auth.setRole(isApplicant ? 'applicant' : 'recruiter')
        try {

            if (isLogin) {
            // Login request with axios
            response = await axios.post(url, {
                email: formData.email,
                password: formData.password
            });
        } else {
            // Registration request with axios
            response = await axios.post(url, {
                email: formData.email,
                firstName: formData.firstName,
                lastName: formData.lastName,
                password: formData.password,
                confirmPassword: formData.confirmPassword
            });
        }
            console.log(response.class)
            const data = await response.json();

            if (response.ok) {
                // accessToken.set(data.accessToken);
                // refreshToken.set(data.refreshToken);
                userId.set(formData.email)
                goto('/');
            } else {
                userId.set(formData.email)
                goto('/');
                errorMessage = data.message || 'An error occurred. Please try again.';
            }
        } catch (error) {
            userId.set(formData.email)
            console.log(error.status)
            console.log(error.response.data)
            console.error('Error during login:', error);
            // errorMessage = error.response.data
            goto('/');
        }
    }


        function handleCompanyChange(event) {
        if (event.target.value === 'other') {
            isCustomCompany = true;
            formData.company = ''; // Clear the current company selection
        } else {
            isCustomCompany = false;
            formData.company = event.target.value;
        }
    }
</script>



<div class="container">
    <!-- Left side for the rotating image -->
    <div class="image-side">
        <ImageRotator />
    </div>


    <!-- Right side for the form -->
    <div class="form-side">
        <div class="form-container">
            <h1>{isLogin ? 'Login' : 'Register'}</h1>


            <!-- {#if !isLogin} -->
          <!-- Centered Switch Button -->
            <div class="switch-button-wrapper">
                <SwitchButton bind:isApplicant leftText="Applicant" rightText="Recruiter" />
<!--                 <p>Selected role: {isApplicant ? "Applicant" : "Recruiter"}</p> -->
            </div>
            <!-- {/if} -->

            <input type="email" placeholder="Email" bind:value={formData.email} required />



            {#if !isLogin}
            <input type="text" placeholder="First Name" bind:value={formData.firstName} required />
            <input type="text" placeholder="Last Name" bind:value={formData.lastName} required />
           {/if}

                       <!-- Password input -->
            <input type="password" placeholder="Password" bind:value={formData.password} required />

            {#if !isLogin}
                        <input type="password" placeholder="Repeat Password" bind:value={formData.confirmPassword} required />


            {/if}

            {#if !isLogin && !isApplicant}
            <!-- New dropdown field for company selection -->
<!--            <select bind:value={formData.company} required>
                <option value="" disabled selected>Select Company</option>
                <option value="TechCorp">TechCorp</option>
                <option value="DesignPro">DesignPro</option>
                <option value="MarketMasters">MarketMasters</option>
                <option value="FinanceGurus">FinanceGurus</option>
            </select>-->

                        <!-- Dropdown for selecting a company or entering a custom one -->
            <select on:change={handleCompanyChange} required>
                <option value="" disabled selected>Select Company</option>
                <option value="TechCorp">TechCorp</option>
                <option value="DesignPro">DesignPro</option>
                <option value="MarketMasters">MarketMasters</option>
                <option value="FinanceGurus">FinanceGurus</option>
                <option value="other">Other</option>
            </select>

            <!-- Custom company input field, shown only if "Other" is selected -->
            {#if isCustomCompany}
                <input
                    type="text"
                    placeholder="Enter custom company name"
                    bind:value={formData.company}
                    required
                />
            {/if}

            {/if}



            <!-- Submit button -->
            <button on:click={handleSubmit}>
                {isLogin ? 'Login' : 'Register'}
            </button>

            <!-- Error message display -->
            {#if errorMessage}
                <p class="error-message">{errorMessage}</p>
            {/if}

            <!-- Toggle between login/register -->
            <button class="button-toggle" on:click={toggleForm}>
                {isLogin ? 'Need an account? Register' : 'Have an account? Login'}
            </button>
        </div>
    </div>
</div>

<style>
    .container {
        display: flex;
        height: 100vh;
    }

    .image-side {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #f0f0f0;
    }

        /* Centering the Switch Button and text below the heading */
    .switch-button-wrapper {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-bottom: 1rem;
    }

    .form-side {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: white;
    }

    .form-container {
        max-width: 400px;
        width: 100%;
        padding: 2rem;
        text-align: center;
    }

    input[type="email"], input[type="password"], input[type="text"] {
        width: 100%;
        padding: 0.5rem;
        margin-bottom: 1rem;
        border-radius: 4px;
        border: 1px solid #ccc;
    }

    button {
        width: 100%;
        padding: 0.75rem;
        margin-top: 1rem;
        border: none;
        border-radius: 4px;
        background-color: #007bff;
        color: white;
        cursor: pointer;
    }

    .button-toggle {
        background: none;
        color: #007bff;
        margin-top: 1rem;
        cursor: pointer;
    }

    .error-message {
        color: red;
        margin-top: 1rem;
    }
</style>
