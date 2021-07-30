import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/consts.dart';
import 'package:chat_app/helper/helperfuncs.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/search.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserName())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: [
          GestureDetector(
              onTap: () {
                authMethods.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  child: Icon(Icons.logout),
                  padding: EdgeInsets.symmetric(horizontal: 25)))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          child: Icon(Icons.search)),
    );
  }
}
