import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/consts.dart';
import 'package:chat_app/helper/helperfuncs.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                      username: snapshot.data.docs[index]
                          .data()['chatroomId']
                          .toString()
                          .replaceAll('_', '')
                          .replaceAll(Constants.myName, ''),
                      chatRoomId:
                          snapshot.data.docs[index].data()['chatroomId'],
                      user: snapshot.data.docs[index]
                          .data()['chatroomId']
                          .toString()
                          .replaceAll('_', '')
                          .replaceAll(Constants.myName, ''),
                    );
                  })
              : Container();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = (await HelperFunctions.getUserName())!;
    databaseMethods.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
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
                HelperFunctions.saveUserLoggedIn(false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  child: Icon(Icons.logout),
                  padding: EdgeInsets.symmetric(horizontal: 25)))
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          },
          child: Icon(Icons.search)),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String user;
  final String chatRoomId;
  ChatRoomTile(
      {required this.username, required this.chatRoomId, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(user, chatRoomId)));
      },
      child: Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(40)),
                  child: Text(
                    '${username.substring(0, 1).toUpperCase()}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
              SizedBox(
                width: 8,
              ),
              Text(
                username,
                style: mainTextStyle(),
              )
            ],
          )),
    );
  }
}
