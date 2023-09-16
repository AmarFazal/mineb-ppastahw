// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../config/config.dart';
//
// String BASE_DOMAIN = "https://1frf.com/";
// String API_KEY = 'alsdjfaioj';
// String API_ENDPOINT = 'api/agent/v1/';
//
// main() async {
//   var headers = {
//     'Content-Type': 'application/json',
//     'X-API-Key': API_KEY,
//     'Cookie': 'session=...'
//   };
//
//   var request = http.Request(
//       'GET',
//       Uri.parse(
//           '$BASE_DOMAIN${API_ENDPOINT}get/customers'));
//   request.body = json.encode({"agent_id": 1});
//   request.headers.addAll(headers);
//
//   try {
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();
//       var responseData = json.decode(responseString);
//       print(responseData);
//     } else {
//       print("Some Think was error${response.statusCode}");
//     }
//   } catch (e) {
//     print("An error occurred: $e");
//   }
// }
