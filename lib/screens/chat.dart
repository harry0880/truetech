import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:truetech/services/facebooklogin.dart';

import '../constants.dart';
import 'chatModules/messageBubble.dart';
import 'login.dart';

final _firestore = Firestore.instance;
FirebaseUser currentUserName;
bool iscurrentuser = false;
final textController = TextEditingController();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  String userName;
  String userEmail;
  String profilePicURL;

  ChatScreen({this.userName, this.userEmail, this.profilePicURL});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String message;
  Facebooklogin _fbLogin = Facebooklogin();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser _user = await _auth.currentUser();
    return _user;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fbLogin.getCurrentUser().then((value) {
      currentUserName = value;
      if (currentUserName == null) {
        Navigator.popAndPushNamed(context, LoginScreen.id);
      }
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    final ChatScreen args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: VerticalDivider(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(args.profilePicURL),
                radius: 25.0,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /* AutoSizeText(
                  '${args.userName}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  minFontSize: 10.0,
                  overflow: TextOverflow.fade,
                ),*/
                Text(
                  '${args.userName}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  'online',
                  style: TextStyle(fontSize: 10.0),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: kAppBarColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              MessageStream(
                messageReceiver: args.userEmail,
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
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        textController.clear();
                        if (message != null) {
                          _firestore.collection('Messages').add({
                            'sender': currentUserName.email,
                            'text': message,
                            'receiver': args.userEmail
                          });
                        }
                      },
                      child: Text(
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
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final String messageReceiver;

  MessageStream({this.messageReceiver});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final messages = snapshot.data.documents;
          List<MessageBubble> messageWidgets = [];
          for (var message in messages) {
            if ((messageReceiver == message['receiver'] &&
                    currentUserName.email == message['sender']) ||
                (messageReceiver == message['sender'] &&
                    currentUserName.email == message['receiver'])) {
              final messagesender = message['sender'];
              final messageText = message['text'];
              iscurrentuser = currentUserName.email == messagesender;

              final messageBubble = MessageBubble(
                sender: messagesender,
                text: messageText,
                isMe: iscurrentuser,
              );
              messageWidgets.add(messageBubble);
            }
          }

          return Expanded(
              child: ListView(
            children: messageWidgets,
            reverse: true,
          ));
        });
  }
}
