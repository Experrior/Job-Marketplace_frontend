<script>
    import { goto } from '$app/navigation';
    import ImageRotator from '$lib/ImageRotator.svelte';
    import SwitchButton from '$lib/SwitchButton.svelte';
    import axios from 'axios';
    import { user } from "../../stores/user.js";

    let errors = {};
    let formData = { email: '', password: '', confirmPassword: '' };
    let errorMessage = '';
    // let companyFormData = {
    //     "email": "259905@student.pwr.edu.pl",
    //     "companyName": "The Office",
    //     "industry": "Technology",
    //     "description": "Dunder Mifflin is a leading tech company specializing in paper solutions.",
    //     "logo": "https://drive.google.com/file/d/1V9VsZykbnolrYwSG1-K_uejH3ComSVN4/view?usp=sharing"
    //     }

    let companyFormData = {
        "email": "",
        "companyName": "",
        "industry": "",
        "description": "",
        "logo": ""
        }

    async function handleCompanySubmit() {
        const missingParameter = Object.entries(companyFormData).length === 0 || Object.entries(companyFormData).some(([key, value]) => !value)
        if (missingParameter){
            errorMessage = 'Missing some fields for company Registration'
            return
        }
      try {
        const res = await axios.post(
          'http://localhost:8080/user-service/register/company',
            companyFormData,
                {
            headers:{
              "Content-Type": "application/json",
            },
        }
            )

        if (res.status === 201 || res.status === 200){
            alert("SUCCESF")
        }else{
            alert("shit hit the fan, during company registration 22222")
        }
        } catch (error) {
            alert("shit hit the fan, during company registration")
        }
    }

    function handleImageUpload(event) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            companyFormData.logo = e.target.result;
        };
        reader.readAsDataURL(file);
        }
    }
</script>



<div class="container">

    <div class="image-side">
        <ImageRotator />
    </div>



    <div class="form-side">
        <div class="form-container">

            <h1>Register Company</h1>
                <h3>Company name</h3>
                <input
                    type="text"
                    placeholder="JobMarket"
                    bind:value={companyFormData.companyName}
                    required/>
                
                <h3>Company email</h3>
                <input
                type="text"
                placeholder="Used to verify recruiters"
                bind:value={companyFormData.email}
                required/>

                <h3>Company industry</h3>
                <input
                type="text"
                placeholder="Short company description"
                bind:value={companyFormData.industry}
                required/>

                <h3>Company description (Max 160 characters)</h3>
                <div class="form-group">
                <textarea bind:value={companyFormData.description} rows="3" maxlength={160} class="custom-textarea"></textarea>
                </div>
                <!-- <input
                type="text"
                placeholder="${companyFormData.description}"
                bind:value={companyFormData.description}
                required/> -->

                <h3>Company logo</h3>
                <div class="form-group">
                    <input type="file" accept="image/*" on:change={handleImageUpload} />
                </div>
                

                <button on:click={handleCompanySubmit}>
                     Register Your Company
                </button>

            {#if errorMessage}
                <p class="error-message">{errorMessage}</p>
            {/if}

            <button class="button-toggle" on:click={ () => goto('/login')}>
                Go back to login page
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

    .custom-textarea {
        width: 100%;
        height: 60px;
    }
</style>
