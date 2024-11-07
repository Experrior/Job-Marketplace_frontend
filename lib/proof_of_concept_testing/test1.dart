import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expandable Chat Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // List of available chats
  final List<String> chats = [
    "Chat 1",
    "Chat 2",
    "Chat 3",
    "Chat 4",
  ];

  // Boolean to control the expansion of the chat widget
  bool isExpanded = false;

  // Controller for the text input
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Page')),
      body: Center(child: Text('Your content goes here!')),

      // Floating Action Button that expands to show chat options


      // Display the FAB at the bottom-right corner
      // floatingActionButtonLocation: FloatingActionButtonLocation.endBottom,
    );
  }
}


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Sample data for available chats
  List<ChatUser> availableChats = [
    ChatUser('User 1', 'assets/user1.jpg', ['Hello!', 'How are you?']),
    ChatUser('User 2', 'assets/user2.jpg', ['Hey there!', 'What\'s up?']),
    ChatUser('User 3', 'assets/user3.jpg', ['Good morning!', 'Let\'s chat.']),
  ];

  ChatUser? currentChat;

  @override
  Widget build(BuildContext context) {
    return Container(width: 640, height: 640,
    child: Scaffold(
      appBar: AppBar(title: Text('Chat App')),
      body: Row(
        children: [
          // Left side: List of available chats
          Container(
            width: 120,
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: availableChats.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(availableChats[index].image),
                  ),
                  title: Text(availableChats[index].name),
                  onTap: () {
                    setState(() {
                      currentChat = availableChats[index];
                    });
                  },
                );
              },
            ),
          ),

          // Right side: Main space for displaying messages from the current chat
          Expanded(
            child: currentChat == null
                ? Center(child: Text('Select a chat'))
                : Column(
              children: [
                // Message list
                Expanded(
                  child: ListView.builder(
                    itemCount: currentChat!.messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(currentChat!.messages[index]),
                      );
                    },
                  ),
                ),

                // Message input field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          // Handle send message logic
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}

class ChatUser {
  final String name;
  final String image;
  final List<String> messages;

  ChatUser(this.name, this.image, this.messages);
}
