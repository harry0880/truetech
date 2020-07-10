import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:truetech/screens/chat.dart';
import 'package:truetech/screens/home.dart';
import 'package:truetech/screens/login.dart';
import 'package:truetech/screens/userProfile.dart';
import 'package:truetech/utilities/userData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return UserData();
        },
        child: MaterialApp(
          title: 'True Tech Chat',
          theme: ThemeData.dark(),
          initialRoute: LoginScreen.id,
          routes: {
            LoginScreen.id: (context) => LoginScreen(),
            HomeScreen.id: (context) => HomeScreen(),
            ChatScreen.id: (context) => ChatScreen(),
            UserProfile.id: (context) => UserProfile()
          },
        ));
  }
}
