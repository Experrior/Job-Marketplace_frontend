import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zpi_chat/providers/websocket_provider.dart'; // Adjust the import according to your project structure

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WebSocketProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatListScreen(), // Set the initial screen to the chat list
    );
  }
}

class ChatListScreen extends StatelessWidget {
  
  int userId = 1;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WebSocketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Consumer<WebSocketProvider>(
        builder: (context, provider, child) {
          // Get the list of chat IDs
          final chatIds = provider.chatMessages.keys.toList();

          if (chatIds.isEmpty) {
            return Center(child: Text('No chats available.'));
          }

          return ListView.builder(
            itemCount: chatIds.length,
            itemBuilder: (context, index) {
              final chatId = chatIds[index];
              return ListTile(
                title: Text('Chat ID: $chatId'),
                onTap: () {
                  // Navigate to the chat screen for this chat ID
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(chatId: chatId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String userId ="1";
  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WebSocketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat ID: $chatId'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<WebSocketProvider>(
              builder: (context, provider, child) {
                final messages = provider.chatMessages[chatId] ?? [];

                if (messages.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message['content']),
                      subtitle: Text('From: ${message['createdBy'] == userId ? 'Me' : message['createdByDisplay']}'),

                    );
                  },
                );
              },
            ),
          ),
          _MessageInput(chatId: chatId), // Input field for sending messages
        ],
      ),
    );
  }
}

class _MessageInput extends StatefulWidget {
  final String chatId;

  _MessageInput({required this.chatId});

  @override
  __MessageInputState createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isNotEmpty) {
      Provider.of<WebSocketProvider>(context, listen: false).sendMessage(content, widget.chatId);
      _controller.clear(); // Clear the input field after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Type your message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
