import 'package:chat_app/helper/consts.dart';
import 'package:chat_app/helper/helperfuncs.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/views/chatroom.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:chat_app/services/database.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        Map<String, String> userInfoMap = {
          'name': userNameTextEditingController.text,
          'email': emailTextEditingController.text
        };

        HelperFunctions.saveUserEmail(emailTextEditingController.text);
        HelperFunctions.saveUserName(userNameTextEditingController.text);
        Constants.myName = userNameTextEditingController.text;

        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedIn(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatRoom()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarMain(),
        body: isLoading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
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
                                    return (val!.isEmpty || val.length < 5)
                                        ? 'Please enter a valid username'
                                        : null;
                                  },
                                  controller: userNameTextEditingController,
                                  style: mainTextStyle(),
                                  decoration: textFieldDecoration('Username')),
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
                            onTap: () {
                              signMeUp();
                            },
                            child: MainButton(
                              text: 'Sign Up',
                            )),
                        SizedBox(height: 16),
                        signInRedirect(widget.toggle),
                        SizedBox(height: 70),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
