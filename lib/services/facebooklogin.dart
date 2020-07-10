import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = Firestore.instance;

final String graphURL =
    'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.width(100).height(100)&access_token=';

class Facebooklogin {
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> login() async {
    bool _isLoggedIn = false;

    final FacebookLoginResult result =
        await facebookSignIn.logIn(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _isLoggedIn = true;
        final token = result.accessToken.token;

        _auth
            .signInWithCredential(
          FacebookAuthProvider.getCredential(accessToken: token),
        )
            .then((value) async {
          final graphResponse = await http.get('$graphURL$token');
          final profile = JSON.jsonDecode(graphResponse.body);
          print(profile);

          if (value != null) {
            _firestore.collection('Users').add({
              'Name': profile['first_name'],
              'Email': profile['email'],
              'ProfilePic': profile['picture']['data']['url']
            });
          }
        }).catchError((e) {
          print(e);
        });

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        _isLoggedIn = false;
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        _isLoggedIn = false;
        break;
    }
    return _isLoggedIn;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser _user = await _auth.currentUser();
    return _user;
  }

  Future<QuerySnapshot> getuserlist() async {
    final users = await _firestore.collection('Users').getDocuments();
    return users;
  }

  Future<QuerySnapshot> getCurrentuserData(String mailid) async {
    final users = await _firestore
        .collection('Users')
        .where('Email', isEqualTo: '$mailid')
        .getDocuments();
    return users;
  }

  void logOut() {
    facebookSignIn.logOut();
  }
}
