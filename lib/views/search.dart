import 'package:chat_app/helper/consts.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/conversation.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

late String user;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

QuerySnapshot? searchSnapshot;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController =
      new TextEditingController();

  bool searchPressed = false;

  initateSearch() {
    databaseMethods
        .getUserByUsername(searchTextEditingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  // TODO: create chatroom
  // TODO: send user to conversation screen
  // TODO: pushReplacement
  createChatroomAndConversation({required String username}) {
    print('${Constants.myName}');
    if (username != Constants.myName) {
      String chatRoomId = getChatRoomId(username, Constants.myName);

      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatRoomId
      };
      print('ID: $chatRoomId');
      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => ConversationScreen(user,chatRoomId)));
    } else {
      print('you cannot send messages to yourself');
    }
  }

  Widget searchTile({required String username, required String email}) {
    user = username;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            username,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
          Text(
            email,
            style: TextStyle(color: Colors.white, fontSize: 17),
          )
        ]),
        Spacer(),
        GestureDetector(
          onTap: () {
            createChatroomAndConversation(username: username);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Message',
                style: TextStyle(color: Colors.white, fontSize: 17),
              )),
        )
      ]),
    );
  }

  Widget searchList() {
    if (searchSnapshot != null) {
      if (searchSnapshot!.docs.length > 0) {
        return ListView.builder(
          itemCount: searchSnapshot!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return searchTile(
                username: searchSnapshot!.docs[index]['name'],
                email: searchSnapshot!.docs[index]['email']);
          },
        );
      } else {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 300),
          width: 300,
          child: Text(
            'Looks like there aren\'t any great matches for your search',
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
      }
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarMain(),
      body: Container(
          child: Column(
        children: [
          Container(
              color: Color.fromRGBO(100, 100, 100, 1),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search by username',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                    ),
                  )),
                  GestureDetector(
                    onTap: () {
                      searchPressed = true;
                      initateSearch();
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
              )),
          searchList()
        ],
      )),
    );
  }
}

getChatRoomId(String a, String b) {
  if ((a.compareTo(b) > 0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
