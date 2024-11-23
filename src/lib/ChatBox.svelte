<script>
  import { onMount, onDestroy } from "svelte";
  import axios from "axios";

  let isOpen = false;
  let currentChatId = null;
  let newMessage = "";

  let chats = [];

  let messages = [];

  let messagesContainer;

  let socket;

  const user_id = "aa18e40c-4862-4918-af91-e742d29afc7e";

  onMount(async () => {

    initializeWebSocket();
    try {
      const response = await axios.get(
        "http://localhost:8080/chat-service/getUserChats?userId=" + user_id,
        {
          headers: {
            "Content-Type": "application/json",
          },
        }
      );
      console.log(response);

      if (response.status !== 200) {
        throw new Error(`Error fetching chats: ${response.statusText}`);
      }

      chats = response.data; // Adjust based on your API response structure

      // Optionally, select the first chat by default
      if (chats.length > 0) {
        selectChat(chats[0]);
      }
    } catch (error) {
      console.error(error);
    }

    initializeWebSocket();
  });

  // Clean up WebSocket connection on component destroy
  onDestroy(() => {
    if (socket && socket.readyState === WebSocket.OPEN) {
      socket.close();
    }
  });

  // Function to toggle the chat box visibility
  function toggleChatBox() {
    isOpen = !isOpen;

    // Optionally, fetch messages for the current chat when opening
    if (isOpen && currentChatId !== null) {
      fetchMessages(currentChatId);
    }
  }

  // Function to select a chat
  function selectChat(chatId) {
    currentChatId = chatId;
    fetchMessages(chatId);
  }

  async function fetchMessages(chatId) {
  if (socket && socket.readyState === WebSocket.OPEN) {
    // Send a message to the WebSocket server requesting the messages for a specific chat
    const request = {
      type: "getAll",
      chatId: chatId,
      userId: user_id, // Include user ID for identification
    };
    socket.send(JSON.stringify(request));
  } else {
    console.error("WebSocket is not connected or not open");
    // Optionally, you can attempt reconnection logic here
  }
}

function handleIncomingMessage(message) {
  switch (message.type) {
    case "chatMessages":
      if (message.chatId === currentChatId) {
        // Update messages when we receive them
        messages = message.messages;
        scrollToBottom();
      }
      break;

    case "newMessage":
      if (message.chatId === currentChatId) {
        messages = [...messages, message.message];
        scrollToBottom();
      }
      break;

    default:
      console.warn("Unknown message type:", message.type);
  }
}
  // Function to initialize WebSocket connection
  function initializeWebSocket() {
    socket = new WebSocket("ws://localhost:8080/chat-service/ws");
    console.log("DEBUGGG1")
    socket.onopen = () => {
      console.log("WebSocket connection established");
      // Optionally, authenticate or send initial messages
    };

    socket.onmessage = (event) => {
      try {
        const message = JSON.parse(event.data);
        console.log(event)
        handleIncomingMessage(message);
      } catch (error) {
        console.error("Error parsing WebSocket message:", error);
      }
    };

    socket.onclose = (event) => {
      console.log("WebSocket connection closed:", event.reason);
      // Optionally, attempt to reconnect
    };

    socket.onerror = (error) => {
      console.error("WebSocket error:", error);
      // Handle error
    };
  }

  // Function to handle incoming WebSocket messages
  // function handleIncomingMessage(message) {
  //   // Assuming the message structure matches your messages array
  //   // You might need to adjust based on your actual message format
  //   messages = [...messages, message];
  //   scrollToBottom();
  // }

  // Function to send a message via WebSocket
  function sendMessage() {
    if (newMessage.trim() !== "" && currentChatId !== null) {
      const message = {
        createdBy: user_id,
        chatId: currentChatId,
        content: newMessage.trim(),
      };

      // Send the message through WebSocket
      if (socket && socket.readyState === WebSocket.OPEN) {
        socket.send(JSON.stringify(message));
        // Optionally, add the message to the local state immediately
        messages = [
          ...messages,
          {
            ...message,
            sender: "You",
            id: messages.length + 1, // Or use a unique ID generator
          },
        ];
        newMessage = "";
        scrollToBottom();
      } else {
        console.error("WebSocket is not connected");
        // Optionally, queue the message or notify the user
      }
    }
  }

  // Function to scroll the messages container to the bottom
  function scrollToBottom() {
    setTimeout(() => {
      if (messagesContainer) {
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
      }
    }, 0);
  }
