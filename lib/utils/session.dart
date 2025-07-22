import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static String userIdKey = "USERKEY";
  static String fullName = "fullName";
  static String dateOfBirth = "dateOfBirth";
  static String dateOfTime = "dateOfTime";
  static String dateOfPlace = "dateOfPlace";
  static String gender = "gender";  
  static String userImageKey = "userImageKey";

 Future<String> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString(Session.fullName);
    return fullName ?? "";
  }

  Future<bool> setFullName(String setFullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(fullName, setFullName);
  }

  
   Future<bool> setUserImage(String getUserImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, getUserImage);
  }

  
  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

   Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }



   Future<bool> setUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, getUserId);
  }

 

   Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("accessToken");
    return token ?? "";
  }

  Future<bool> setToken(String setToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    return prefs.setString("accessToken", setToken);
  }

  Future<String> getEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email') ?? '';
}

Future<void> setEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
}
}
