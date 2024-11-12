<script>
    let name = '';
    let timeLimit = 60; // Default time limit in seconds
    let goBack = false;
    
    let questions = [];
    let jsonOutput = "";
  
    function addQuestion() {
      questions = [
        ...questions,
        {
          title: '',
          type: 'single',
          answers: [
            { text: '', isCorrect: false },
            { text: '', isCorrect: false },
            { text: '', isCorrect: false },
            { text: '', isCorrect: false }
          ]
        }
      ];
    }
  
    function removeQuestion(index) {
      questions.splice(index, 1);
      questions = [...questions];
    }
  
    function changeQuestionType(index, newType) {
      questions[index].type = newType;
      questions[index].answers.forEach(answer => answer.isCorrect = false);
    }

    function changeAnswerCorrectness(index, answerIndex, questionType) {
      if (questionType === 'single') {
        for (let i = 0; i < questions[index].answers.length; i++) {
            questions[index].answers[i].isCorrect = (i === answerIndex);
        }
      }
    }

    function handleSubmit(event) {
        event.preventDefault();
        jsonOutput = JSON.stringify({ name, timeLimit, goBack, questions });
    }
</script>
  
<main>
    <h1>Create a Quiz</h1>
    
    <form on:submit={handleSubmit} class="quiz-form">
        <!-- Quiz Details Form -->
        <div class="form-group">
            <label for="quiz-name">Quiz Name:</label>
            <input id="quiz-name" type="text" bind:value={name} placeholder="Enter quiz name" required />
        </div>
    
        <div class="form-group">
            <label for="time-limit">Time Limit (seconds):</label>
            <input id="time-limit" type="number" bind:value={timeLimit} min="1" required />
        </div>
    
        <div class="form-group">
            <label for="go-back">Allow Going Back to Previous Questions:</label>
            <input id="go-back" type="checkbox" bind:checked={goBack} />
        </div>
    
        <h2>Questions</h2>
        
        <!-- Question List -->
        {#each questions as question, index (question)}
            <div class="question" key={index}>
                <h3>Question {index + 1}</h3>
                <label for="question-title-{index}">Title:</label>
                <input id="question-title-{index}" type="text" bind:value={question.title} placeholder="Enter question title" />
        
                <div class="form-group">
                    <label>Type:</label>
                    <select bind:value={question.type} on:change={() => changeQuestionType(index, question.type)}>
                        <option value="single">Single Correct Answer</option>
                        <option value="multiple">Multiple Correct Answers</option>
                    </select>
                </div>
        
                <h4>Answers</h4>
                {#each question.answers as answer, answerIndex (answer)}
                    <div class="answer" key={answerIndex}>
                        <input
                            type="text"
                            bind:value={answer.text}
                            placeholder="Enter answer text"
                        />
                        <label>
                            <input
                                type="checkbox"
                                bind:checked={answer.isCorrect} on:change={() => changeAnswerCorrectness(index, answerIndex, question.type)}
                            />
                            Correct
                        </label>
                    </div>
                {/each}
        
                <button type="button" class="remove-btn" on:click={() => removeQuestion(index)}>Remove Question</button>
            </div>
        {/each}
    
        <!-- Add Question Button -->
        <button type="button" class="add-btn" on:click={addQuestion}>+ Add Question</button>
    
        <!-- Submit Button -->
        <div class="submit-section">
            <button type="submit" class="submit-btn">Submit</button>
            {#if jsonOutput}
                <p>JSON Output:</p>
                <pre class="json-output">{jsonOutput}</pre>
            {/if}
        </div>
    </form>
</main>
  
<style>
    main {
        max-width: 700px;
        margin: 0 auto;
        padding: 20px;
        font-family: Arial, sans-serif;
        color: #333;
        background-color: #f9f9f9;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    h1 {
        text-align: center;
        color: #0056b3;
    }

    h2 {
        color: #333;
        margin-top: 30px;
    }

    h3 {
        color: #0056b3;
    }

    .quiz-form {
        display: flex;
        flex-direction: column;
    }

    .form-group, .question, .submit-section {
        margin-top: 20px;
        margin-bottom: 20px;
    }

    label {
        font-weight: bold;
        margin-bottom: 5px;
        display: inline-block;
    }

    input[type="text"],
    input[type="number"],
    select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-top: 5px;
        box-sizing: border-box;
    }

    input[type="checkbox"] {
        margin-left: 8px;
    }

    .question {
        background-color: #f2f8ff;
        padding: 15px;
        border-radius: 5px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .answer {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-top: 8px;
    }

    .add-btn,
    .remove-btn,
    .submit-btn {
        background-color: #0056b3;
        color: white;
        border: none;
        padding: 8px 16px;
        font-size: 14px;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        margin-top: 10px; 
    }

    .add-btn:hover,
    .remove-btn:hover,
    .submit-btn:hover {
        background-color: #003a75;
    }

    .remove-btn {
        background-color: #d9534f;
    }

    .remove-btn:hover {
        background-color: #b52b27;
    }

    .submit-section {
        text-align: center;
    }

    .json-output {
        background-color: #f3f3f3;
        padding: 10px;
        border-radius: 4px;
        font-family: monospace;
        color: #333;
        overflow-x: auto;
        margin-top: 10px;
    }
</style>
