<script>
  import { onMount } from 'svelte';
  import { writable, get } from 'svelte/store';

  const quizData = {
    name: "C++ developer quiz",
    time_limit: 10,
    can_go_back: true,
    questions: [
      {
        question_id: 1,
        question_text: "What is the capital of France?",
        type: "single",
        answers: [
          { answer_text: "Paris", is_correct: true },
          { answer_text: "London", is_correct: false },
          { answer_text: "Berlin", is_correct: false }
        ]
      },
      {
        question_id: 2,
        question_text: "Select the programming languages that are primarily used for web development.",
        type: "multiple",
        answers: [
          { answer_text: "JavaScript", is_correct: true },
          { answer_text: "Python", is_correct: true },
          { answer_text: "C++", is_correct: false }
        ]
      },
      {
        question_id: 3,
        question_text: "What is unique_ptr?.",
        type: "single",
        answers: [
          { answer_text: "pointer", is_correct: true },
          { answer_text: "data structure", is_correct: true },
          { answer_text: "library", is_correct: false }
        ]
      }
    ]
  };

  let currentQuestionIndex = 0;
  let selectedAnswers = writable([]);
  let timer = quizData.time_limit;
  let quizSubmitted = false;
  let score = 0;

  const startTimer = () => {
    const interval = setInterval(() => {
      if (timer > 0) {
        timer -= 1;
      } else {
        clearInterval(interval);
        if (!quizSubmitted) {
          submitQuiz();
        }
      }
    }, 1000);
  };

  onMount(() => {
    startTimer();
  });

  const goToNextQuestion = () => {
    if (currentQuestionIndex < quizData.questions.length - 1) {
      currentQuestionIndex += 1;
    }
  };

  const goToPreviousQuestion = () => {
    if (quizData.can_go_back && currentQuestionIndex > 0) {
      currentQuestionIndex -= 1;
    }
  };

  const handleAnswerSelect = (answerIndex) => {
    selectedAnswers.update((answers) => {
      answers[currentQuestionIndex] = answers[currentQuestionIndex] || [];
      const selected = answers[currentQuestionIndex];

      if (quizData.questions[currentQuestionIndex].type === "single") {
        selected[0] = answerIndex;
      } else {
        if (selected.includes(answerIndex)) {
          selected.splice(selected.indexOf(answerIndex), 1);
        } else {
          selected.push(answerIndex);
        }
      }

      return answers;
    });
  };

  const submitQuiz = () => {
    quizSubmitted = true;
    calculateScore();
  };

  const calculateScore = () => {
    const selected = get(selectedAnswers);

    quizData.questions.forEach((question, index) => {
      if (selected[index]) {
        const correctAnswers = question.answers
          .map((answer, i) => (answer.is_correct ? i : null))
          .filter((i) => i !== null);
        const selectedCorrectly = selected[index].every((i) => correctAnswers.includes(i));
        const allCorrect = correctAnswers.length === selected[index].length;
        
        if (selectedCorrectly && allCorrect) {
          score += 1;
        }
      }
    });
  };
</script>

<main>
  <h1>{quizData.name}</h1>
  {#if !quizSubmitted}
    <p class="timer">Time remaining: {timer} seconds</p>
  {/if}

  {#if !quizSubmitted}
    <div class="question-container">
      <p class="question-number">Question {currentQuestionIndex + 1} of {quizData.questions.length}</p>
      <h2>{quizData.questions[currentQuestionIndex].question_text}</h2>

      <div class="answers">
        {#each quizData.questions[currentQuestionIndex].answers as answer, index}
          <label class="answer-option">
            <input
              type={quizData.questions[currentQuestionIndex].type === "single" ? "radio" : "checkbox"}
              name="answer"
              checked={$selectedAnswers[currentQuestionIndex] && $selectedAnswers[currentQuestionIndex].includes(index)}
              on:change={() => handleAnswerSelect(index)}
            />
            {answer.answer_text}
          </label>
        {/each}
      </div>
    </div>

    <div class="navigation">
      {#if quizData.can_go_back && currentQuestionIndex > 0}
        <button on:click={goToPreviousQuestion} class="nav-btn">Previous</button>
      {/if}
      {#if currentQuestionIndex < quizData.questions.length - 1}
        <button on:click={goToNextQuestion} class="nav-btn">Next</button>
      {:else}
        <button on:click={submitQuiz} class="submit-btn">Submit</button>
      {/if}
    </div>
  {:else}
    <p>Thank you for taking the quiz!</p>
    <p>Your score is: {score} out of {quizData.questions.length}</p>
  {/if}
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

    .timer {
        text-align: center;
        font-size: 1.1em;
        color: #d9534f;
    }

    .question-container {
        background-color: #f2f8ff;
        padding: 15px;
        margin-top: 20px;
        border-radius: 5px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .question-number {
        font-weight: bold;
        color: #333;
    }

    h2 {
        color: #0056b3;
        margin-top: 10px;
    }

    .answers {
        margin-top: 10px;
    }

    .answer-option {
        display: flex;
        align-items: center;
        margin-top: 8px;
        gap: 10px;
        font-size: 1em;
        color: #333;
    }

    .navigation {
        display: flex;
        justify-content: center;
        gap: 15px;
        margin-top: 20px;
    }

    .nav-btn, .submit-btn {
        background-color: #0056b3;
        color: white;
        border: none;
        padding: 8px 16px;
        font-size: 14px;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .nav-btn:hover, .submit-btn:hover {
        background-color: #003a75;
    }

    .submit-btn {
        background-color: #28a745;
    }

    .submit-btn:hover {
        background-color: #218838;
    }
</style>
