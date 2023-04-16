import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/bubble_chat.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
String lastUser = '';

class ChatScreen extends StatefulWidget {
  static String id = 'chatscreen';

  const ChatScreen({super.key});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context); //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                List<MyMessageBubble> messageBubbles = [];
                List<MyMessageBubble> reverseBubbles = [];
                final messages = snapshot.data?.docs;
                final currentUser = loggedInUser.email;

                for (var message in messages!) {
                  final messageText = message.get('text');
                  final emailSender = message.get('sender');
                  final messageSender = message.get('sender').split("@")[0];
                  final messageBubble = MyMessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: currentUser == emailSender,
                    isLastSender: lastUser == emailSender,
                  );
                  messageBubbles.add(messageBubble);
                  lastUser = emailSender;
                }
                reverseBubbles = List.from(messageBubbles.reversed);

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    children: reverseBubbles,
                  ),
                );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      textController.clear();
                      //messageText + _auth.currentUser?.email
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': _auth.currentUser?.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
