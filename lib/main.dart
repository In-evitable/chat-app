import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/helperfuncs.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn = false;
  @override
  void initState() {
    Firebase.initializeApp();
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedIn().then((value) {
      setState(() {
        isUserLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[700],
        scaffoldBackgroundColor: Color.fromRGBO(25, 25, 25, 1),
        primarySwatch: Colors.blue,
      ),
      home: isUserLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}
