import 'package:flutter/material.dart';

class AppBarMain extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Chat App'),
    );
  }
}

InputDecoration textFieldDecoration(String hint) {
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white54),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}

TextStyle mainTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

class MainButton extends Container {
  final String text;
  MainButton({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff007ef4), const Color(0xff2a75bc)]),
          borderRadius: BorderRadius.circular(30)),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 17)),
    );
  }
}

class ForgotPasswordButton extends Container {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Forgot Password?',
            style: mainTextStyle(),
          )),
    );
  }
}

Row registerRedirect(Function toggle) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(
      'Don\'t have an account? ',
      style: TextStyle(color: Colors.white, fontSize: 17),
    ),
    GestureDetector(
      onTap: () {
        toggle();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Register Now',
          style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              decoration: TextDecoration.underline),
        ),
      ),
    ),
  ]);
}

Row signInRedirect(Function toggle) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Text(
      'Already have an account? ',
      style: TextStyle(color: Colors.white, fontSize: 17),
    ),
    GestureDetector(
      onTap: () {
        toggle();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Sign In',
          style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              decoration: TextDecoration.underline),
        ),
      ),
    ),
  ]);
}
