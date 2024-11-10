<script>
  import { onMount } from 'svelte';

  // State variables
  let isOpen = false;
  let currentChatId = null;
  let newMessage = '';

  // Mock data for chats and messages
  const chats = [
    { id: 1, name: 'Chat with Alice' },
    { id: 2, name: 'Chat with Bob' },
    { id: 3, name: 'Group Chat' },
  ];

  let messages = [
    { id: 1, chatId: 1, sender: 'Alice', text: 'Hi there!' },
    { id: 2, chatId: 1, sender: 'You', text: 'Hello!' },
    { id: 3, chatId: 1, sender: 'Alice', text: 'How are you?' },
    { id: 4, chatId: 1, sender: 'You', text: 'I am good, thanks!' },
    // Add more messages to test scrolling
  ];

  // Functions to handle user interactions
  function toggleChatBox() {
    isOpen = !isOpen;
  }

  function selectChat(chatId) {
    currentChatId = chatId;
  }

  function sendMessage() {
    if (newMessage.trim() !== '') {
      messages = [
        ...messages,
        {
          id: messages.length + 1,
          chatId: currentChatId,
          sender: 'You',
          text: newMessage,
        },
      ];
      newMessage = '';
      // Scroll to the bottom after sending a message
      scrollToBottom();
    }
  }

  let messagesContainer;

  function scrollToBottom() {
    setTimeout(() => {
      if (messagesContainer) {
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
      }
    }, 0);
  }

  // Scroll to bottom when messages change
  $: if (messagesContainer && currentChatId !== null) {
    scrollToBottom();
  }
</script>

<style>
  /* Positioning the chat box in the bottom left corner */
  .chat-box-container {
    position: fixed;
    bottom: 20px;
    left: 20px;
    font-family: Arial, sans-serif;
    z-index: 1000;
  }

  /* Styling the chat header */
  .chat-header {
    background-color: #007bff;
    color: white;
    padding: 10px;
    cursor: pointer;
    border-radius: 5px 5px 0 0;
  }

  /* Styling the chat box */
  .chat-box {
    width: 400px;
    max-height: 500px; /* Set a maximum height for the chat box */
    background-color: #fff;
    border: 1px solid #ccc;
    border-top: none;
    border-radius: 0 0 5px 5px;
    display: flex;
    flex-direction: column;
  }

  /* Flex container for chats and messages */
  .chat-content {
    display: flex;
    flex: 1;
    overflow: hidden;
  }

  /* Styling the chat list */
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

  /* Styling the message area */
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

  /* Messages from others (left side) */
  .message.left {
    justify-content: flex-start;
  }

  .message.left .bubble {
    background-color: #e0e0e0;
    border-bottom-left-radius: 0;
  }

  /* Messages from the user (right side) */
  .message.right {
    justify-content: flex-end;
  }

  .message.right .bubble {
    background-color: #007bff;
    color: white;
    border-bottom-right-radius: 0;
  }

  /* Styling the input area */
  .input-area {
    padding: 10px;
    border-top: 1px solid #ccc;
  }

  .input-area input {
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
  }

  /* Adjustments to prevent overflow */
  .chat-box {
    display: flex;
    flex-direction: column;
    min-height: 250px;
    max-height: 250px;
  }

  .chat-content {
    flex: 1;
    min-height: 0; /* Necessary to make flex children shrink properly */
  }
</style>

<div class="chat-box-container">
  <!-- Chat header -->
  <div class="chat-header" on:click={toggleChatBox}>
    {isOpen ? 'Minimize Chat' : 'Open Chat'}
  </div>

  <!-- Chat box content -->
  {#if isOpen}
    <div class="chat-box">
      <div class="chat-content">
        <!-- Chat list -->
        <div class="chat-list-container">
          <ul class="chat-list">
            {#each chats as chat}
              <li
                class:active={chat.id === currentChatId}
                on:click={() => selectChat(chat.id)}
              >
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
                {#each messages.filter(msg => msg.chatId === currentChatId) as message}
                  <li
                    class="message {message.sender === 'You' ? 'right' : 'left'}"
                  >
                    <div class="bubble">
                      {message.text}
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
                on:keydown={(e) => e.key === 'Enter' && sendMessage()}
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
