// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../config/config.dart';
//
// void main() async {
//     var headers = {
//       'Content-Type': 'application/json',
//       'X-API-Key': API_KEY,
//       'Cookie': 'session=...'
//     };
//
//     var request = http.Request(
//         'GET', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}get/profile'));
//     request.body = json.encode({"loggedin": 'true', "agent_id": 1});
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();
//       print(json.decode(responseString)['agent_data']);
//     } else {
//       print(
//           "${response.reasonPhrase} ${response.statusCode}");
//     }
// }
