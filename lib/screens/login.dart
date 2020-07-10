import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:truetech/screens/home.dart';
import 'package:truetech/services/facebooklogin.dart';

FirebaseUser userName;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Facebooklogin _fbLogin = Facebooklogin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fbLogin.getCurrentUser().then((value) {
      setState(() {
        userName = value;
      });

      if (userName != null) {
        Navigator.popAndPushNamed(context, HomeScreen.id);
      }
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              child: Text('Facebook Login'),
              onPressed: () {
                _fbLogin.login().then((value) => value
                    ? Navigator.popAndPushNamed(context, HomeScreen.id)
                    : print('Error'));
              },
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              child: Text('Google Login'),
              color: Colors.red,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
