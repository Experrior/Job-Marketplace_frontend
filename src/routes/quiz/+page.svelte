<script>
    import { onMount } from 'svelte';
    import { writable, get } from 'svelte/store';
    import { user, verifyUser} from '$lib/stores/user';
    import axios from 'axios';
    import { goto } from '$app/navigation';
    import Cookie from 'js-cookie';

    // let quizId = $page.params.slug;
    const urlParams = new URLSearchParams(window.location.search);
    const resumeId = urlParams.get('resume');
    const quizId = urlParams.get('quizId');
    const jobId = urlParams.get('jobId');
    console.log("QUIZID: ", quizId)
    var quizData = {};
    let quizSubmitted = false;
    let currentQuestionIndex = 0;
    let selectedAnswers = writable([]);
    let timer= 600;
    let score = 0;


    const apiGateway = import.meta.env.VITE_GATEWAY_URL;
    console.log("USING GATEWAY:", apiGateway);

    onMount(async() => {

      //todo change to disauthenticate once a authenticated request fails with code 401
      if (!verifyUser()){
        goto('/login')
      }
        
        console.log(')')
        const query = `
        query XD($quizIdi: ID!){
       quizById(quizId: $quizIdi){
            # quizId
            quizName
            s3QuizUrl
            }
        }`

      const variables = {
          quizIdi:quizId
        };
      const response = await axios.post(`${apiGateway}/job-service/graphql`, {
            query: query,
            variables: variables
          }, {headers:{
                    "Content-Type": "application/json",
                    'Authorization': `Bearer ${$user.jwt}`
                  } }
      )
      console.log('test1')
      console.log('Response: ', response.data)
    let quizS3 = response.data.data.quizById.s3QuizUrl
    console.log('QuizS3 url: ', quizS3)
    const json1 = await axios.get(quizS3,
    {headers: {
        'Content-Type': 'application/json',
        }
    }
    )
    console.log(quizS3)
    console.log(json1.data)
    quizData = json1.data
    console.log(quizData)
    console.log('8765dyrcgjvhkg')
    timer = quizData.timeLimit;
    console.log(`tiem is: ${timer}`)
    console.log(quizData)

  
    });

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
      if (quizData.goBack && currentQuestionIndex > 0) {
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
  

    async function sendResults(timeTaken) {

      
      const mutation=`mutation XD($quizResultRequest: QuizResultInput!){
    submitQuizResult(quizResultRequest: $quizResultRequest){
        quizResultId,
        quizId,
        applicantId,
        timeTaken
        score
    }
    }`
    const variables = {
        quizResultRequest: {
            quizId: quizId,
            score: score,
            timeTaken:  timeTaken
          }

    }

    const response = await axios.post(`${apiGateway}/job-service/graphql`,
      {
        query: mutation,
        variables: variables
      }, {headers:{
                    "Content-Type": "application/json",
                    'Authorization': `Bearer ${$user.jwt}`
                  }}
    )
    console.log("CREATING quiz result RESPONSE:", response)
    
    const response2 = await axios.get(Cookie.get('s3Path'),
      {
        query: mutation,
        variables: variables
      }, {headers:{
                    'Content-Type': 'multipart/form-data',
                  }}
    )

    let quizResultId = response.data.data.submitQuizResult.quizResultId;
    console.log('dthgfdrse')
    console.log(response2)
    
    const pdfBlob = new Blob([response2.data], { type: 'application/pdf' });

    const formData = new FormData();
    console.log($user.jwt)

      formData.append('resume', pdfBlob);
      formData.append('quizResultId', response.data.data.submitQuizResult.quizResultId)
      console.log('sciek1')
      console.log(formData)
      console.log(Cookie.get('jobId'))

      const query2 = `mutation XD($jobIDvar: ID!, $resumeIDvar: ID!, $quizResultIDvar: ID!){
          applyForJob(
              jobId: $jobIDvar
              resumeId: $resumeIDvar
              quizResultId: $quizResultIDvar
          ){
              applicationId
              userId
              job {
                  jobId
              }
              status
              fullName
              createdAt
              resumeUrl
          }
      }`

    const variables2 = {
      "jobIDvar": jobId,
      "resumeIDvar": resumeId,
      "quizResultIDvar": quizResultId
      
    };
      try {
        const response = await axios.post(`${apiGateway}/job-service/graphql`, {
          query: query2,
          variables: variables2
        }, {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${localStorage.getItem('jwt')}`
          },})

          console.log(response)
        }catch (error){
          console.error(error)
        }
    

    }

    async function submitQuiz() {
      quizSubmitted = true;
      let timeTaken = calculateScore();

      await sendResults(timeTaken);
      await new Promise(r => setTimeout(r, 5000));
      goto('/')

    };
  
    const calculateScore = () => {
      const selected = get(selectedAnswers);
      console.log('NIEsdas')
      const timeTaken = quizData.timeLimit - timer
      var points = 0
      console.log(timeTaken)
      quizData.questions.forEach((question, index) => {
        if (selected[index]) {
          const correctAnswers = question.answers
            .map((answer, i) => (answer.isCorrect ? i : null))
            .filter((i) => i !== null);
          const selectedCorrectly = selected[index].every((i) => correctAnswers.includes(i));
          const allCorrect = correctAnswers.length === selected[index].length;
          
          if (selectedCorrectly && allCorrect) {
            points += 1;
          }
        }
      }
    );
    // IMPORTANT -to send in percentage
    score = points/quizData.questions.length * 100 
      console.log('sdas')
      quizSubmitted = true;
      return timeTaken
    };
  </script>
  
  <main>
    <h1>{quizData.quizName}</h1>
    {#if !quizSubmitted}
      <p class="timer">Time remaining: {timer} seconds</p>
    
    {#await quizData}
    <p> Loading...</p>

    {:then quizData}

      {#if quizData.questions}

      <div class="question-container">
        <p class="question-number">Question {currentQuestionIndex + 1} of {quizData.questions.length}</p>
        <h2>{quizData.questions[currentQuestionIndex].title}</h2>
  
        <div class="answers">
          {#each quizData.questions[currentQuestionIndex].answers as answer, index}
            <label class="answer-option">
              <input
                type={quizData.questions[currentQuestionIndex].type === "single" ? "radio" : "checkbox"}
                name="answer"
                checked={$selectedAnswers[currentQuestionIndex] && $selectedAnswers[currentQuestionIndex].includes(index)}
                on:change={() => handleAnswerSelect(index)}
              />
              {answer.text}
            </label>
          {/each}
        </div>
      </div>


                <div class="navigation">
                    {#if quizData.goBack && currentQuestionIndex > 0}
                      <button on:click={goToPreviousQuestion} class="nav-btn">Previous</button>
                    {/if}
                    
                    {#if currentQuestionIndex < quizData.questions.length - 1}
                      <button on:click={goToNextQuestion} class="nav-btn">Next</button>
                    {:else}
                      <button on:click={submitQuiz} class="submit-btn">Submit</button>
                    {/if}
                </div>
        <!-- {:else} -->

        {/if}
                
     
     {:catch error}
      <p style="color: red">{error.message}</p>
    {/await}
    {:else}
    <p>Thank you for taking the quiz!</p>
    <p>Your score is: {score.toFixed(2)}% </p>
    <p> You can view your score again on given job offer page</p>

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
  