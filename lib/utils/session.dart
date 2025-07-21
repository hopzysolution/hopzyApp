import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Session {

  static String fullName = "fullName";
  static String dateOfBirth = "dateOfBirth";
  static String dateOfTime = "dateOfTime";
  static String dateOfPlace = "dateOfPlace";
  static String gender = "gender";



  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString("language");
    return (language ?? "");
  }

  Future<bool> setLanguage(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("language", name);
  }

  static Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString("deviceId");
    return (language ?? "");
  }

  Future<bool> setDeviceId(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("deviceId", name);
  }

 Future<String> getFullName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString(Session.fullName);
    return fullName ?? "";
  }

  Future<bool> setFullName(String setFullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(fullName, setFullName);
  }

   Future<String> getDateOfBirth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getDateOfBirth = prefs.getString(dateOfBirth);
    return getDateOfBirth ?? "";
  }

  Future<bool> setDateOfBirth(String setDateOfBirth) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(dateOfBirth, setDateOfBirth);
  }

  Future<String> getDateOfTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getDateOfTime = prefs.getString(dateOfTime);
    return getDateOfTime ?? "";
  }

  Future<bool> setDateOfTime(String setDateOfTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(dateOfTime, setDateOfTime);
  }

  

    Future<String> getDateOfPlace() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getDateOfPlace = prefs.getString(dateOfPlace);
    return getDateOfPlace ?? "";
  }

  Future<bool> setDateOfPlace(String setDateOfPlace) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(dateOfPlace, setDateOfPlace);
  }

    Future<String> getGender() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? genderValue = prefs.getString(gender);
    return genderValue ?? "";
  }

  Future<bool> setGender(String setGender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(gender, setGender);
  }

    Future<void> setMaritalStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('maritalStatus', status);
  }

  Future<String?> getMaritalStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('maritalStatus');
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
