<script>
    import { goto } from '$app/navigation';
    import { user } from "../stores/user.js";
    import FaRegUserCircle from 'svelte-icons/fa/FaRegUserCircle.svelte'
</script>


<div class="app-bar">
    <div class="nav-links">
    <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
    <!-- {#if $user.role === 'recruiter'} -->
    <a href="/recruiter" class="app-name" aria-label="Jobs panel"> My jobs panel</a>
  <!-- {/if} -->
  </div>
    <div class="user-icon" on:click={() => goto('/settings')} role="none"><FaRegUserCircle/></div>

</div>

<style>

.app-bar {
  position: fixed;
  top: 0;
  width: 100%;
  z-index: 1000;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background-color: #007bff;
  padding: 0.5rem 1rem;
  color: white;
}

.app-name {
  color: white;
  text-decoration: none;
  font-size: 1.5rem;
}

.user-icon {
  background: none;
  border: none;
  cursor: pointer;
}
</style>