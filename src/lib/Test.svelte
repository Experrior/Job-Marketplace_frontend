<script>
    import { onMount } from "svelte";
    let name = "";
    let age = "";
    let jsonOutput = "";

    function handleSubmit(event) {
        event.preventDefault();
        jsonOutput = JSON.stringify({ name, age });
    }
</script>

<main>
    <form on:submit={handleSubmit}>
        <label for="name">Name:</label>
        <input type="text" id="name" bind:value={name} required />

        <label for="age">Age:</label>
        <input type="number" id="age" bind:value={age} required />

        <button type="submit">Submit</button>
    </form>

    {#if jsonOutput}
        <p>JSON Output:</p>
        <pre>{jsonOutput}</pre>
    {/if}
</main>

<style>
    main {
        max-width: 300px;
        margin: auto;
        font-family: Arial, sans-serif;
    }
    label, input, button {
        display: block;
        margin: 0.5rem 0;
    }
</style>
