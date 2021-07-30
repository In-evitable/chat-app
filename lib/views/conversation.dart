import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/views/search.dart';

class ConversationScreen extends StatefulWidget {
  final String user;
  ConversationScreen(this.user);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: Container(
          child: Stack(children: [
            Container(
                color: Color.fromRGBO(100, 100, 100, 1),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      // controller: searchTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Message ${widget.user}',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        // initateSearch();
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
                          child: Icon(Icons.search, color: Colors.white)),
                    )
                  ],
                ))
          ]),
        ),
      ),
    );
  }
}
