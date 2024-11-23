<script>
    import { onMount } from "svelte";
    import axios from "axios";
    import { user } from "../../stores/user.js";


    let response;
    let offersNotification = false;
    let newsletterNotification = false;
    let recruiterMessages = false;
    let pushNotification = false;

    onMount(async () => {
      const url1 = 'http://localhost:8080/user-service/graphql';
      const query = `
mutation {
  updateCurrentUserSettings(
  settingsRequest: {offersNotification: false,newsletterNotification: false,recruiterMessages: false,pushNotification: false}){
    offersNotification,
    newsletterNotification
  }
}
      `;
  
      try {
        const res = await axios.post(
          url1,
          {query: query},
          
            {headers:{
              "Content-Type": "application/json",
              'Authorization': `Bearer ${$user.jwt}`
            },
        }
            )
  
        response = res.data; // Store response data in a variable
        console.log("Response data:", response);
      } catch (error) {
        console.error(
          "Error:",
          error.response ? error.response.data : error.message
        );
      }
    });
  </script>
  
  <div>
    {#if response}
      <h2>Settings Updated Successfully!</h2>
      <pre>{JSON.stringify(response, null, 2)}</pre>
    {:else}
      <p>Loading...</p>
    {/if}
  </div>
  