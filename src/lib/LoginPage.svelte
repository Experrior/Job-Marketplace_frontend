<script>
    import { goto } from '$app/navigation';
    import ImageRotator from '$lib/ImageRotator.svelte';
    import axios from 'axios';
    import { user } from "../stores/user.js";
  import { onMount } from 'svelte';

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
    let justRegistered = false;
    function toggleForm() {
        justRegistered = false;
        isLogin = !isLogin;
        errorMessage = '';

    }
    let companies = ["TechCorp", "DesignPro", "MarketMasters", "FinanceGurus"];

	onMount(async () => {
		const res = await axios.get('http://localhost:8080/user-service/getCompanies')
        companies = res.data.map(comp => comp.name)
        console.log(res.data)

        companies = companies.sort()

	});

    async function handleSubmit() {
        // alert('hello')
        errors = {};
        errorMessage = '';
       if (!isLogin && registerFormData.password !== registerFormData.confirmPassword){
            errorMessage = 'Passwords do not match.';
            return;
        }
        const url = !isLogin ? "http://localhost:8080/user-service/register/" + $user.role : 'http://localhost:8080/user-service/login';
        
        var response = null
        justRegistered = false
        $user.role = (isApplicant ? 'applicant' : 'recruiter')
        // $user.role = 'recruiter'
        try {
            $user.username = loginFormData.email
            if (isLogin) {
                response = await axios.post(url, loginFormData);

                if (response.status == 200) {
                    localStorage.setItem('jwt', response.data.accessToken);
                    localStorage.setItem('jwt_expiration', Date.now() + 8 * 60 * 60 * 1000)
                    $user.email = loginFormData.email
                    $user.jwt = response.data.accessToken
                    goto('/');
                }else {
                    errors = error.response.data
                    errorMessage = data.message || 'An error occurred. Please try again.';
                }

            } else {
                // let companyId = companies.find(x => x.name === registerFormData.company)
                // console.log(companyId)
                // registerFormData.company = companyId
                console.log(registerFormData.company)
                let tempCopy= {};
                if (isApplicant){
                    tempCopy = Object.fromEntries(
                    Object.entries(registerFormData).filter(([key]) => key !== 'company')
                    );

                }else{
                    tempCopy = registerFormData;
                }
                console.log(tempCopy)
                response = await axios.post(url, tempCopy);
                justRegistered = true;
                errors = error.response.data
                console.log(response.status)
                console.log('lkjhgyhu')
                console.log(response.data.data)

            }

            console.log(response)
            console.log("1235")
            // const data = await response.json();

            console.log(data)
            if (response.ok) {
                $user.username=loginFormData.email
                $user.jwt = data.accessToken
                
            } else {
                // alert(response)
                errorMessage = data.message || 'An error occurred. Please try again.';
            }
        } catch (error) {
            console.log("1234")
            console.log(error.status)
            console.log(error)
            // alert(response)
            // if (error.status === 400) {
            //     errors = error.response.data
            // } else {
            //     errorMessage = error.response.data
            // }
            // errorMessage = error.response.data
            // console.log(error.response.data)
            // console.error('Error during login:', error);
            if (error.response){
                errors = error.response.data
                console.log(error.response)
            }
            errorMessage = error.response.data

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
            <h1>{isLogin ? 'Login' : 'Register'}</h1>


            {#if !isLogin}
                <div class="switch-button-wrapper">
                    <div class="switch-button" on:click={toggle}>
                        <div class="option" class:selected={isApplicant}>{leftText}</div>
                        <div class="option" class:selected={!isApplicant}>{rightText}</div>
                    </div>
                    <!-- <button bind:isApplicant on:click{toggle} leftText="Applicant" rightText="Recruiter" /> -->
                </div>
            {/if}



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
           {:else}
                {#if errors.email}
                    <div class="error">{errors.email}</div>
                {/if}
                <input type="email" placeholder="Email" bind:value={loginFormData.email} required />

                {#if errors.password}
                        <div class="error">{errors.password}</div>
                {/if}
                <input type="password" placeholder="Password" bind:value={loginFormData.password} required />
           {/if}


            {#if !isLogin && !isApplicant}
                <h4>Company:</h4>
                <select on:change={handleCompanyChange} required>
                    <!-- <option value="" disabled selected>Select Company</option> -->
                    {#each companies as company}
                        <option value={company}>{company}</option>
                    {/each}
                </select>
            {/if}

            {#if justRegistered}
            <div class="registerConfirm">Register request successful, please verify your email.</div>
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
            <button class="button-toggle" on:click={ () => goto('/register-company')}>
                Register yout company
            </button>
            {/if}
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
</style>
