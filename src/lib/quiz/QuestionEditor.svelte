<script>
    import AnswerEditor from './AnswerEditor.svelte';
    import { createEventDispatcher } from 'svelte';
  
    export let question;
    console.log('asdasd')
    console.log(question)
  
    const dispatch = createEventDispatcher();
  
    // Function to add a new answer
    function addAnswer() {
      question.answers = [
        ...question.answers,
        { text: "", isCorrect: false }
      ];
      dispatch('update', question);
    }
  
    // Function to remove an answer
    function removeAnswer(index) {
      if (question.answers.length > 2) { // Ensure at least two answers
        question.answers = question.answers.filter((_, i) => i !== index);
        dispatch('update', question);
      } else {
        alert("A question must have at least two answers.");
      }
    }
  
    // Function to remove the entire question
    function removeQuestion() {
      dispatch('remove');
    }
  
    // Function to handle correctness change in single choice questions
    function handleCorrectChanged(event) {
      const { currentAnswer } = event.detail;
  
      question.answers = question.answers.map(ans => {
        if (ans === currentAnswer) {
          return { ...ans, isCorrect: true };
        } else {
          return { ...ans, isCorrect: false };
        }
      });
  
      dispatch('update', question);
    }
  
    // Watch for changes in question fields
    function handleFieldChange() {
      dispatch('update', question);
    }
  </script>

  
  <div class="question-editor">
    <!-- <div class="question-header">
      <h3>Question {question.question_id}</h3>
      <button class="remove-button" on:click={removeQuestion}>
        Remove
      </button>
    </div> -->
  
    <div class="form-group">
      <label>Question Text</label>
      <input
        type="text"
        bind:value={question.title}
        placeholder="Enter question text"
        on:input={handleFieldChange}
      />
    </div>
  
    <div class="form-group">
      <label>Type</label>
      <select bind:value={question.type} on:change={handleFieldChange}>
        <option value="single">Single Choice</option>
        <option value="multiple">Multiple Choice</option>
      </select>
    </div>
  
    <!-- Answers Section -->
    <div class="answers">
      <h4>Answers</h4>
  
      {#each question.answers as answer, index}
        <AnswerEditor
          answer={answer}
          on:update={() => dispatch('update', question)}
          on:remove={() => removeAnswer(index)}
          isMultiple={question.type === "multiple"}
        />
      {/each}
  
      <button class="add-answer-button" on:click={addAnswer}>
        + Add Answer
      </button>
    </div>
  </div>
  

    
  <style>
    .question-editor {
      border: 1px solid #ccc;
      padding: 1rem;
      border-radius: 8px;
      margin-bottom: 1rem;
      background-color: #f8f9fa;
    }
  
    .question-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
  
    .question-header h3 {
      margin: 0;
    }
  
    .remove-button {
      background-color: #dc3545;
      border: none;
      color: #fff;
      padding: 0.25rem 0.5rem;
      border-radius: 4px;
      cursor: pointer;
    }
  
    .remove-button:hover {
      background-color: #c82333;
    }
  
    .form-group {
      margin-top: 1rem;
    }
  
    .form-group label {
      display: block;
      font-weight: bold;
      margin-bottom: 0.5rem;
    }
  
    .form-group input[type="text"],
    .form-group select {
      width: 100%;
      padding: 0.5rem;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  
    .answers {
      margin-top: 1rem;
    }
  
    .answers h4 {
      margin-bottom: 0.5rem;
    }
  
    .add-answer-button {
      margin-top: 0.5rem;
      padding: 0.25rem 0.75rem;
      background-color: #17a2b8;
      border: none;
      color: #fff;
      border-radius: 4px;
      cursor: pointer;
    }
  
    .add-answer-button:hover {
      background-color: #138496;
    }
  </style>