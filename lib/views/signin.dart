import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/helper/helperfuncs.dart';
import 'chatroom.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  QuerySnapshot? snapshotUserInfo;

  signIn() {
    if (formKey.currentState!.validate()) {
      HelperFunctions.saveUserEmail(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserName(snapshotUserInfo!.docs[0]['name']);
        print('username: ${snapshotUserInfo!.docs[0]['name']}');
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          HelperFunctions.saveUserLoggedIn(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 120,
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : 'Please enter a valid email';
                            },
                            controller: emailTextEditingController,
                            style: mainTextStyle(),
                            decoration: textFieldDecoration('Email')),
                        TextFormField(
                            obscureText: true,
                            validator: (val) {
                              return val!.length >= 6
                                  ? null
                                  : 'Please enter a password with at least 6 characters.';
                            },
                            controller: passwordTextEditingController,
                            style: mainTextStyle(),
                            decoration: textFieldDecoration('Password')),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ForgotPasswordButton(),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => {signIn()},
                    child: MainButton(
                      text: 'Sign In',
                    ),
                  ),
                  SizedBox(height: 16),
                  registerRedirect(widget.toggle),
                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ));
  }
}
