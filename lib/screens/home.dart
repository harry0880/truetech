import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:truetech/screens/chat.dart';
import 'package:truetech/screens/login.dart';
import 'package:truetech/screens/userProfile.dart';
import 'package:truetech/services/facebooklogin.dart';

import '../constants.dart';

FirebaseUser userName;

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Facebooklogin _fbLogin = Facebooklogin();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fbLogin.getCurrentUser().then((value) {
      userName = value;
      if (userName == null) {
        Navigator.popAndPushNamed(context, LoginScreen.id);
      }
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldColor,
      appBar: AppBar(
        title: Text("Chats"),
        backgroundColor: kAppBarColor,
        elevation: 0.7,
        actions: <Widget>[
          Icon(Icons.search),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, UserProfile.id,
                  arguments: UserProfile(
                      /* userName: username,
                    userEmail: email,
                    profilePicURL: profilePicURL,*/
                      ));
            },
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          UserTile(),
        ],
      )),
    );
  }
}

class UserTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Facebooklogin().getuserlist(),
        builder: (context, snapshot) {
          List<UserList_rows> userlist = [];
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data.documents;

            for (var singleUserData in data) {
              if (userName.email != singleUserData['Email']) {
                userlist.add(UserList_rows(
                  username: singleUserData['Name'],
                  profilePicURL: singleUserData['ProfilePic'],
                  email: singleUserData['Email'],
                ));
              }
            }
            return Expanded(child: ListView(children: userlist));
          } else {
            return CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            );
          }
        });
  }
}

class UserList_rows extends StatelessWidget {
  final String username;
  final String profilePicURL;
  final String email;

  UserList_rows(
      {@required this.username,
      @required this.profilePicURL,
      @required this.email});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(email);
        Navigator.pushNamed(context, ChatScreen.id,
            arguments: ChatScreen(
              userName: username,
              userEmail: email,
              profilePicURL: profilePicURL,
            ));
      },
      child: Column(
        children: <Widget>[
          new Divider(
            height: 10.0,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('$profilePicURL'),
              radius: 30.0,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '1:11',
                  style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
              ],
            ),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Text(
                'Hi Tom',
                style: new TextStyle(color: Colors.grey, fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
