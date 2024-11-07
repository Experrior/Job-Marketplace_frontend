import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider with ChangeNotifier {
  late WebSocketChannel _channel;
  String userId = '694f2be7-23e6-4dce-8a31-4fae236cb928';
  String username = 'John';
  Map<String, List<Map<String, dynamic>>> chatMessages = {};

  WebSocketProvider() {
    _fetchAllChatsAndConnect();
  }


  Future<void> _fetchAllChatsAndConnect() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8088/getUserChats?userId=$userId'));

      if (response.statusCode == 200) {

        for (var chat in json.decode(response.body)) {
          chatMessages[chat['chat_id']] = [];
          print(chat['chat_id']);
        }
        _connect();
      } else {
        print('Failed to load chat IDs: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching chat IDs: $error');
    }
  }


  void _connect() {
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8088/ws')
    );


    _channel.stream.listen((message) {
      _onMessageReceived(message);
    });


    _sendInitMessage();
  }


  void _sendInitMessage() {
    for (String key in chatMessages.keys) {
      final specialMessage = json.encode({
        'operation': 'get',
        'message': {
          'chatId': key
        }
      });
      _channel.sink.add(specialMessage);
    }

  }


  void sendMessage(String content, String chatId) {
    final message = json.encode({
      'operation': 'post',
      'message': {
        'createdBy': userId,
        'chatId': chatId,
        'content': content,
        'createdByDisplay': username
      }
    });
    _channel.sink.add(message);
  }

  void _onMessageReceived(String message) {
    print(message);


    final List<Map<String, dynamic>> decodedMessages = List<Map<String, dynamic>>.from(json.decode(message));

    for (var decodedMessage in decodedMessages) {
      String chatId = decodedMessage['chatId'];
      Map<String, dynamic> newMessage = {
        'content': decodedMessage['content'],
        'createdBy': decodedMessage['createdBy'],
        'createdByDisplay': decodedMessage['createdByDisplay'],
        'timestamp': decodedMessage['timestamp'],
      };


      if (!chatMessages.containsKey(chatId)) {
        chatMessages[chatId] = [];
      }


      chatMessages[chatId]!.add(newMessage);
    }

    notifyListeners();
  }
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}
