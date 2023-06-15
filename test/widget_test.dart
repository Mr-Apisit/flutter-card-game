// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import "dart:convert";

import "package:http/http.dart" as api;
// import 'package:flutter_test/flutter_test.dart';

void main() async {
  print("\n--------Show result from getListContent --------");
  final data = await getListContent();
  for (var i = 1; i <= 3; i++) {
    print("no. $i ${data[i]['title']}");
  }

  print("\n--------Show result from getOneContent --------");
  final oneData = await getOneContent("12");
  final id = oneData['id'];
  final title = oneData['title'];
  print("id = $id and title = $title");

  print("\n--------Show result from postContent --------");
  final postData = await postContent(title: "first title", content: "Body my content");
  print(postData);
}

/// [getListContent] สำหรับเรียก ลิส คอนเท้น
Future<List<dynamic>> getListContent() async {
  const url = "https://jsonplaceholder.typicode.com/posts";
  final response = await api.get(Uri.parse(url));
  if (response.statusCode == 200) {
    print("check response.body type ------ > is : ${response.body.runtimeType} type");
    final data = json.decode(response.body);
    print("Test decode response.body type ------> : ${data.runtimeType}");
    return List.from(data);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

/// [getOneContent] สำหรับเรียก 1 คอนเท้น
Future<dynamic> getOneContent(String id) async {
  final url = "https://jsonplaceholder.typicode.com/posts/$id/";
  final response = await api.get(Uri.parse(url));
  if (response.statusCode == 200) {
    print("check response.body type ------ > is : ${response.body.runtimeType} type");
    final data = json.decode(response.body);
    print("Test decode response.body type ------> : ${data.runtimeType}");
    return Map.from(data);
  } else {
    throw Exception(response.reasonPhrase);
  }
}

/// [postContent] สำหรับสร้่าง คอนเท้น
Future<dynamic> postContent({required String title, required String content}) async {
  const url = "https://jsonplaceholder.typicode.com/posts";

  // POST ต้องการ header และ body
  const header = {"Content-Type": "application/json"};
  final body = {"title": title, "body": content};

  final response = await api.post(
    Uri.parse(url),
    headers: header,
    body: json.encode(body),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    print("check response.body type ------ > is : ${response.body.runtimeType} type");
    final data = json.decode(response.body);
    print("Test decode response.body type ------> : ${data.runtimeType}");
    return Map.from(data);
  } else {
    throw Exception(response.reasonPhrase);
  }
}
