import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPrefLoggedInKey = 'isLoggedIn';
  static String sharedPrefUsernameKey = 'usernameKey';
  static String sharedPrefUserEmailKey = 'userEmailKey';

  // save data to SharedPreference
  static Future<bool> saveUserLoggedIn(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPrefLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUsernameKey, username);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPrefUsernameKey, userEmail);
  }

  // get data from SharedPreference
  static Future<bool?> getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getBool(sharedPrefLoggedInKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefUsernameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString(sharedPrefUserEmailKey);
  }
}
