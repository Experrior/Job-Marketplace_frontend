<script>
  let userId = "";
  let socket;
  let chatId;
  let chatMessages = {}; // In-memory storage of messages for each chat
  let chatList; // Store chat IDs for the user
  let newMessage;
  import { user } from "../../stores/user.js";
  console.log($user.jwt)
  function startChat() {
    if (!userId) {
      alert("Please enter a User ID");
      return;
    }
//     const reqHeaders = new Headers();
//     reqHeaders.set("Authorization", "Bearer COSŁYCHAĆ");
//     const options = {
//   headers: reqHeaders,
// };
    console.log($user.jwt)
    fetch(`http://localhost:8080/chat-service/getUserChats?userId=${userId}`, {headers: {"Authorization": "Bearer "+$user.jwt}})
      .then((response) => response.text())
      .then((data) => {
        console.log(data);

        // Parse chatId from response (assuming the response contains a chat list)
        chatList = JSON.parse(data); // Assuming the response is JSON containing chat list
        chatId = chatList[0];

        if (!chatId) {
          alert("No chats found for this user");
          return;
        }

        if (!chatMessages[chatId]) {
          chatMessages[chatId] = [];
        }

        socket = new WebSocket("ws://localhost:8080/chat-service/ws");

        socket.onopen = () => {
          console.log("WebSocket connection established");
          const request = {
            type: "getAll",
            message: {
              chatId: chatId,
              createdBy: userId,
            },
            Authorization: {
              "Bearer":$user.jwt,
            },
          };
          socket.send(JSON.stringify(request));
        };

        socket.onmessage = (event) => {
          const messages = JSON.parse(event.data);
          if (Array.isArray(messages)) {
            console.log("Messages received:", messages);
            // Add new messages to in-memory storage
            chatMessages[chatId] = [
              ...(chatMessages[chatId] || []),
              ...messages,
            ];
            //   console.log('Updated chat messages:', chatMessages[chatId]);
            alert("Messages: " + JSON.stringify(messages));
          } else {
            // Singular message
            console.log("Single message received:", messages);
            // Add the single message to in-memory storage
            chatMessages[chatId] = [...(chatMessages[chatId] || []), messages];
            //   console.log('Updated chat messages:', chatMessages[chatId]);
            alert("Message: " + JSON.stringify(messages));
          }
        };

        socket.onclose = () => {
          console.log("WebSocket connection closed");
        };
      })
      .catch((error) => console.error("Error:", error));
  }

  function sendManualRequest() {
    if (socket && socket.readyState === WebSocket.OPEN) {
      const request = {
        operation: "get",
        message: {
          chatId: chatId,
          createdBy: userId,
        },
      };
      socket.send(JSON.stringify(request));
      console.log("Manual request sent:", request);
    } else {
      alert("WebSocket is not connected. Please start the chat first.");
    }
  }

  function sendMessage() {
    if (!newMessage) {
      alert("Please enter a message to send.");
      return;
    }

    if (socket && socket.readyState === WebSocket.OPEN && chatList.length > 0) {
      const chatId = chatList[0]; // Use the first chatId from the list
      const message = {
        operation: "post",
        message: {
          content: newMessage,
          chatId: chatId,
          createdBy: userId,
          createdByDisplay:
            "OKAIUHYGTRDESRDFGHBJKNYGTFRDESXFCGVHBGFDRESXFGHBJGFRDESFXGHBJGFDSZA",
        },
      };
      socket.send(JSON.stringify(message));
      console.log("Message sent:", message);
      newMessage = ""; // Clear the input field
    } else {
      alert(
        "WebSocket is not connected or no chat available. Please start the chat first."
      );
    }
  }
</script>

<main>
  <h1>Simple WebSocket Chat App</h1>
  <label for="userId">User ID:</label>
  <input
    type="text"
    bind:value={userId}
    id="userId"
    placeholder="Enter your User ID"
  />
  <button on:click={startChat}>Start Chat</button>
  <button on:click={sendManualRequest}>Send Manual Request</button>

  <div>
    <h2>Chats</h2>
    {#each chatList as chatId}
      <div class="chat-container">
        <h3>Chat ID: {chatId}</h3>
        <ul>
          {#each chatMessages[chatId] as message}
            <li>
              <strong>{message.createdByDisplay}:</strong>
              {message.content}
              <div class="message-info">
                <span>Created At: {message.createdAt}</span>
                <span>Read By: {message.readBy}</span>
              </div>
            </li>
          {/each}
        </ul>
      </div>
    {/each}
  </div>

  <div>
    <h2>Send a Message</h2>
    <input
      type="text"
      bind:value={newMessage}
      id="newMessage"
      placeholder="Enter your message"
    />
    <button on:click={sendMessage}>Send Message</button>
  </div>
</main>
