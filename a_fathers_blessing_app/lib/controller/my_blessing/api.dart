import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/my_blessing/utils.dart';
import 'package:a_fathers_blessing_app/models/my_blessing/my_blessing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<List<MyBlessing>> getBlessings(
      User user, Map<String, dynamic> params,
      {String urlExt = ''}) async {
    String token = await user.getIdToken();
    //make request with params and token
    print("=== $token");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response = await http.get(
      Uri.https(endpoint, '/myBlessings$urlExt', params),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    ).timeout(Duration(seconds: 10));
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    List<MyBlessing> blessings = Utils.convertResponseToBlessing(responseJson);

    print("=============length of blessings ${blessings.length}");
    for (MyBlessing blessing in blessings) {
      print(blessing.title);
      print(blessing.body);
      print(blessing.docId);
      print(blessing.tags);
    }

    return blessings;
  }

  static Future<MyBlessing> addBlessing(User user, MyBlessing blessing) async {
    String token = await user.getIdToken();
    Map<String, dynamic> body = {
      "blessing": Utils.convertBlessingToMap(blessing)
    };
    print("==${jsonEncode(body)}");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response = await http
        .post(Uri.https(endpoint, '/myBlessings'),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $token",
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body))
        .timeout(Duration(seconds: 10));

    if (response.statusCode == 201)
      return Utils.convertMapToBlessing(jsonDecode(response.body));
    else
      return MyBlessing()..docId = "";
    // if(!delete) return convertBlessingToMap(jsonDecode(response.body));
  }

  static Future<bool> modifyBlessing(User user, String urlExt,
      {delete: false, Map body = const {}}) async {
    String token = await user.getIdToken();

    print("$body");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response = await http
        .post(Uri.https(endpoint, '/myBlessings$urlExt'),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $token",
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body))
        .timeout(Duration(seconds: 10));
    return response.statusCode < 300 && response.statusCode >= 200;
    // if(!delete) return convertBlessingToMap(jsonDecode(response.body));
  }
}
