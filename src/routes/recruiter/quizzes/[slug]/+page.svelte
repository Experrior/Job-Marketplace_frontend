<script>
   import QuestionEditor from '$lib/quiz/QuestionEditor.svelte';
   import AppBar from '$lib/AppBar.svelte';
   import { page } from '$app/stores';
   import { onMount } from 'svelte';
   import axios from 'axios';
   import {verifyUser, user} from '$lib/stores/user'
   import {goto} from '$app/navigation'


   const apiGateway = import.meta.env.VITE_GATEWAY_URL;
   console.log("USING GATEWAY:", apiGateway);

   onMount(() => {
    if (!verifyUser()){
    goto('/login');
   }

   })

   let quizId = $page.params.slug;
//    let quizName = '';
//    let quizS3 = '';
   let quizData = [];

    // console.log($user.jwt)
   onMount(async () => {
    try {
    const response = await axios.post(`${apiGateway}/job-service/graphql`,
        {query: `query{
    quizById(quizId: "toReplace"){
        quizName
        s3QuizUrl
    }
    }`.replace('toReplace', quizId)},       
            {headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${$user.jwt}`
            }
            }
    )

        console.log(response.data.data.quizById)
        quizData.quizName = response.data.data.quizById.quizName
        let quizS3 = response.data.data.quizById.s3QuizUrl
        const json1 = await axios.get(quizS3,
        {headers: {
            'Content-Type': 'application/json',
            }
            }

        )
        console.log(quizS3)
        console.log(json1.data)
        quizData = json1.data
        console.log('xd')
        } catch (error) {
            console.log(error)
            alert(error)

        }
    

   })
    // let quizData = {
    //   name: "C++ developer quiz",
    //   time_limit: 10,
    //   can_go_back: true,
    //   questions: [
    //     {
    //       question_id: 1,
    //       title: "What is the capital of France?",
    //       type: "single",
    //       answers: [
    //         { text: "Paris", isCorrect: true },
    //         { text: "London", isCorrect: false },
    //         { text: "Berlin", isCorrect: false }
    //       ]
    //     },
    //     {
    //       question_id: 2,
    //       title: "Select the programming languages that are primarily used for web development.",
    //       type: "multiple",
    //       answers: [
    //         { text: "JavaScript", isCorrect: true },
    //         { text: "Python", isCorrect: true },
    //         { text: "C++", isCorrect: false }
    //       ]
    //     },
    //     {
    //       question_id: 3,
    //       title: "What is unique_ptr?.",
    //       type: "single",
    //       answers: [
    //         { text: "pointer", isCorrect: true },
    //         { text: "data structure", isCorrect: true },
    //         { text: "library", isCorrect: false }
    //       ]
    //     }
    //   ]
    // };
  
    // Function to add a new question
    function addQuestion() {
      const newQuestionId = quizData.questions.length
        ? Math.max(...quizData.questions.map(q => q.question_id)) + 1
        : 1;
  
      quizData.questions = [
        ...quizData.questions,
        {
          question_id: newQuestionId,
          title: "",
          type: "single",
          answers: [
            { text: "", isCorrect: false },
            { text: "", isCorrect: false }
          ]
        }
      ];
    }
  
    function removeQuestion(index) {
      if (confirm("Are you sure you want to delete this question?")) {
        quizData.questions = quizData.questions.filter((_, i) => i !== index);
      }
    }
  
    function updateQuestion(index, updatedQuestion) {
      quizData.questions[index] = updatedQuestion;

      quizData = { ...quizData };
    }
    
    async function saveQuiz() {
        const blob = new Blob([quizData], { type: 'application/json' });
        const formData = new FormData();
        formData.append('quizConfig', blob, quizData.quizName+".json");
        console.log(`${apiGateway}/job-service/quizzes/updateQuiz/`+quizId)
        try {
            const response = await axios.post(
                `${apiGateway}/job-service/quizzes/updateQuiz/`+quizId,
                formData,
                {
                    headers: {
                        'Content-Type': 'multipart/form-data',
                        'Authorization': `Bearer ${$user.jwt}`,
                    },
                }
            );
            console.log
            console.log('Quiz created successfully:', response.data);
        } catch (error) {
            console.error('Error creating quiz:', error);
        }
      console.log("Quiz saved:", quizData);
      alert("Quiz saved successfully!");
    }
  </script>
  
  <AppBar/>

  <div class="full-screen">
    <div class="quiz-editor">
      <h1>Edit Quiz</h1>
  
      <!-- Quiz-Level Information -->
      <div class="form-group">
        <label for="quiz-name">Quiz Name</label>
        <input
          type="text"
          id="quiz-name"
          bind:value={quizData.quizName}
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
  </div>
  
  <style>
    /* Full-screen container */
 .full-screen { 
    width: 100vw;  
    height: 100vh; 
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #f5f5f5;
    padding: 1rem;
    box-sizing: border-box;
    overflow-y: auto; /* Allow the entire page to scroll if content exceeds viewport */
  }

  /* Quiz editor styling */
  .quiz-editor {
    width: 100%;
    max-width: 800px;
    background-color: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    padding: 2.5rem;
    margin-top: 78rem;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  
    .quiz-editor h1 {
      text-align: center;
      margin-bottom: 2rem;
      font-size: 2rem;
      color: #333333;
    }
  
    /* Form group styling */
    .form-group {
      margin-bottom: 1.5rem;
    }
  
    .form-group label {
      display: block;
      font-weight: 600;
      margin-bottom: 0.5rem;
      color: #555555;
    }
  
    .form-group input[type="text"],
    .form-group input[type="number"],
    .form-group select {
      width: 100%;
      padding: 0.75rem 1rem;
      border: 1px solid #cccccc;
      border-radius: 6px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }
  
    .form-group input[type="text"]:focus,
    .form-group input[type="number"]:focus,
    .form-group select:focus {
      border-color: #007BFF;
      outline: none;
    }
  
    /* Questions section styling */
    .questions {
      margin-top: 2rem;
    }
  
    .questions h2 {
      margin-bottom: 1rem;
      font-size: 1.5rem;
      color: #333333;
    }
  
    /* Add button styling */
    .add-button {
      margin-top: 1rem;
      padding: 0.75rem 1.5rem;
      background-color: #28a745;
      border: none;
      color: #ffffff;
      border-radius: 6px;
      cursor: pointer;
      font-size: 1rem;
      transition: background-color 0.3s ease;
    }
  
    .add-button:hover {
      background-color: #218838;
    }
  
    /* Save button styling */
    .save-button {
      margin-top: 3rem;
      padding: 0.75rem 1.5rem;
      background-color: #007bff;
      border: none;
      color: #ffffff;
      border-radius: 6px;
      cursor: pointer;
      font-size: 1.1rem;
      width: 100%;
      transition: background-color 0.3s ease;
    }
  
    .save-button:hover {
      background-color: #0069d9;
    }
  
    /* Responsive adjustments */
    @media (max-width: 600px) {
      .quiz-editor {
        padding: 1.5rem;
      }
  
      .quiz-editor h1 {
        font-size: 1.5rem;
      }
  
      .questions h2 {
        font-size: 1.25rem;
      }
  
      .add-button,
      .save-button {
        font-size: 0.95rem;
        padding: 0.6rem 1.2rem;
      }
    }
  </style>