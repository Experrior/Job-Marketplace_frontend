<script>
    import { goto } from '$app/navigation';
    import AppBar from '$lib/AppBar.svelte';
    import { user } from "$lib/../stores/user.js";
    import axios from 'axios';

    let quizName = '';
    let timeLimit = 60; // Default time limit in seconds
    let goBack = false;
    
    let questions = [];
    let jsonOutput = "";

    const apiGateway = import.meta.env.VITE_GATEWAY_URL;
    console.log("USING GATEWAY:", apiGateway);


    function validateQuizName(event) {
        quizName = event.target.value.replace(/[^\w]/g, '').slice(0, 60);
    }

    function addQuestion() {
      questions = [
        ...questions,
        {
          title: '',
          type: 'single',
          answers: [
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

    function changeAnswerCorrectness(questionIndex, answerIndex, questionType) {
      if (questionType === 'single') {
        for (let i = 0; i < questions[questionIndex].answers.length; i++) {
            questions[questionIndex].answers[i].isCorrect = (i === answerIndex);
        }
      }
    }

    function addAnswer(questionIndex) {
        if (questions[questionIndex].answers.length < 10) {
        questions[questionIndex].answers.push({ text: '', isCorrect: false });
        questions = [...questions];
        }
    }

    function removeAnswer(questionIndex, answerIndex) {
      if (questions[questionIndex].answers.length > 2) {
        questions[questionIndex].answers.splice(answerIndex, 1);
        questions = [...questions];
      }
    }

    async function handleSubmit(event) {
        event.preventDefault();
        jsonOutput = JSON.stringify({ quizName, timeLimit, goBack, questions }, null, 2);
        const blob = new Blob([jsonOutput], { type: 'application/json' });
        const formData = new FormData();
        formData.append('quizConfig', blob, quizName + ".json");
        try {
            const response = await axios.post(`${apiGateway}/job-service/quizzes/createQuiz`,
                formData,
                {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        'Authorization': `Bearer ${$user.jwt}`,
                    },
                }
            );
            if (response.status === 201){
                goto('/recruiter')
            }else{
                alert(response)
            }
        } catch (error) {
            console.error('Error creating quiz:', error);
        }
    }
</script>



 <AppBar/>


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
            {#each questions as question, qIndex}
                <div class="question">
                    <h3>Question {qIndex + 1}</h3>
                    <div class="form-group">
                        <label for="question-title-{qIndex}">Title:</label>
                        <input id="question-title-{qIndex}" type="text" bind:value={question.title} placeholder="Enter question title" />
                    </div>
            
                    <div class="form-group">
                        <label>Type:</label>
                        <select bind:value={question.type} on:change={() => changeQuestionType(qIndex, question.type)}>
                            <option value="single">Single Correct Answer</option>
                            <option value="multiple">Multiple Correct Answers</option>
                        </select>
                    </div>
            
                    <h4>Answers</h4>
                    {#each question.answers as answer, aIndex}
                        <div class="answer">
                            <input
                                type="text"
                                bind:value={answer.text}
                                placeholder="Enter answer text"
                            />
                            <label>
                                <input
                                    type="checkbox"
                                    bind:checked={answer.isCorrect}
                                    on:change={() => changeAnswerCorrectness(qIndex, aIndex, question.type)}
                                />
                                Correct
                            </label>
                            {#if question.answers.length > 2}
                                <button type="button" class="remove-answer-btn" on:click={() => removeAnswer(qIndex, aIndex)}>
                                    Remove Answer
                                </button>
                            {/if}
                        </div>
                    {/each}
            
                    {#if question.answers.length < 10}
                    <button type="button" class="add-answer-btn" on:click={() => addAnswer(qIndex)}>+ Add Answer</button>
                    {/if}
                    <button type="button" class="remove-btn" on:click={() => removeQuestion(qIndex)}>Remove Question</button>
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

    .scrollable-page {
        max-width: 800px; 
        margin: 2rem auto; 
        background-color: #f9f9f9;
        padding: 2rem; 
        border-radius: 8px; 
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);

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
/* 
    .question {
        position: relative;
        background-color: #f2f8ff;
        padding: 1rem;
        border-radius: 5px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        margin-bottom: 1.5rem;
        padding: 1.5rem 1rem 3rem 1rem;
    } */


    .question .add-answer-btn {
        margin-bottom: 1rem;
    }


    .question {
        position: relative;
        border: 1px solid #ccc;
        padding: 1.5rem 1rem 3rem 1rem;
        margin-bottom: 1.5rem;
        border-radius: 8px; 
        background-color: #f9f9f9;
    }

    /* Style for the Remove Question button */
    .remove-btn {
        position: absolute; /* Positions the button relative to the nearest positioned ancestor (.question) */
        bottom: 1rem;       /* 1rem from the bottom of the .question container */
        right: 1rem;        /* 1rem from the right of the .question container */
        background-color: #e74c3c; /* Red background */
        color: white;               /* White text */
        border: none;
        padding: 0.5rem 1rem;
        cursor: pointer;
        border-radius: 4px;         /* Rounded corners */
        font-size: 0.9rem;          /* Slightly smaller font size */
        transition: background-color 0.3s ease; /* Smooth hover transition */
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

    .add-answer-btn {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 0.5rem 1.0rem;
        font-size: 0.9rem;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s ease;
        margin-top: 0.75rem;
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

        /* .remove-btn {
            width: 100%;
            right: 0;
            position: absolute;
            margin-right: 50px;
            float: right;
        } */
    }
</style>
