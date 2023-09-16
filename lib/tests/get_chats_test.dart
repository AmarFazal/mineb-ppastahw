import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';

void main() async {
  var headers = {'Content-Type': 'application/json', 'X-API-Key': API_KEY};
  var request = http.Request(
    'GET',
    Uri.parse('$BASE_DOMAIN${API_ENDPOINT}chat/447883250480/1'),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    final chatData = json.decode(await response.stream.bytesToString());

    print(chatData);
  }
}
