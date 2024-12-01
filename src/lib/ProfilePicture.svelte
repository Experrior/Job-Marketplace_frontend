<script>
    import { user, verifyUser } from '$lib/stores/user';
    export let profilePicture; // Current profile picture URL
    export let firstName; // User's first name
    export let lastName; // User's last name

    let uploadEndpoint = "http://localhost:8080/user-service/user-profile/profile-picture";

    let uploadError = ""; // Error message for uploading

    // Handle file selection and upload
    async function handleFileChange(event) {
        const file = event.target.files[0];
        if (!file) {
            uploadError = "Please select a valid file.";
            return;
        }

        const formData = new FormData();
        formData.append("profilePicture", file);

        verifyUser();

        try {
            const response = await fetch(uploadEndpoint, {
                method: "POST",
                body: formData,
                headers: {
                    Authorization: `Bearer ${$user.jwt}`,
                },
            });

            if (response.ok) {
                const data = await response.json();
                $user.profilePicture = data.profilePictureUrl; // Update the profile picture URL
                uploadError = ""; // Clear any previous errors
            } else {
                uploadError = "Failed to upload the profile picture. Please try again.";
            }
        } catch (error) {
            uploadError = "An error occurred while uploading. Please try again.";
        }
    }
</script>

<div class="profile-picture">
    <!-- Display Profile Picture -->
    {#if profilePicture}
        <img
                src={profilePicture}
                alt="{firstName} {lastName}"
                class="user-photo"
        />
    {:else}
        <div class="user-photo placeholder">
            <span>{firstName.charAt(0)}{lastName.charAt(0)}</span>
        </div>
    {/if}

    <!-- File Upload -->
    <div class="upload-form">
        <label for="profile-picture" class="custom-file-input">
            Change Picture
            <input
                    id="profile-picture"
                    type="file"
                    accept="image/*"
                    on:change={handleFileChange}
            />
        </label>
        {#if uploadError}
            <p class="error">{uploadError}</p>
        {/if}
    </div>
</div>

<style>
    .profile-picture {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 1.5rem;
        padding: 2rem;
        background-color: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 8px;
        max-width: 400px;
        margin: auto;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .user-photo {
        width: 150px;
        height: 150px;
        border-radius: 50%;
        object-fit: cover;
        background-color: #ddd;
    }

    .user-photo.placeholder {
        background-color: #007bff;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 2rem;
        color: #fff;
        font-weight: bold;
    }

    .upload-form {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
    }

    .custom-file-input {
        position: relative;
        display: inline-block;
        font-size: 0.9rem;
        color: #fff;
        background-color: #007bff;
        border: none;
        border-radius: 4px;
        padding: 0.5rem 1rem;
        cursor: pointer;
        text-align: center;
        transition: background-color 0.3s ease;
    }

    .custom-file-input:hover {
        background-color: #0056b3;
    }

    .custom-file-input input {
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        opacity: 0;
        cursor: pointer;
    }

    .error {
        color: #d9534f;
        font-size: 0.9rem;
        margin-top: 0.5rem;
        text-align: center;
    }

    @media (max-width: 768px) {
        .profile-picture {
            padding: 1.5rem;
        }

        .user-photo {
            width: 120px;
            height: 120px;
        }

        .upload-form {
            gap: 0.8rem;
        }
    }
</style>
