import 'package:flutter/material.dart';
import 'package:truetech/services/facebooklogin.dart';
import 'package:truetech/utilities/user.dart';
import 'package:flutter/widgets.dart';

class UserProfile extends StatefulWidget {
  static const String id = 'profile_screen';

  String userName;
  String userEmail;
  String profilePicURL;

  UserProfile({this.userName, this.userEmail, this.profilePicURL});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Facebooklogin _fbLogin = Facebooklogin();
  User user = User();

  @override
  void initState() {
    super.initState();
    _fbLogin.getCurrentUser().then((value) {
      _fbLogin.getCurrentuserData(value.email).then((snapshot) {
        var data = snapshot.documents;
        for (var currentUser in data) {
          user.userName = currentUser['Name'];
          user.userMailid = currentUser['Email'];
          user.userProfilePicURL = currentUser['ProfilePic'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(user.getuserUrl),
                radius: 60.0,
              ),
              Card(
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  color: Colors.white,
                  child: ListTile(
                    leading: Icon(Icons.verified_user,
                        color: Colors.lightBlueAccent, size: 30.0),
                    title: Text(
                      user.getuserName,
                      style: TextStyle(color: Colors.teal, fontSize: 23.0),
                    ),
                  )),
              RaisedButton(
                child: Text('LogOut'),
                onPressed: () {
                  Facebooklogin().logOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
