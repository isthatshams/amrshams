import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('messages');
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _messagesRef.onChildAdded.listen((event) {
      setState(() {
        _messages.add({
          "senderName": event.snapshot.child("senderName").value,
          "text": event.snapshot.child("text").value,
          "timestamp": event.snapshot.child("timestamp").value,
        });
      });
    });
  }

  Future<void> _sendMessage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || _messageController.text.isEmpty) return;

    final messageData = {
      "senderId": currentUser.uid,
      "senderName": currentUser.email ?? "Anonymous",
      "text": _messageController.text,
      "timestamp": DateTime.now().toIso8601String(),
    };

    await _messagesRef.push().set(messageData);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isMe = message['senderName'] ==
                    FirebaseAuth.instance.currentUser?.email;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.red : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(15),
                        topRight: const Radius.circular(15),
                        bottomLeft: Radius.circular(isMe ? 15 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['senderName'] ?? "Unknown",
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message['text'] ?? "",
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          message['timestamp'] ?? "",
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.red,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
