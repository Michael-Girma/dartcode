import 'dart:convert';
import 'dart:io';

import 'package:a_fathers_blessing_app/controller/configuration/configs.dart';
import 'package:a_fathers_blessing_app/controller/tag/utils.dart';
import 'package:a_fathers_blessing_app/models/tag/tag.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<List<Tag>> getTags(User user, Map<String, dynamic> params,
      {String urlExt = ''}) async {
    String token = await user.getIdToken();
    //make request with params and token
    print("=== $token");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response = await http.get(
      Uri.https(endpoint, '/Tags$urlExt', params),
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    List<Tag> tags = Utils.convertResponseToTag(responseJson);

    print("=============length of blessings ${tags.length}");
    for (Tag blessing in tags) {}

    return tags;
  }

  static Future<bool> modifyTag(User user, String urlExt,
      {delete: false, Map body = const {}}) async {
    String token = await user.getIdToken();

    print("$body");
    final String endpoint = RemoteConfig.config.backendUrl;
    final response = await http.post(Uri.https(endpoint, '/tags$urlExt'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body));
    return response.statusCode < 300 && response.statusCode >= 200;
  }
}
