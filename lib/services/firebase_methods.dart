import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ridebooking/services/database_methods.dart';
import 'package:ridebooking/utils/route_generate.dart';
import 'package:ridebooking/utils/session.dart';

class FirebaseMethods {


  final FirebaseAuth auth = FirebaseAuth.instance;


  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    // String randomstr = randomAlphaNumeric(5);

    String userName = userDetails!.email!.replaceAll("@gmail.com", "");
    String firstletter = userName.substring(0, 1).toUpperCase();

    // NotificationServices notificationServices = NotificationServices();
    await Session()
        .setFullName(userDetails.displayName!);
    await Session().setEmail(userDetails.email!);
    await Session().setUserId(userDetails.uid);
    await Session().setUserImage(userDetails.photoURL!);
    
    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "Name": userDetails!.displayName,
        "Email": userDetails!.email,
        "Image": userDetails.photoURL,
        "Id": userDetails.uid,
        "username": userName.toUpperCase(),
        "SearchKey": firstletter,
      };

      await DatabaseMethods().addUser(userInfoMap, userDetails.uid);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "User registered successfully",
            style: TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
          )));

      Navigator.pushReplacementNamed(context, Routes.home);
    }
  }


}