<script>
    import { goto } from '$app/navigation';
    import { user } from "../../stores/user.js";
    import axios from 'axios';

    let quizName = '';
    let timeLimit = 60; // Default time limit in seconds
    let goBack = false;
    
    let questions = [];
    let jsonOutput = "";

    function validateQuizName(event) {
        quizName = event.target.value.replace(/[^\w]/g, '').slice(0, 60);
  }
    function goToHome() {
        goto('/');
    }

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

    async function handleSubmit(event) {
        event.preventDefault();
        jsonOutput = JSON.stringify({ quizName, timeLimit, goBack, questions }, null, 2);
        const blob = new Blob([jsonOutput], { type: 'application/json' });
        const formData = new FormData();
        formData.append('quizConfig', blob, quizName+".json");
        try {
            const response = await axios.post(
                "http://localhost:8080/job-service/quizzes/createQuiz",
                formData,
                {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        'Authorization': `Bearer ${$user.jwt}`, // Include JWT if needed
                    },
                }
            );

            // Handle successful response
            console.log('Quiz created successfully:', response.data);
            // Redirect or update the UI as needed
        } catch (error) {
            // Handle error
            console.error('Error creating quiz:', error);
            // Display error message to the user if necessary
        }


    }
</script>

<!-- App Bar -->
<div class="app-bar">
    <text>{$user.jwt}</text>
    <div class="nav-links">
        <a href="/" class="app-name" aria-label="Go to home">Job Market</a>
        {#if $user.role === 'recruiter'}
            <a href="/recruiter/jobs" class="app-name" aria-label="My Job Offers">My Job Offers</a>
        {/if}
    </div>
    <button class="user-icon" on:click={() => goto('/settings')} aria-label="Go to settings">
        <svg width="24" height="24" fill="white" viewBox="0 0 24 24">
            <circle cx="12" cy="8" r="4" />
            <path d="M12 12c-4 0-8 2-8 5v2h16v-2c0-3-4-5-8-5z" />
        </svg>
    </button>
</div>

<!-- Main Content -->
<div class="scrollable-page">
    <main>
        <h1>Create a Quiz</h1>
        
        <form on:submit={handleSubmit} class="quiz-form">
            <!-- Quiz Details Form -->
            <div class="form-group">
                <label for="quiz-name">Quiz Name:</label>
                <input
                id="quiz-name"
                type="text"
                bind:value={quizName}
                placeholder="Enter quiz name"
                required
                on:input={validateQuizName}
              />
            </div>
        
            <div class="form-group">
                <label for="time-limit">Time Limit (seconds):</label>
                <input id="time-limit" type="number" bind:value={timeLimit} min="1" required />
            </div>
        
            <div class="form-group checkbox-group">
                <label for="go-back">Allow Going Back to Previous Questions:</label>
                <input id="go-back" type="checkbox" bind:checked={goBack} />
            </div>
        
            <h2>Questions</h2>
            
            <!-- Question List -->
            {#each questions as question, index}
                <div class="question">
                    <h3>Question {index + 1}</h3>
                    <div class="form-group">
                        <label for="question-title-{index}">Title:</label>
                        <input id="question-title-{index}" type="text" bind:value={question.title} placeholder="Enter question title" />
                    </div>
            
                    <div class="form-group">
                        <label>Type:</label>
                        <select bind:value={question.type} on:change={() => changeQuestionType(index, question.type)}>
                            <option value="single">Single Correct Answer</option>
                            <option value="multiple">Multiple Correct Answers</option>
                        </select>
                    </div>
            
                    <h4>Answers</h4>
                    {#each question.answers as answer, answerIndex}
                        <div class="answer">
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
                    <h3>JSON Output:</h3>
                    <pre class="json-output">{jsonOutput}</pre>
                {/if}
            </div>
        </form>
    </main>
</div>

<style>
    /* Reset and base styles */
    body {
        margin: 0;
        padding: 0;
        overflow-x: hidden;
    }

    /* App Bar Styles */
    .app-bar {
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1000;
        background-color: #007bff;
        padding: 0.5rem 1rem;
        color: white;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 1rem;
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

    /* Main Content Styles */
    .scrollable-page {
        margin-top: 60px; /* Adjust to the height of your app bar */
        padding: 1rem;
        overflow-y: auto;
        max-height: calc(100vh - 60px); /* Full viewport height minus app bar */
    }

    main {
        max-width: 800px;
        margin: 0 auto;
        padding-bottom: 2rem;
        font-family: Arial, sans-serif;
        color: #333;
    }

    h1 {
        text-align: center;
        color: #0056b3;
        margin-bottom: 2rem;
    }

    h2 {
        color: #333;
        margin-top: 2rem;
    }

    h3 {
        color: #0056b3;
        margin-bottom: 1rem;
    }

    .quiz-form {
        display: flex;
        flex-direction: column;
    }

    .form-group {
        margin-bottom: 1rem;
    }

    .form-group label {
        font-weight: bold;
        display: block;
        margin-bottom: 0.5rem;
    }

    .form-group input[type="text"],
    .form-group input[type="number"],
    .form-group select {
        width: 100%;
        padding: 0.5rem;
        border: 1px solid #ddd;
        border-radius: 4px;
        box-sizing: border-box;
    }

    .checkbox-group {
        display: flex;
        align-items: center;
    }

    .checkbox-group label {
        margin-right: 0.5rem;
        margin-bottom: 0;
    }

    .question {
        background-color: #f2f8ff;
        padding: 1rem;
        border-radius: 5px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 1.5rem;
    }

    .answer {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-top: 0.5rem;
    }

    .answer input[type="text"] {
        flex: 1;
        padding: 0.5rem;
    }

    .answer label {
        display: flex;
        align-items: center;
        margin: 0;
    }

    .answer input[type="checkbox"] {
        margin-right: 0.25rem;
    }

    .add-btn,
    .remove-btn,
    .submit-btn {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 0.75rem 1.5rem;
        font-size: 1rem;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        margin-top: 1rem;
    }

    .add-btn:hover,
    .submit-btn:hover {
        background-color: #0056b3;
    }

    .remove-btn {
        background-color: #d9534f;
    }

    .remove-btn:hover {
        background-color: #b52b27;
    }

    .submit-section {
        text-align: center;
        margin-top: 2rem;
    }

    .json-output {
        background-color: #f3f3f3;
        padding: 1rem;
        border-radius: 4px;
        font-family: monospace;
        color: #333;
        overflow-x: auto;
        margin-top: 1rem;
        max-height: 300px;
        overflow-y: auto;
    }

    /* Responsive Adjustments */
    @media (max-width: 768px) {
        .nav-links {
            flex-direction: column;
            align-items: flex-start;
        }

        .scrollable-page {
            padding: 0.5rem;
        }

        .add-btn,
        .remove-btn,
        .submit-btn {
            width: 100%;
        }
    }
</style>
