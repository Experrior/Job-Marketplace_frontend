<script>
  import App from "$lib/App.svelte";
  import { accessToken, refreshToken, userId } from '$lib/authStore';
</script>

<div class="app-bar">
  <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
  <a href="/recruiter/jobs" class="app-name" aria-label="Go to home">MyCreatedJobs</a>
  <text> {userId}</text>
  <button
    class="user-icon"
    on:click={() => goto("/settings")}
    aria-label="Go to settings">
    <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
      <circle cx="12" cy="8" r="4" />
      <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
    </svg>
  </button>
</div>
<App />
