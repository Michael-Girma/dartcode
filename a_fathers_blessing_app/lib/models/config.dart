import 'package:a_fathers_blessing_app/models/scripture/bible.dart';

class Config {
  String bibleApiUrl = "";
  String backendUrl = "";
  String apiKey = "";
  List<Bible> gatewayVersions = <Bible>[];

  Config({this.apiKey, this.backendUrl, this.bibleApiUrl});

  Config.fromJson(Map<String, dynamic> json)
      : apiKey = json['apiKey'],
        bibleApiUrl = json['bibleApiUrl'],
        backendUrl = json["backendUrl"],
        gatewayVersions = <Bible>[...json["gateway_versions"]
            .map((element) => 
              Bible(name: element["name"],
                    id: element["id"],
                    abbreviation: element["abbreviation"])
            ).toList()];

  

  @override
  String toString() {
    return """
      bibleApiUrl: $bibleApiUrl,
      backendUrl: $backendUrl,
      apiKey: $apiKey,
      gatewayVersions: $gatewayVersions
    """;
  }
}
