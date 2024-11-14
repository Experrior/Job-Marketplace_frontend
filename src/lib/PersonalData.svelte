<script>
  import { auth,} from "../stores/auth";
  import { writable } from 'svelte/store';
  import { onDestroy } from "svelte";
  import { format } from "date-fns";
  import FileDropzone from 'svelte-file-dropzone';

  let user;
  const userData = {
    firstName: "John",
    lastName: "Doe",
    email: "john.doe@example.com",
    photoUrl: "/images/front1.png",
    accountCreatedAt: "2023-01-01T10:00:00Z",
    lastLoginAt: "2023-05-15T14:30:00Z",
    cvUpdatedAt: "2023-05-10T09:15:00Z",
  };

  auth.setUser(userData);
  const unsubscribe = auth.subscribe((value) => {
    user = value.user;
  });

  onDestroy(() => {
    unsubscribe();
  });

  function formatDate(dateString) {
    return format(new Date(dateString), "PPPpp");
  }
  let isUploading = false;
  let uploadError = '';
  let uploadSuccess ='';
 // Stores for managing state
 const selectedFile = writable(null);
  const errorMessage = writable('');
  const successMessage = writable('');

  // Handle file selection
  function handleFileChange(event) {
    const file = event.target.files[0];
    if (file) {
      // Check if the file is a PDF
      if (file.type === 'application/pdf') {
        errorMessage.set('');
        selectedFile.set(file);
      } else {
        errorMessage.set('Please upload a valid PDF file.');
        selectedFile.set(null);
      }
    } else {
      selectedFile.set(null);
      errorMessage.set('');
    }
  }

  // Handle form submission
  async function handleSubmit(event) {
    event.preventDefault();
    successMessage.set('');
    errorMessage.set('');

    const file = $selectedFile;

    if (!file) {
      errorMessage.set('No file selected or file is not a PDF.');
      return;
    }

    // Prepare form data
    const formData = new FormData();
    formData.append('pdf', file);

    try {
      const response = await fetch('http://localhost:12345/uploadPdf', {
        method: 'POST',
        body: formData
      });

      if (response.ok) {
        successMessage.set('File uploaded successfully!');
      } else {
        const errorText = await response.text();
        errorMessage.set(`Upload failed: ${errorText}`);
      }
    } catch (error) {
      errorMessage.set(`Error uploading file: ${error.message}`);
    }
  }
</script>

{#if user}
  <div class="personal-data-widget">
    <!-- User Photo -->
    {#if user.photoUrl}
      <img
        src={user.photoUrl}
        alt="{user.firstName} {user.lastName}"
        class="user-photo"
      />
    {:else}
      <div class="user-photo placeholder">
        <span>{user.firstName.charAt(0)}{user.lastName.charAt(0)}</span>
      </div>
    {/if}
    <form on:submit|preventDefault={handleSubmit}>
      <input type="file" accept="application/pdf" on:change={handleFileChange} />
      {#if $errorMessage}
        <p class="error">{$errorMessage}</p>
      {/if}
      {#if $successMessage}
        <p class="success">{$successMessage}</p>
      {/if}
      <button type="submit">Upload</button>
    </form>
    <!-- User Details -->
    <div class="user-details">
      <h2>{user.firstName} {user.lastName}</h2>
      <p><strong>Email:</strong> {user.email}</p>
      <p>
        <strong>Account Created:</strong>
        {formatDate(user.accountCreatedAt)}
      </p>
      <p><strong>Last Login:</strong> {formatDate(user.lastLoginAt)}</p>

      {#if user.cvUpdatedAt}
        <p><strong>CV Updated:</strong> {formatDate(user.cvUpdatedAt)}</p>
      {:else}
        <p><strong>CV Updated:</strong> Not uploaded yet</p>
      {/if}




          <div class="cv-upload-section">
            <h3>Upload Your CV</h3>
        

            {#if isUploading}
              <p class="uploading-message">Uploading...</p>
            {/if}

            {#if uploadError}
              <p class="error-message">{uploadError}</p>
            {/if}

            {#if uploadSuccess}
              <p class="success-message">CV uploaded successfully!</p>
            {/if}
          </div>


        {#if isUploading}
          <div class="spinner"></div>
          <p class="uploading-message">Uploading...</p>
        {/if}
        
        {#if uploadError}
          <p class="error-message">{uploadError}</p>
        {/if}
        
        {#if uploadSuccess}
          <p class="success-message">CV uploaded successfully!</p>
        {/if}
    </div>
  </div>
{:else}
  <p>Loading user data...</p>
{/if}

<style>
  .user-photo {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    margin-right: 1.5rem;
    background-color: #ddd;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .user-photo.placeholder {
    background-color: #007bff;
    color: #fff;
    font-size: 2rem;
  }

  .user-details {
    flex: 1;
  }

  .user-details h2 {
    font-size: 1.75rem;
    margin: 0 0 0.5rem 0;
  }

  .user-details p {
    font-size: 1rem;
    margin: 0.25rem 0;
    color: #555;
  }

  .user-details p strong {
    color: #333;
  }

  /* CV Upload Area Styles */
  .cv-upload-area {
    margin-top: 1.5rem;
    padding: 1.5rem;
    border: 2px dashed #cccccc;
    border-radius: 8px;
    text-align: center;
    transition:
      background-color 0.3s,
      border-color 0.3s;
    cursor: pointer;
  }

  .cv-upload-area.drag-over {
    background-color: #f0f8ff;
    border-color: #007bff;
  }

  .cv-upload-area p {
    margin: 0.5rem 0;
    color: #666666;
  }

  .cv-upload-area button {
    padding: 0.5rem 1rem;
    border: none;
    background-color: #007bff;
    color: white;
    border-radius: 4px;
    cursor: pointer;
    font-size: 1rem;
    margin-top: 0.5rem;
  }

  .cv-upload-area button:hover {
    background-color: #0056b3;
  }

  /* Error and Success Messages */
  .error-message {
    color: #dc3545;
    margin-top: 0.5rem;
    font-size: 0.95rem;
  }

  .success-message {
    color: #28a745;
    margin-top: 0.5rem;
    font-size: 0.95rem;
  }
</style>