</script>

<div class="chat-box-container">
  <!-- Chat header -->
  <div
    class="chat-header"
    role="button"
    tabindex="0"
    on:click={toggleChatBox}
    on:keydown={(e) => {
      if (e.key === "Enter" || e.key === " ") {
        toggleChatBox();
        e.preventDefault();
      }
    }}
  >
    {isOpen ? "Hide Chat" : "Open Chat"}
  </div>

  <!-- Chat box content -->
  {#if isOpen}
    <div class="chat-box">
      <div class="chat-content">
        <!-- Chat list -->
        <div class="chat-list-container">
          <ul class="chat-list">
            {#each chats as chat}
              <text>{chat}</text>
              <li
                class:active={chat.id === currentChatId}
                on:click={() => selectChat(chat.id)}>
                {chat.name}
              </li>
            {/each}
          </ul>
        </div>

        <!-- Message area -->
        <div class="message-area">
          {#if currentChatId !== null}
            <!-- Messages -->
            <div class="messages-container" bind:this={messagesContainer}>
              <ul class="messages">
                {#each messages.filter((msg) => msg.chatId === currentChatId) as message}
                  <li
                    class="message {message.sender === 'You'
                      ? 'right'
                      : 'left'}"
                  >
                    <div class="bubble">
                      {message.content || message.text}
                    </div>
                  </li>
                {/each}
              </ul>
            </div>

            <!-- Input area -->
            <div class="input-area">
              <input
                type="text"
                placeholder="Type a message..."
                bind:value={newMessage}
                on:keydown={(e) => e.key === "Enter" && sendMessage()}
              />
            </div>
          {:else}
            <!-- Placeholder when no chat is selected -->
            <div
              class="messages-container"
              style="display: flex; align-items: center; justify-content: center;"
            >
              <p>Select a chat to start messaging</p>
            </div>
          {/if}
        </div>
      </div>
    </div>
  {/if}
</div>

<style>

  .chat-box-container {
    position: fixed;
    bottom: 20px;
    right: 20px;
    font-family: Arial, sans-serif;
    z-index: 1000;
  }

  .chat-header {
    background-color: #007bff;
    color: white;
    padding: 10px;
    cursor: pointer;
    border-radius: 5px 5px 5px 5px;
  }

  .chat-box {
    width: 400px;
    max-height: 500px;
    background-color: #fff;
    border: 1px solid #ccc;
    border-top: none;
    border-radius: 0 0 5px 5px;
    display: flex;
    flex-direction: column;
  }

  .chat-content {
    display: flex;
    flex: 1;
    overflow: hidden;
  }

  .chat-list-container {
    width: 150px;
    border-right: 1px solid #ccc;
    overflow-y: auto;
  }

  .chat-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .chat-list li {
    padding: 10px;
    cursor: pointer;
    border-bottom: 1px solid #eee;
  }

  .chat-list li:hover,
  .chat-list li.active {
    background-color: #f1f1f1;
  }

  .message-area {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .messages-container {
    flex: 1;
    overflow-y: auto;
    padding: 10px;
    background-color: #fafafa;
  }

  .messages {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .message {
    display: flex;
    margin-bottom: 10px;
  }

  .message .bubble {
    max-width: 70%;
    padding: 8px 12px;
    border-radius: 15px;
    position: relative;
    word-wrap: break-word;
  }

  .message.left {
    justify-content: flex-start;
  }

  .message.left .bubble {
    background-color: #e0e0e0;
    border-bottom-left-radius: 0;
  }

  .message.right {
    justify-content: flex-end;
  }

  .message.right .bubble {
    background-color: #007bff;
    color: white;
    border-bottom-right-radius: 0;
  }

  .input-area {
    padding: 10px;
    border-top: 1px solid #ccc;
  }

  .input-area input {
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
  }

  .chat-box {
    display: flex;
    flex-direction: column;
    min-height: 250px;
    max-height: 250px;
  }

  .chat-content {
    flex: 1;
    min-height: 0;
  }
</style>
