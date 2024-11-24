<script>
  import { onMount, onDestroy } from "svelte";
  import axios from "axios";
  import {user, verifyUser} from '$lib/stores/user';
  // import { io } from "socket.io-client";



  let isOpen = false;
  let currentChatId = null;
  let newMessage = "";
  let chatMessages = {};
  let chatId = '';
  let chats = [];
  let chatList = [];
  let chatsMap = {};
  let messages = [];
  let chatHumans = {};
  let messagesContainer;

  let socket;

  onMount(async () => {

    await initializeWebSocketConn();
    await getUserChats()
    console.log("CHATTY", chatList)
    console.log("livetowin!", chatMessages)

    // awaitinitializeWebSocketConn();
  });

  async function getUserChats(){
    try {
      const response = await axios.get(
        "http://localhost:8080/chat-service/getUserChats",
        {
          headers: {
            "Content-Type": "application/json",
            'Authorization': `Bearer ${$user.jwt}`
          },
        }
      );
      console.log("getUserChats:", response);

      if (response.status !== 200) {
        throw new Error(`Error fetching chats: ${response.statusText}`);
      }

      console.log('chattts')
      chatList = response.data;
      if (chatList.length > 0) {
        selectChat(chatList[0].ChatId);
        for (const chat in chatList) {
          chatsMap[chat.ChatId] = chat
        }
      }
    } catch (error) {
      console.error(error);
    }

  }

  // Clean up WebSocket connection on component destroy
  onDestroy(() => {
    if (socket && socket.readyState === WebSocket.OPEN) {
      socket.close();
      console.log("CLOOOOOOSED WEEBSOCKT!!!!")
    }
  });

  // Function to toggle the chat box visibility
  async function toggleChatBox() {
    isOpen = !isOpen;
    await getUserChats()

    // Optionally, fetch messages for the current chat when opening
    // if (isOpen && currentChatId !== null) {
    //   fetchMessages(currentChatId);
    // }
  }

  // Function to select a chat
  async function selectChat(chatId) {
    currentChatId = chatId;
    await fetchMessages(chatId);
  }

  async function fetchMessages(chatId) {
    console.log("BAMBUS", socket.readyState)
    console.log(chatId)
  if (socket && socket.readyState) {
    const request = {
      operation: "get",
        message: {
          ChatId: chatId,
          CreatedBy: $user.userId,
        },
    };
    
    socket.send(JSON.stringify(request));
    
  } else {
    console.error("WebSocket is not connected or not open");
  }
}

  // Function to initialize WebSocket connection
  async function initializeWebSocketConn() {
    socket = await new WebSocket("ws://localhost:8080/chat_service/ws",);
    console.log("DEBUGGG1")
    socket.onopen = () => {
      console.log("WebSocket connection established");
      // Optionally, authenticate or send initial messages
    };

    socket.onmessage = (event) => {
          const messages = JSON.parse(event.data);
          console.log("aiujhygt",messages)
          var isMessage='';
          try {
             isMessage = (messages[0].content)
          }catch (error) {
             isMessage = false
          }
          

          if (isMessage) {
            console.log("STARE WIEŚCI", chatMessages)
            if (Array.isArray(messages)) {
              console.log("Messages received:", messages, "for chatId: ", currentChatId);
              // Add new messages to in-memory storage
              chatMessages[currentChatId] = [
                ...(chatMessages[currentChatId] || []),
                ...messages,
              ];
                console.log('Updated chat messages:', chatMessages[currentChatId]);
              // alert("Messages: " + JSON.stringify(messages));
            } else {
              console.log("Single message received:", messages);
              chatMessages[currentChatId] = [...(chatMessages[currentChatId] || []), messages];
              console.log('Updated chat messages:', chatMessages[currentChatId]);
            }
            console.log("MESAŻĘ:", chatMessages)
            console.log("i to ", messages)
          }else{
            console.log("co my tu mamy: ", messages)
          }
          

        };

    socket.onclose = async (event) => {
      console.log("WebSocket connection closed:", event.reason);
    };

    socket.onerror = async (error) => {
      console.error("WebSocket error:", error);
    };

    socket.onopen = async () => {
      console.log('oneopen:')
      if (currentChatId){
        const request = {
        operation: "getAll",
          message: {
          chatId: chatId,
          CreatedBy: $user.userId,
        },
      };
      socket.send(JSON.stringify(request));
      console.log('sent getAll')
      }else{
        console.log("onopen ot actived")
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


  async function sendManualRequest() {
    if (socket && socket.readyState === WebSocket.OPEN) {
      const request = {
        operation: "get",
        message: {
          ChatId: chatId,
          CreatedBy: userId,
        },
      };
      await socket.send(JSON.stringify(request));
      console.log("Manual request sent:", request);
    } else {
      alert("WebSocket is not connected. Please start the chat first.");
      await initializeWebSocketConn()
    }
  }


  async function sendMessage(chatId) {
    if (!newMessage) {
      alert("Please enter a message to send.");
      return;
    }
    console.log("State", socket.readyState)
    if (socket && socket.readyState === 1) {
      const chatId = chatList[0].ChatId;
      console.log("Casdasdas", chatList)

      const message = {
        operation: "post",
        message: {
          Content: newMessage,
          ChatId: chatId,
          CreatedBy: $user.userId,
          CreatedByDisplay: "TODO USERNAME"
        },
      };
      await socket.send(JSON.stringify(message));
      console.log("Message sent:", message);
      newMessage = ""; // Clear the input field
      console.log('xd')
    } else {
      console.log('still fail')
      await initializeWebSocketConn()
      console.log("restarting websocket")
    }
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
            {#each chatList as chat}
              <!-- <text>{chat}</text> -->
              <li
                class:active={chat.id === currentChatId}
                on:click={() => selectChat(chat.ChatId)}>
                {$user.userId === chat.ApplicantId ? chat.RecruiterName : chat.ApplicantName}
              </li>
            {/each}
          </ul>
        </div>

        <!-- Message area --> 
        <div class="message-area">
          {#if currentChatId !== null}
          <!-- <text>`${chatMessages}`</text> -->
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
                on:keydown={(e) => e.key === "Enter" && sendMessage(currentChatId)}
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
