import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/config.dart';
import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/user/authentication/auth-result-enums.dart';
import 'package:a_fathers_blessing_app/controller/user/authentication/auth_exception_handler.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  AuthResultStatus _status;
  User user;
  // User curresntUser;
  ///
  /// Helper Functions
  ///
  UserProvider() {
    _auth.userChanges().listen((User user) {
      if (user != null) {
        this.user = user;
        
        print("New user object recieved != null");
        notifyListeners();
      } else {
        print("recieved new user object but is null");
      }
    });
  
  }

  Future<String> createAccount({email, pass}) async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5), onTimeout: () {
        throw TimeoutException("Request to server Timed out.");
      });
      dynamic authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      if (authResult.user != null) {
        this.user = authResult.user;
        _status = AuthResultStatus.successful;
        return "success";
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    return AuthExceptionHandler.generateExceptionMessage(_status);
  }

  Future<String> login({email, pass}) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: pass);

      if (authResult.user != null && authResult.user.emailVerified) {
        this.user = authResult.user;
        _status = AuthResultStatus.successful;
        return "success";
      } else if (!authResult.user.emailVerified) {
        return "failed";
      } else {
        _status = AuthResultStatus.undefined;
      }
    } catch (e) {
      print('Exception @createAccount: $e');
      _status = AuthExceptionHandler.handleException(e);
    }
    print(AuthExceptionHandler.generateExceptionMessage(_status));
    return AuthExceptionHandler.generateExceptionMessage(_status);
  }

  logout() async {
    var myBox = Hive.box(Config.myBlessingBox);
    var truthBox = Hive.box(Config.truthBlessingBox);
    var tagBox = Hive.box(Config.tagBox);

    await myBox.clear();
    await truthBox.clear();
    await tagBox.clear();
    _auth.signOut();

    // Navigator.popUntil(context, ModalRoute.withName("/selector_page"));
  }

  clearDataFromServer(User user) async {
    bool status = await deleteData(user);
    return status;
  }

  static Future<bool> deleteData(User user,
      {delete: false, Map body = const {}}) async {
    String token = await user.getIdToken();

    print("$body");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response =
        await http.post(Uri.https(endpoint, '/users/delete/'), headers: {
      HttpHeaders.authorizationHeader: "Bearer $token",
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    });
    return response.statusCode < 300 && response.statusCode >= 200;
  }
}
