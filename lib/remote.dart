import "dart:convert";

import "package:http/http.dart" as api;

const url = "deckofcardsapi.com";

Future<dynamic> drawCards({required String group ,required String amount}) async {
  final response = await api.get(Uri.https(url, "/api/deck/$group/draw/", {"count": amount}));
  final data = json.decode(response.body);
  return Map<String,dynamic>.from(data);
}
