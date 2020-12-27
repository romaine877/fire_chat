import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

User loggedinUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String message;
  final _textEditingController = TextEditingController();
  bool isDisabled = true;

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }

  void getMessages() async {
    final messages = await _firestore.collection('messages').get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void messageStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  void getUserEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
      print(loggedinUser.email);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        message = value.trim();

                        print(message.length);
                        if (message != null) {
                          setState(() {
                            isDisabled = false;
                          });
                        }
                        if (message.length == 0) {
                          setState(() {
                            isDisabled = true;
                          });
                        }
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: isDisabled
                        ? null
                        : () {
                            _textEditingController.clear();
                            _firestore.collection('messages').add({
                              'text': message,
                              'sender': loggedinUser.email,
                              'time': FieldValue.serverTimestamp()
                            });
                            setState(() {
                              isDisabled = true;
                            });
                          },
                    child: isDisabled
                        ? null
                        : Text(
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

class MessagesStream extends StatelessWidget {
  const MessagesStream({
    Key key,
    @required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageText = message.data()['text'];
            final senderName = message.data()['sender'];
            final messageTime = message.data()['time'] as Timestamp;
            final currentUser = loggedinUser.email;
            final messageBubble = MessageBubble(
              sender: senderName,
              text: messageText,
              isMe: currentUser == senderName,
              time: messageTime,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String sender, text;
  final bool isMe;
  final Timestamp time;

  MessageBubble({this.sender, this.text, this.isMe, this.time});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Material(
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              elevation: 5,
              color: isMe ? Colors.lightBlueAccent : Colors.lightGreenAccent,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
