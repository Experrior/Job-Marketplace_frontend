<script>
    import { onMount } from 'svelte';
    import axios from 'axios';
  
    let data = null;
    let loading = true;
  
    onMount(async () => {
      try {
        const response = await axios.get('http://localhost:8080/charts/get-jsons');
        data = response.data;
        console.log(response);
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        loading = false;
      }
    });
  </script>
  
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
    }
  
    pre {
      background-color: #f4f4f4;
      padding: 10px;
      border-radius: 4px;
    }
  
    .loading {
      color: #888;
    }
  </style>
  
  {#if loading}
    <p class="loading">Loading...</p>
  {:else}
    <pre>{JSON.stringify(data, null, 2)}</pre>
  {/if}
  