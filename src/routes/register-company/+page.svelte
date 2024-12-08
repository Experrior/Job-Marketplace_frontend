<script>
    import { goto } from '$app/navigation';
    import ImageRotator from '$lib/ImageRotator.svelte';
    import axios from 'axios';
    import RegistrationSuccess from '$lib/RegistrationSuccess.svelte';

    let errors = {};
    let errorMessage = '';
    let registrationSuccess = false;

    let companyFormData = {
        email: "",
        companyName: "",
        industry: "",
        description: "",
        logo: ""
    };

    // Validations
    function validateFields() {
        errors = {};
        if (!companyFormData.companyName) errors.companyName = "Company name is required.";
        if (!companyFormData.email) errors.email = "Email is required.";
        if (!/\S+@\S+\.\S+/.test(companyFormData.email)) errors.email = "Enter a valid email address.";
        if (!companyFormData.industry) errors.industry = "Industry is required.";
        if (!companyFormData.description || companyFormData.description.length > 160)
            errors.description = "Description is required and must be under 160 characters.";
        if (!companyFormData.logo) errors.logo = "Company logo is required.";
        return Object.keys(errors).length === 0;
    }

    async function handleCompanySubmit() {
        if (!validateFields()) {
            errorMessage = "Please fix the errors above.";
            return;
        }

        try {
            const formData = new FormData();

            formData.append(
                'registrationRequest',
                JSON.stringify({
                    email: companyFormData.email,
                    companyName: companyFormData.companyName,
                    industry: companyFormData.industry,
                    description: companyFormData.description,
                })
            );
            if (companyFormData.logo instanceof Blob) {
                formData.append('logo', companyFormData.logo);
            } else {
                errorMessage = "Please upload a valid logo file.";
                return;
            }
            console.log('Form Data:', formData);
            const res = await axios.post('http://localhost:8080/user-service/register/company', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            });

            if (res.status === 201 || res.status === 200) {
                registrationSuccess = true;
            } else {
                errorMessage = "An unexpected error occurred. Please try again.";
            }
        } catch (error) {
            errorMessage = "Failed to register the company. Please try again.";
        }
    }

    function handleImageUpload(event) {
        const file = event.target.files[0];
        if (file) {
            companyFormData.logo = file;
        }
    }

</script>

<div class="container">
    <div class="image-side">
        <ImageRotator/>
    </div>

    <div class="form-side">
        <div class="form-container">
            {#if registrationSuccess}
                <RegistrationSuccess
                        message="Company Registered Successfully!"
                        additionalInfo="Please check your email to verify your company account."
                />
            {:else}
                <h1>Register Your Company</h1>

                <div class="form-group">
                    <label class="field-name" for="companyName">Company Name</label>
                    <input
                            id="companyName"
                            type="text"
                            placeholder="JobMarket"
                            bind:value={companyFormData.companyName}
                            class:error={errors.companyName}
                    />
                    {#if errors.companyName}
                        <p class="error-message">{errors.companyName}</p>
                    {/if}
                </div>

                <div class="form-group">
                    <label class="field-name" for="companyEmail">Company Email</label>
                    <input
                            id="companyEmail"
                            type="email"
                            placeholder="Used to verify recruiters"
                            bind:value={companyFormData.email}
                            class:error={errors.email}
                    />
                    {#if errors.email}
                        <p class="error-message">{errors.email}</p>
                    {/if}
                </div>

                <div class="form-group">
                    <label class="field-name" for="companyIndustry">Company Industry</label>
                    <input
                            id="companyIndustry"
                            type="text"
                            placeholder="e.g., Technology"
                            bind:value={companyFormData.industry}
                            class:error={errors.industry}
                    />
                    {#if errors.industry}
                        <p class="error-message">{errors.industry}</p>
                    {/if}
                </div>

                <div class="form-group">
                    <label class="field-name" for="companyDescription">Company Description (Max 160 characters)</label>
                    <textarea
                            id="companyDescription"
                            bind:value={companyFormData.description}
                            rows="3"
                            maxlength={160}
                            placeholder="Description of your company"
                            class:error={errors.description}
                    ></textarea>
                    {#if errors.description}
                        <p class="error-message">{errors.description}</p>
                    {/if}
                </div>

                <div class="form-group">
                    <label class="field-name" for="companyLogo">Company Logo</label>
                    <input
                            id="companyLogo"
                            type="file"
                            accept="image/*"
                            class="custom-file-input"
                            on:change={handleImageUpload}
                            class:error={errors.logo}
                    />
                    {#if errors.logo}
                        <p class="error-message">{errors.logo}</p>
                    {/if}
                </div>

                <button class="primary-button" on:click={handleCompanySubmit}>
                    Register Your Company
                </button>

                <button class="secondary-button" on:click={() => goto('/login')}>
                    Go back to login page
                </button>
            {/if}
        </div>
    </div>
</div>

<style>
    :root {
        --primary-color: #007bff;
        --secondary-color: #6c757d;
        --background-color: #f8f9fa;
        --text-color: #212529;
        --error-color: #dc3545;
        --success-color: #28a745;
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

    .form-side {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: white;
        padding: 0;
    }

    .field-name{
        font-size: 0.9rem;
        font-weight: 510;
        color: var(--text-color);
    }

    .form-container {
        width: 100%;
        max-width: 400px;
        background-color: white;
        padding: 2rem;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        text-align: left;
    }

    h1 {
        font-size: 1.3rem;
        margin-bottom: 1.3rem;
        text-align: center;
        color: var(--text-color);
    }

    .form-group {
        margin-bottom: 0.5rem;
    }

    label {
        display: block;
        margin-bottom: 0.3rem;
        font-weight: 600;
        color: var(--text-color);
    }

    input[type="text"], input[type="email"], textarea {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 0.9rem;
    }

    input[type="file"] {
        margin-top: 0.5rem;
    }

    .hint {
        font-size: 0.8rem;
        color: var(--secondary-color);
        margin-top: 0.5rem;
    }

    textarea {
        resize: none;
    }

    button {
        width: 100%;
        padding: 0.75rem;
        margin-top: 0;
        border: none;
        border-radius: 4px;
        background-color: #007bff;
        color: white;
        cursor: pointer;
    }

    .custom-file-input {
        display: block;
        width: 100%;
        padding: 0.5rem;
        margin-top: 0.5rem;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 0.9rem;
        cursor: pointer;
        background-color: #f8f9fa;
        transition: background-color 0.3s ease;
    }

    .custom-file-input:hover {
        background-color: #e2e6ea;
    }

    .primary-button {
        background-color: var(--primary-color);
        color: white;
        margin-bottom: 1rem;
    }

    .primary-button:hover {
        background-color: #0066ff;
    }

    .secondary-button {
        background-color: #a3a7ad;
        color: white;
        margin-top: -1rem;
    }

    .secondary-button:hover {
        background-color: #959aa1;
    }

    .error-message {
        color: var(--error-color);
        font-size: 0.9rem;
        margin-top: 0.5rem;
        text-align: center;
    }

    .info a {
        color: var(--primary-color);
        text-decoration: none;
    }

    .info a:hover {
        text-decoration: underline;
    }

    .error-message {
        color: red;
    }

</style>
