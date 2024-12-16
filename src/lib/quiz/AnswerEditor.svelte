<script>
    import { createEventDispatcher } from 'svelte';
  
    export let answer;
    export let isMultiple = false;
  
    const dispatch = createEventDispatcher();
  
    // Function to remove the answer
    function removeAnswer() {
      dispatch('remove');
    }
  </script>

  
  <div class="answer-editor">
    <input
      type="text"
      bind:value={answer.text}
      placeholder="Enter answer text"
    />
  
    {#if isMultiple}
      <label>
        <input type="checkbox" bind:checked={answer.isCorrect} />
        Correct
      </label>
    {:else}
      <!-- <label>
        <input
          type="radio"
          name="correct-answer-{Math.random()}"
          bind:checked={answer.is_correct}
        />
        Correct
      </label> -->
    {/if}
  
    <button class="remove-answer-button" on:click={removeAnswer}>
      &times;
    </button>
  </div>
  
    
  <style>
    .answer-editor {
      display: flex;
      align-items: center;
      margin-bottom: 0.5rem;
    }
  
    .answer-editor input[type="text"] {
      flex: 1;
      padding: 0.5rem;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  
    .answer-editor label {
      margin-left: 0.5rem;
      display: flex;
      align-items: center;
    }
  
    .remove-answer-button {
      margin-left: 0.5rem;
      background-color: #dc3545;
      border: none;
      color: #fff;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      cursor: pointer;
    }
  
    .remove-answer-button:hover {
      background-color: #c82333;
    }
  </style>