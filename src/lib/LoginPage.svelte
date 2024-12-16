<script>
    import { goto } from '$app/navigation';
    import ImageRotator from '$lib/ImageRotator.svelte';
    import axios from 'axios';
    import { user } from "$lib/stores/user.js";
    import { onMount } from 'svelte';
    import RegistrationSuccess from './RegistrationSuccess.svelte';


    const apiGateway = import.meta.env.VITE_GATEWAY_URL;
    console.log("USING GATEWAY:", apiGateway);

    let errors = {};
    let isApplicant = true;
    let isLogin = true;
    let loginFormData = { 
        email: '', password: '', };
    let registerFormData = {
        email: '',
        firstName: '',
        lastName: '',
        password: '',
        confirmPassword: '',
        company: ''
    }
    let errorMessage = '';
    let emailVerified = false;
    let awaitingApproval = false;
    let companyVerified = false
    let registrationSuccess = false;

    function toggleForm() {
        isLogin = !isLogin;
        errorMessage = '';

    }
    let companies = [];
    onMount(async () => {
        const urlParams = new URLSearchParams(window.location.search);

        emailVerified = urlParams.get('emailVerified') === 'true';
        awaitingApproval = urlParams.get('awaitingApproval') === 'true';
        companyVerified = urlParams.get('companyVerified') === 'true';

        const res = await axios.get(`${apiGateway}/user-service/getCompanies`);
        companies = res.data.map(comp => comp.name).sort();
        registerFormData.company = companies[0];
    });

    async function handleSubmit() {
        errors = {};
        errorMessage = '';
        if (!isLogin && registerFormData.password !== registerFormData.confirmPassword) {
            errorMessage = 'Passwords do not match.';
            return;
        }
        let role = isApplicant ? 'applicant' : 'recruiter';
        const url = !isLogin ? `${apiGateway}/user-service/register/` + role : `${apiGateway}/user-service/login`;

        var response = null;
        try {
            if ($user) {
                $user.username = loginFormData.email;
            }
            if (isLogin) {
                response = await axios.post(url, loginFormData);

                if (response && response.status == 200) {
                    localStorage.setItem('jwt', response.data.accessToken);

                    localStorage.setItem('jwt_expiration', Date.now() + 8 * 60 * 60 * 1000);

                    let profilePicture = '';
                    try {
                        const profileData = await fetchUserProfilePicture();
                        profilePicture = profileData.profilePicture;
                    } catch (profileError) {
                        console.error('Error fetching profile picture:', profileError);
                    }
                    user.set({
                        email: loginFormData.email,
                        jwt: response.data.accessToken,
                        role: response.data.role,
                        firstName: response.data.firstName,
                        lastName: response.data.lastName,
                        profilePicture: profilePicture,
                        refreshToken: response.data.refreshToken,
                        isAuthenticated: true,
                        userId: response.data.userId
                    });
                    goto('/');
                } else {
                    errors = response.data;
                    errorMessage = response.data.message || 'An error occurred. Please try again.';
                }
            } else {
                let tempCopy = {};
                if (isApplicant) {
                    tempCopy = Object.fromEntries(
                        Object.entries(registerFormData).filter(([key]) => key !== 'company')
                    );
                } else {
                    tempCopy = registerFormData;
                }
                response = await axios.post(url, tempCopy);
                registrationSuccess = true;
            }

            if (response && response.ok) {
                if ($user) {
                    $user.username = loginFormData.email;
                    $user.jwt = response.data.accessToken;
                }
            } else {
                errorMessage = response.data.message || 'An error occurred. Please try again.';
            }
        } catch (error) {
            console.log(error.status);
            console.log(error);
            if (error.response) {
                errors = error.response.data;
                errorMessage = error.response.data.message || 'An error occurred. Please try again.';
            }
        }
    }

    async function fetchUserProfilePicture() {
        const query = `
            query {
                currentUserProfile {
                    profilePictureUrl
                }
            }
        `;
        try {
            const response = await axios.post(`${apiGateway}/user-service/graphql`, { query }, {
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${localStorage.getItem('jwt')}`
                }
            });

            if (response.data && response.data.data && response.data.data.currentUserProfile) {
                return {
                    profilePicture: response.data.data.currentUserProfile.profilePictureUrl
                };
            } else {
                throw new Error('Failed to fetch profile picture');
            }
        } catch (error) {
            console.error('Error fetching profile picture:', error);
            throw error;
        }
    }

    function handleCompanyChange(event) {
        registerFormData.company = event.target.value;
    }

    let leftText = "Applicant";
    let rightText = "Recruiter";

    function toggle() {
        isApplicant = !isApplicant;
        errors = {};
        errorMessage = '';
    }

</script>

<div class="container">

    <div class="image-side">
        <ImageRotator />
    </div>

    <div class="form-side">
        <div class="form-container">
            {#if registrationSuccess}
                <RegistrationSuccess
                        message="Registration Successful!"
                        additionalInfo="Check your email to verify your account." />
                <button class="button-toggle" on:click={registrationSuccess=false}>
                    Go back to login
                </button>
            {:else}
                <h1>{isLogin ? 'Login' : 'Register'}</h1>

                {#if !isLogin}
                    <div class="switch-button-wrapper">
                        <div class="switch-button" on:click={toggle}>
                            <div class="option" class:selected={isApplicant}>{leftText}</div>
                            <div class="option" class:selected={!isApplicant}>{rightText}</div>
                        </div>
                    </div>
                {/if}

                <!-- Registration Form -->
                {#if !isLogin}
                    {#if errors.email}
                        <div class="error">{errors.email}</div>
                    {/if}
                    <input type="email" placeholder="Email" bind:value={registerFormData.email} required />

                    {#if errors.firstName}
                        <div class="error">{errors.firstName}</div>
                    {/if}
                    <input type="text" placeholder="First Name" bind:value={registerFormData.firstName} required />

                    {#if errors.lastName}
                        <div class="error">{errors.lastName}</div>
                    {/if}
                    <input type="text" placeholder="Last Name" bind:value={registerFormData.lastName} required />

                    {#key errors}
                        {#if errors.password}
                            <div class="error">{errors.password}</div>
                        {/if}
                    {/key}
                    <input type="password" placeholder="Password" bind:value={registerFormData.password} required />
                    <input type="password" placeholder="Repeat Password" bind:value={registerFormData.confirmPassword} required />

                    {#if !isApplicant}
                        <div class="company-selection">
                            <h4>Company:</h4>
                            <select on:change={handleCompanyChange} required>
                                {#each companies as company}
                                    <option value={company}>{company}</option>
                                {/each}
                            </select>
                        </div>
                    {/if}

                {:else}
                    <!-- Login Form -->
                    {#if emailVerified && awaitingApproval}
                        <div class="confirmation-message">
                            Your email has been verified. Please wait for your company's approval before logging in.
                        </div>

                    {:else if emailVerified}
                        <div class="confirmation-message">
                            Your email has been successfully verified. You can now log in.
                        </div>
                    {:else if companyVerified}
                        <div class="confirmation-message">
                            Your company has been successfully verified.
                        </div>
                    {/if}

                    {#if errors.email}
                        <div class="error">{errors.email}</div>
                    {/if}
                    <input type="email" placeholder="Email" bind:value={loginFormData.email} required />

                    {#if errors.password}
                        <div class="error">{errors.password}</div>
                    {/if}
                    <input type="password" placeholder="Password" bind:value={loginFormData.password} required />
                {/if}

                <button on:click={handleSubmit}>
                    {isLogin ? 'Login' : 'Register'}
                </button>

                {#if errorMessage}
                    <p class="error-message">{errorMessage}</p>
                {/if}

                <button class="button-toggle" on:click={toggleForm}>
                    {isLogin ? 'Need an account? Register' : 'Have an account? Login'}
                </button>

                {#if !isApplicant && !isLogin}
                    <button class="button-toggle" on:click={() => goto('/register-company')}>
                        Register your company
                    </button>
                {/if}

                <text class="info1">
                    This website is still under progress.
                    The login system allows access to the IT services of Job Market webpage. Use email and password to log in.
                    If you do not know your username or password, use option Forgot my password.
                    In the event of a problem with logging in, please write to 259905@student.pwr.edu.pl.
                </text>
            {/if}
        </div>
    </div>
</div>


<style>
    .switch-button {
        display: flex;
        border: 1px solid #ccc;
        border-radius: 20px;
        overflow: hidden;
        cursor: pointer;
                min-width: 230px;
    }

    .option {
        flex: 1;
        padding: 0.5rem;
        text-align: center;
        background-color: #e0e0e0;
        color: #333;
        transition: background-color 0.3s;
    }

    .option.selected {
        background-color: #007bff;
        color: white;
    }

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

    .info1 {
        text-align: left;
        opacity: 0.5;
        font-size: 10px;
        display:block;
    }

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
        overflow-y: auto;
        scroll-behavior: smooth;
    }

    .error {
        color: red;
        font-size: 0.8rem;
        margin-top: 0.25rem;
        opacity: 1;
    }

    .form-container {
        max-width: 400px;
        width: 100%;
        padding: 2rem;
        text-align: center;
        overflow-y: auto;
        scroll-behavior: smooth;
    }

    input[type="email"], input[type="password"], input[type="text"] {
        width: 100%;
        padding: 0.5rem;
        margin-bottom: 1rem;
        border-radius: 4px;
        border: 1px solid #ccc;
    }

    .company-selection {
        margin-top: 1rem;
        text-align: left;
    }

    .company-selection h4 {
        margin-bottom: 0.5rem;
        font-size: 1rem;
        color: #333;
    }

    .company-selection select {
        width: 100%;
        padding: 0.5rem;
        border-radius: 4px;
        border: 1px solid #ccc;
        font-size: 1rem;
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
        margin-top: 0.1rem;
        cursor: pointer;
    }

    .error-message {
        color: red;
        margin-top: 1rem;
    }

    .confirmation-message {
        color: #155724;
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
        padding: 1rem;
        margin-top: 1rem;
        margin-bottom: 1rem;
        text-align: center;
        font-weight: bold;
        border-radius: 4px;
    }
</style>
