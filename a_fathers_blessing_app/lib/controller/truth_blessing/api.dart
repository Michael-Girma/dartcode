import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/truth_blessing/utils.dart';
import 'package:a_fathers_blessing_app/models/truth_blessing/truth_blessing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<List<TruthBlessing>> getBlessings(
      User user, Map<String, dynamic> params,
      {String urlExt = ''}) async {
    String token = await user.getIdToken();
    //make request with params and token
    print("=== $token");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response = await http.get(
      Uri.https(endpoint, '/truthBlessings$urlExt', params),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    ).timeout(Duration(seconds: 10));
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    List<TruthBlessing> blessings =
        Utils.convertResponseToBlessing(responseJson);

    print("=============length of blessings ${blessings.length}");
    for (TruthBlessing blessing in blessings) {
      print(blessing.title);
      print(blessing.body);
      print(blessing.docId);
      print(blessing.tags);
    }

    return blessings;
  }

  static Future<bool> modifyBlessing(User user, String urlExt,
      {delete: false, Map body = const {}}) async {
    String token = await user.getIdToken();

    print("$body");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response = await http
        .post(Uri.https(endpoint, '/truthBlessings$urlExt'),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer $token",
              HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
            },
            body: jsonEncode(body))
        .timeout(Duration(seconds: 10));
    print("=================== printing response code ${response.statusCode}");
    return response.statusCode < 300 && response.statusCode >= 200;
    // if(!delete) return convertBlessingToMap(jsonDecode(response.body));
  }
}
