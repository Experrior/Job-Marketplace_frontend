<!-- src/components/QuizEditor.svelte -->
<script>
    import QuestionEditor from './QuestionEditor.svelte';
  
    let quizData = {
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
  
    // Function to add a new question
    function addQuestion() {
      const newQuestionId = quizData.questions.length
        ? Math.max(...quizData.questions.map(q => q.question_id)) + 1
        : 1;
  
      quizData.questions = [
        ...quizData.questions,
        {
          question_id: newQuestionId,
          question_text: "",
          type: "single",
          answers: [
            { answer_text: "", is_correct: false },
            { answer_text: "", is_correct: false }
          ]
        }
      ];
    }
  
    // Function to remove a question
    function removeQuestion(index) {
      if (confirm("Are you sure you want to delete this question?")) {
        quizData.questions = quizData.questions.filter((_, i) => i !== index);
        // Trigger reactivity
        quizData = { ...quizData };
      }
    }
  
    // Function to update a question
    function updateQuestion(index, updatedQuestion) {
      quizData.questions[index] = updatedQuestion;
      // Trigger reactivity by reassigning the array
      quizData = { ...quizData };
    }
  
    // Function to handle form submission (e.g., save the quiz)
    async function saveQuiz() {
      // Implement your save logic here (e.g., send to a server)
      console.log("Quiz saved:", quizData);
      alert("Quiz saved successfully!");
    }
  </script>
  
  <style>
    .quiz-editor {
      max-width: 800px;
      margin: 2rem auto;
      padding: 2rem;
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      font-family: Arial, sans-serif;
    }
  
    .quiz-editor h1 {
      text-align: center;
      margin-bottom: 1.5rem;
    }
  
    .form-group {
      margin-bottom: 1rem;
    }
  
    .form-group label {
      display: block;
      font-weight: bold;
      margin-bottom: 0.5rem;
    }
  
    .form-group input[type="text"],
    .form-group input[type="number"],
    .form-group select {
      width: 100%;
      padding: 0.5rem;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  
    .questions {
      margin-top: 2rem;
    }
  
    .questions h2 {
      margin-bottom: 1rem;
    }
  
    .add-button {
      margin-top: 1rem;
      padding: 0.5rem 1rem;
      background-color: #28a745;
      border: none;
      color: #fff;
      border-radius: 4px;
      cursor: pointer;
    }
  
    .add-button:hover {
      background-color: #218838;
    }
  
    .save-button {
      margin-top: 2rem;
      padding: 0.75rem 1.5rem;
      background-color: #007bff;
      border: none;
      color: #fff;
      border-radius: 4px;
      cursor: pointer;
      display: block;
      width: 100%;
      font-size: 1rem;
    }
  
    .save-button:hover {
      background-color: #0069d9;
    }
  </style>
  
  <div class="quiz-editor">
    <h1>Edit Quiz</h1>
  
    <!-- Quiz-Level Information -->
    <div class="form-group">
      <label for="quiz-name">Quiz Name</label>
      <input
        type="text"
        id="quiz-name"
        bind:value={quizData.name}
        placeholder="Enter quiz name"
      />
    </div>
  
    <div class="form-group">
      <label for="time-limit">Time Limit (minutes)</label>
      <input
        type="number"
        id="time-limit"
        bind:value={quizData.time_limit}
        min="1"
        placeholder="Enter time limit"
      />
    </div>
  
    <div class="form-group">
      <label for="can-go-back">Can Go Back</label>
      <select id="can-go-back" bind:value={quizData.can_go_back}>
        <option value={true}>Yes</option>
        <option value={false}>No</option>
      </select>
    </div>
  
    <!-- Questions Section -->
    <div class="questions">
      <h2>Questions</h2>
  
      {#each quizData.questions as question, index}
        <QuestionEditor
          question={question}
          on:update={(e) => updateQuestion(index, e.detail)}
          on:remove={() => removeQuestion(index)}
        />
      {/each}
  
      <button class="add-button" on:click={addQuestion}>
        + Add Question
      </button>
    </div>
  
    <!-- Save Button -->
    <button class="save-button" on:click={saveQuiz}>
      Save Quiz
    </button>
  </div>
  