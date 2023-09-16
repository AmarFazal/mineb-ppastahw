import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../1frf_api.dart';
import '../config/config.dart';
import '../utilities/colors.dart';
import '../widgets/dialog.dart';
import 'chat_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Map<String, dynamic>> userInfos = [];
  List<Map<String, dynamic>> filteredUserInfos = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    int? agentId = await GetId.getAgentId();
    if (agentId != null) {
      try {
        List<dynamic> rawData = await getUsers(agentId);
        userInfos.clear();

        for (var data in rawData) {
          var userInfo = data[1];
          userInfo['number'] = data[0];
          userInfos.add(userInfo);
        }
        setState(() {
          isLoading = false;
          filteredUserInfos = List.from(userInfos); // Initialize filtered list
        });
      } catch (error) {
        showErrorDialog(context, 'Error in _loadUsers: $error');
      }
    }
  }

  Future<List<dynamic>> getUsers(int agentId) async {
    var headers = {
      'Content-Type': 'application/json',
      'X-API-Key': API_KEY,
      'Cookie': 'session=...',
    };

    var request = http.Request(
      'GET',
      Uri.parse(
        '$BASE_DOMAIN${API_ENDPOINT}get/customers/$agentId',
      ),
    );
    //request.body = json.encode({"agent_id": agentId});
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        var responseString = await response.stream.bytesToString();
        var responseData = json.decode(responseString);
        return responseData;
      } else {
        showErrorDialog(context, "Error Code ${response.statusCode}");
        return [];
      }
    } catch (e) {
      showErrorDialog(context, "An error occurred: $e");
      return [];
    }
  }

  Future<void> _refreshUser() async {
    await _loadUsers();
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUserInfos = userInfos
          .where((userInfo) =>
      userInfo['number'].toString().contains(query) ||
          userInfo['timestamp'].toString().contains(query) ||
          userInfo['content'].toString().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
          child: SpinKitFadingCircle(
            color: CustomColors.accentColor,
            size: 50.0,
          ))
          : RefreshIndicator(
        onRefresh: _refreshUser,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) => _filterUsers(query),
                decoration: const InputDecoration(
                  hintText: 'Search users',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUserInfos.length,
                itemBuilder: (context, index) {
                  var userInfo = filteredUserInfos[index];
                  var number = userInfo['number'] ?? '';
                  var content = userInfo['content'] ?? '';
                  var role = userInfo['role'] ?? '';
                  var timestamp = userInfo['timestamp'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            phoneNumber: number,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: Text("Number: +$number"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Role: $role'),
                              Text('Content: $content',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2),
                              Text(timestamp),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
