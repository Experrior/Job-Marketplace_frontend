<script>
    export let categories = [];
    export let selectedCategory;
</script>

<div class="categories">
    <button on:click={() => (selectedCategory = '')} class:selected={!selectedCategory}>
        All
    </button>
    {#each categories as category}
        <button
            on:click={() => (selectedCategory = category)}
            class:selected={selectedCategory === category}
        >
            {category}
        </button>
    {/each}
</div>

<style>
    .categories {
        display: flex;
        gap: 1rem;
        margin-bottom: 1rem;
    }

    button {
        padding: 0.5rem 1rem;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        background-color: #e0e0e0;
    }

    button.selected {
        background-color: #007bff;
        color: white;
    }
</style>
