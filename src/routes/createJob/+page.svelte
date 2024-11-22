<script>
  import AppBar from "../../lib/AppBar.svelte";

  export let data;
  let { errors, success } = data;

  // Optional: Initialize form fields if needed
</script>

<h1>Create a New Job Posting</h1>

{#if success}
  <p class="success-message">Job created successfully!</p>
{/if}

<AppBar/>

<form method="POST">
  <!-- Job Title -->
  <label for="title">Job Title</label>
  <input type="text" id="title" name="title" required />

  <!-- Company Name -->
  <label for="company">Company Name</label>
  <input type="text" id="company" name="company" required />

  <!-- Location -->
  <label for="location">Location</label>
  <input type="text" id="location" name="location" required />

  <!-- Category -->
  <label for="category">Category</label>
  <input type="text" id="category" name="category" required />

  <!-- Tags -->
  <label for="tags">Tags (comma-separated)</label>
  <input type="text" id="tags" name="tags" />

  <!-- Company Logo URL -->
  <label for="companyLogo">Company Logo URL</label>
  <input type="url" id="companyLogo" name="companyLogo" />

  <!-- Description -->
  <label for="description">Job Description</label>
  <textarea id="description" name="description" required></textarea>

  <!-- Error Messages -->
  {#if errors}
    <div class="errors">
      {#each Object.entries(errors) as [field, error]}
        <p><strong>{field}:</strong> {error}</p>
      {/each}
    </div>
  {/if}

  <!-- Submit Button -->
  <button type="submit">Create Job</button>
</form>

<style>
  form {
    max-width: 600px;
    margin: 2rem auto;
    display: flex;
    flex-direction: column;
  }

  label {
    margin-top: 1rem;
  }

  input,
  textarea {
    padding: 0.5rem;
    font-size: 1rem;
    margin-top: 0.5rem;
  }

  .errors {
    background-color: #ffe6e6;
    padding: 1rem;
    margin-top: 1rem;
    border: 1px solid #ff4d4d;
  }

  .success-message {
    background-color: #e6ffe6;
    padding: 1rem;
    border: 1px solid #4dff4d;
    margin-bottom: 1rem;
  }

  button {
    margin-top: 2rem;
    padding: 0.75rem 1.5rem;
    background-color: #007bff;
    color: white;
    font-size: 1rem;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    align-self: flex-start;
  }

  button:hover {
    background-color: #0056b3;
  }
</style>
