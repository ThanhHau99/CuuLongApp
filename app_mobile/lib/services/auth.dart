import 'package:app_mobile/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String get jsonString => null;

  // create user object based on FirebaseUser
  static void saveUserId(String uid) async {
    debugPrint("User logged in : $uid");
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('uid', uid);
  }

  // auth change user stream
  static Future<String> loadUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('uid');
  }

  // sign in with email and pass
  Future<String> signInWithEmailAndPassword(
      {String email, String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // save user id for later check user logged in
      saveUserId(user.uid);
      DatabaseService(uid: user.uid).userData;
      return 'Welcome';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Tài khoản chưa được đăng ký';
      } else if (e.code == 'wrong-password') {
        return 'Mật khẩu nhập sai';
      }
    }
  }

  // sign up with email and pass
  Future<String> signUpWithEmailAndPassWord(String name, String phone,
      String email, String password, List idSensors, List idDevices) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      // create a new document for user with uid
      await DatabaseService(uid: user.uid).updateUserData(
        name,
        phone,
        email,
        password,
        idSensors,
        idDevices,
      ); //updateUserData

      // save user id for later check user logged in
      saveUserId(user.uid);
      DatabaseService(uid: user.uid).userData;
      return "Account created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Mật khẩu khá yếu';
      } else if (e.code == 'email-already-in-use') {
        return 'Email đã được sử dụng';
      }
    } catch (e) {
      return "Đăng ký không thành công";
    }
  }

  // sign out
  Future signOut() async {
    try {
      // clear user id for later check user logged in
      saveUserId('');
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return;
    }
  }
}
