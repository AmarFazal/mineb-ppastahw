import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_agent_android/pages/login_page.dart';
import 'widgets/dialog.dart';
import 'config/config.dart';
import 'utilities/redirect_to_new_page.dart';

class AuthUtils {
  // SharedPreferences'ta ajan kimliğini kaydetme işlevi
  static Future<void> saveAgentIdToSharedPreferences(int agentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('agent_id_key', agentId);
  }

  // SharedPreferences'tan ajan kimliğini alma işlevi
  static Future<int?> getAgentIdFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('agent_id_key');
  }

  // SharedPreferences'ta ajan rolü kaydetme işlevi
  static Future<void> saveUserRoleToSharedPreferences(String userRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', userRole);
  }

  // SharedPreferences'tan ajan rolü alma işlevi
  static Future<String?> getUserRoleFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  // Giriş API isteği işlevi
  static Future<void> loginApiRequest(
      var email, var password, BuildContext context) async {
    var headers = {'Content-Type': 'application/json', 'X-API-Key': API_KEY};
    var request =
        http.Request('POST', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}login'));
    request.body = json.encode({"email": "$email", "password": "$password"});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final jsonData = json.decode(await response.stream.bytesToString());
      if (jsonData['status'] == "success") {
        String isLoggedIn = "true";
        int agentID = jsonData['agent_id'] as int;
        String userRole = jsonData['user_role'];
        sendTrue(isLoggedIn, agentID);
        await saveAgentIdToSharedPreferences(agentID);
        await saveUserRoleToSharedPreferences(userRole);
        return redirectToNewPage(context);
      } else {
        showErrorDialog(context, jsonData['msg']);
      }
    } else {
      showErrorDialog(context, response.reasonPhrase.toString());
    }
  }

  // Kayıt API isteği işlevi
  static Future<void> registerApiRequest(
    BuildContext context,
    var email,
    var password,
    var agentFirstName,
    var agentLastName,
    var agentPhoneNumber,
    var bio,
  ) async {
    var headers = {'Content-Type': 'application/json', 'X-API-Key': API_KEY};
    var request =
        http.Request('POST', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}register'));
    request.body = json.encode({
      "agent_first_name": "$agentFirstName",
      "agent_last_name": "$agentLastName",
      "agent_email": "$email",
      "agent_phone_number": "$agentPhoneNumber",
      "bio": "$bio",
      "password": "$password"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final jsonData = json.decode(await response.stream.bytesToString());
      if (jsonData['status'] == "success") {
        String isLoggedIn = "true";
        int agentId = jsonData['agent_id'] as int;
        String userRole = jsonData['user_role'];
        await saveAgentIdToSharedPreferences(agentId);
        await saveUserRoleToSharedPreferences(userRole);
        return redirectToNewPage(context);
      } else {
        showErrorDialog(context, jsonData['msg']);
      }
    } else {
      showErrorDialog(context, response.reasonPhrase.toString());
    }
  }

  // "true" değerini API'ye gönderme işlevi
  static Future<void> sendTrue(String isLoggedIn, int agentID) async {
    var headers = {
      'Content-Type': 'application/json',
      'X-API-Key': API_KEY,
      'Cookie':
          'session=eyJlbWFpbCI6ImJpbGFsZmF6aWxAMWZyZi5jb20iLCJsb2dnZWRpbiI6dHJ1ZX0.ZMs8sg.ys9BWRCxGXwT5XJpJj69zQlEfMg'
    };
    var request = http.Request(
        'GET', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}get/profile/$agentID'));
    //request.body = json.encode({"loggedin": isLoggedIn, "agent_id": agentID});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final jsonData = json.decode(await response.stream.bytesToString());
      print(jsonData);
    } else {
      print(response.reasonPhrase);
    }
  }

  // Oturumu kapatma işlevi
  static Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }
}

class GetId {
  static Future<int?> getAgentId() async {
    int? agentId = await AuthUtils.getAgentIdFromSharedPreferences();
    return agentId;
  }
}

class GetRole {
  static Future<String?> getUserRole() async {
    String? userRole = await AuthUtils.getUserRoleFromSharedPreferences();
    return userRole;
  }
}
