// import 'package:flutter/material.dart';
// import 'package:zpi_chat/settings.dart';
//
// import 'recruiter_pages/home.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ChatPage(),
//     );
//   }
// }
//
// class ChatPage extends StatefulWidget {
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   // List of chats
//   List<Chat> chats = [
//     Chat(name: 'Alice', messages: [
//       Message(sender: 'Alice', text: 'Hey there!'),
//       Message(sender: 'You', text: 'Hi Alice, how are you?'),
//     ]),
//     Chat(name: 'Bob', messages: [
//       Message(sender: 'Bob', text: 'Hello!'),
//       Message(sender: 'You', text: 'Hey Bob, what\'s up?'),
//     ]),
//     Chat(name: 'Charlie', messages: [
//       Message(sender: 'Charlie', text: 'Good morning!'),
//       Message(sender: 'You', text: 'Morning Charlie!'),
//     ]),
//   ];
//
//   // Selected chat
//   Chat? selectedChat;
//
//   // Controller for message input
//   final TextEditingController messageController = TextEditingController();
//
//   // Method to send a new message
//   void sendMessage() {
//     if (selectedChat != null && messageController.text.isNotEmpty) {
//       setState(() {
//         selectedChat!.messages.add(Message(sender: 'You', text: messageController.text));
//         messageController.clear();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading:false,
//         title: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 // Navigate to Main Page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomePage()),
//                 );
//               },
//               child: Text("Job Market"),
//             ),
//             Container(width: 20,),
//             GestureDetector(
//               onTap: () {
//                 // Stay on the current Analytics page, or refresh if needed
//               },
//               child: Text("Salaries"),
//             ),
//             Spacer(),
//             IconButton(
//               icon: Icon(Icons.chat_bubble_outline),
//               onPressed: () {
//                 // Chat icon action
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.account_circle),
//               onPressed: () {
//                 // Navigate to settings page
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => UserSettingsPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Row(
//         children: [
//           // Left Panel: List of Chats
//           Container(
//             width: 250,
//             color: Colors.grey[200],
//             child: ListView.builder(
//               itemCount: chats.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(chats[index].name),
//                   onTap: () {
//                     setState(() {
//                       selectedChat = chats[index];
//                     });
//                   },
//                   tileColor: selectedChat == chats[index] ? Colors.blue[100] : null,
//                 );
//               },
//             ),
//           ),
//           // Right Panel: Messages
//           Expanded(
//             child: selectedChat == null
//                 ? Center(child: Text('Select a chat'))
//                 : Column(
//               children: [
//                 // Display messages
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: selectedChat!.messages.length,
//                     itemBuilder: (context, index) {
//                       Message message = selectedChat!.messages[index];
//                       bool isSentByUser = message.sender == 'You';
//                       return Align(
//                         alignment: isSentByUser
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           margin: EdgeInsets.symmetric(vertical: 5),
//                           decoration: BoxDecoration(
//                             color: isSentByUser ? Colors.blue[200] : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Text(message.text),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Message input field
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: messageController,
//                           decoration: InputDecoration(
//                             hintText: 'Type a message',
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(25),
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.send),
//                         onPressed: sendMessage,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Model for Chat
// class Chat {
//   final String name;
//   final List<Message> messages;
//
//   Chat({required this.name, required this.messages});
// }
//
// // Model for Message
// class Message {
//   final String sender;
//   final String text;
//
//   Message({required this.sender, required this.text});
// }
