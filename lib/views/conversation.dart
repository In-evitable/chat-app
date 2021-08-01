import 'package:chat_app/helper/consts.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String user;
  final String chatRoomId;
  ConversationScreen(this.user, this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();

  Stream? chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder(
        stream: chatMessagesStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            return Container(
              padding: EdgeInsets.only(bottom: 80),
              height: MediaQuery.of(context).size.height - 80,
              child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                      message: snapshot.data.docs[index].data()['message'],
                      isSentByMe: snapshot.data.docs[index].data()['sender'] ==
                          Constants.myName,
                    );
                  }),
            );
          } else {
            return Container();
          }
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sender': Constants.myName,
        'time': DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      setState(() {
        messageController.text = '';
      });
    }
  }

  @override
  void initState() {
  ``  // TODO: implement initState
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      chatMessagesStream = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.user}'),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: Stack(alignment: Alignment.bottomCenter, children: [
            chatMessageList(),
            Container(
                color: Color.fromRGBO(100, 100, 100, 1),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message ${widget.user} ...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color.fromRGBO(125, 125, 125, 1),
                                    const Color.fromRGBO(110, 110, 110, 1)
                                  ]),
                              borderRadius: BorderRadius.circular(40)),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          )),
                    )
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile({required this.message, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSentByMe ? 0 : 16, right: isSentByMe ? 16 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSentByMe
                      ? [
                          Color.fromRGBO(50, 50, 250, 1),
                          Color.fromRGBO(25, 25, 200, 1)
                        ]
                      : [
                          Color.fromRGBO(60, 60, 60, 1),
                          Color.fromRGBO(50, 50, 50, 1)
                        ]),
              borderRadius: isSentByMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20))
                  : BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
          child: Text(
            this.message,
            style: TextStyle(color: Colors.white, fontSize: 17),
          )),
    );
  }
}
