<script>
    import { goto } from '$app/navigation';
    import ImageRotator from '$lib/ImageRotator.svelte';
    import SwitchButton from './SwitchButton.svelte';
    import axios from 'axios';
    import { user } from "../stores/user.js";

    let errors = {};
    let isApplicant = true;
    let isLogin = true;
    let formData = { email: '', password: '', confirmPassword: '' };
    let errorMessage = '';
    let isCustomCompany = false;
    let justRegistered = false;

    function toggleForm() {
        justRegistered = false;
        isLogin = !isLogin;
        formData = { email: '', password: '', confirmPassword: '' };
        errorMessage = '';
    }

    async function handleSubmit() {
        errors = {};
        if (!isLogin && formData.password !== formData.confirmPassword) {
            errorMessage = 'Passwords do not match.';
            return;
        }

        const url = !isLogin ? "http://localhost:8080/user-service/register/" + $user.role : 'http://localhost:8080/user-service/login';
        
        var response = null
        justRegistered = false
        $user.role = (isApplicant ? 'applicant' : 'recruiter')
        try {
            $user.username = formData.email
            if (isLogin) {
            
            response = await axios.post(url, {
                email: formData.email,
                password: formData.password
            });

            if (response.status == 200) {
                localStorage.setItem('jwt', response.data.accessToken);
                localStorage.setItem('jwt_expiration', Date.now() + 8 * 60 * 60 * 1000)
                $user.username = formData.email
                $user.jwt = response.data.accessToken
                goto('/');
            }else {
                errorMessage = data.message || 'An error occurred. Please try again.';
            }

            } else {

                response = await axios.post(url, {
                    email: formData.email,
                    firstName: formData.firstName,
                    lastName: formData.lastName,
                    password: formData.password,
                    confirmPassword: formData.confirmPassword
                });
                justRegistered = true;
                console.log(response.status)
            }

            console.log(response)
            console.log("1235")
            const data = await response.json();

            console.log(data)
            if (response.ok) {
                $user.username=formData.email
                $user.jwt = data.accessToken
                
            } else {
                errorMessage = data.message || 'An error occurred. Please try again.';
            }
        } catch (error) {
            console.log("1234")
            console.log(error.status)
            console.log(error)
            if (error.status === 400) {
                errors = error.response.data
            } else {
                errorMessage = error.response.data
            }

            console.log(error.response.data)
            console.error('Error during login:', error);
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

    <div class="image-side">
        <ImageRotator />
    </div>

    <div class="form-side">
        <div class="form-container">
            <h1>{isLogin ? 'Login' : 'Register'}</h1>


            <!-- {#if !isLogin} -->
          <!-- Centered Switch Button -->
            <div class="switch-button-wrapper">
                <SwitchButton bind:isApplicant leftText="Applicant" rightText="Recruiter" />
<!--                 <p>Selected role: {isApplicant ? "Applicant" : "Recruiter"}</p> -->
            </div>

            {#if errors.email}
            <div class="error">{errors.email}</div>
            {/if}
            <input type="email" placeholder="Email" bind:value={formData.email} required />


            {#if !isLogin}
                {#if errors.lastName}
                <div class="error">{errors.lastName}</div>
                {/if}
                <input type="text" placeholder="First Name" bind:value={formData.firstName} required />
                {#if errors.firstName}
                <div class="error">{errors.firstName}</div>
                {/if}
                <input type="text" placeholder="Last Name" bind:value={formData.lastName} required />
           {/if}

           {#if errors.password}
           <div class="error">{errors.password}</div>
           {/if}
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

            {#if justRegistered}
            <div class="registerConfirm">Register request successful, please verify your email.</div>
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
            <text class="info1">
                This website is still under progress.
                The login system allows access to the IT services of Job Market webpage. Use email and password to log in.
                If you do not know your username or password, use option Forgot my password.
                In the event of a problem with logging in, please write to 259905@student.pwr.edu.pl.
            </text>
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


    .info1 {
    text-align: left;
    opacity: 0.5;
    font-size: 10px;
    display:block;
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

    .error {
    color: red;
    font-size: 0.8rem;
    margin-top: 0.25rem;
    opacity: 1;
  }

  .registerConfirm {
    color: green;
    font-size: 1.2rem;
    margin-top: 0.25rem;
    opacity: 1;
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
