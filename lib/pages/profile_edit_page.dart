import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whatsapp_agent_android/widgets/snackbar.dart';
import '../1frf_api.dart';
import '../config/config.dart';
import '../widgets/dialog.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Map<String, dynamic> agentData = {};
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _twitterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileEditPage();
  }

  void _loadProfileEditPage() async {
    int? agentId = await GetId.getAgentId();
    await sendTrue('true', agentId);
    _populateControllers();
  }

  void updateProfile() async {
    int? agentId = await GetId.getAgentId();

    if (agentId != null) {
      if (_firstNameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _bioController.text.isEmpty ||
          _phoneNumberController.text.isEmpty) {
        MySnackBar(context, 'Please fill in all required fields');
        return;
      }

      if (!_isValidEmail(_emailController.text)) {
        MySnackBar(context, 'Please enter a valid email address.');
        return;
      }

      var headers = {
        'Content-Type': 'application/json',
        'X-API-Key': API_KEY,
        'Cookie': 'session=...'
      };

      var request = http.Request(
          'POST', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}update/profile'));
      request.body = json.encode({
        "agent_id": agentId,
        "first_name": _firstNameController.text,
        "last_name": _lastNameController.text,
        "email": _emailController.text,
        "bio": _bioController.text,
        "phone_number": _phoneNumberController.text,
        "facebook_account": _facebookController.text,
        "instagram_account": _instagramController.text,
        "twitter_account": _twitterController.text,
      });
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      var responseString = await response.stream.bytesToString();
      var responseData = json.decode(responseString);

      if (responseData['status'] == 'success') {
        MySnackBar(context, responseData['msg'].toString());

        // API'den dönen veriyi kullanarak başka işlemler yapabilirsiniz.
        // Örneğin, responseData içinde gelen verileri kullanarak bir şeyler yapabilirsiniz.
      } else {
        showErrorDialog(context, responseData['msg'].toString());
      }
    } else {
      showErrorAndLogoutDialog(context, "Agent ID not found.");
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _populateControllers() {
    _firstNameController.text = agentData['agent_first_name'] ?? '';
    _lastNameController.text = agentData['agent_last_name'] ?? '';
    _emailController.text = agentData['agent_email'] ?? '';
    _bioController.text = agentData['agent_bio'] ?? '';
    _phoneNumberController.text =
        agentData['agent_phone_number'].toString() ?? '';

    // Sosyal medya bağlantılarını kontrol edin ve varsayılan değerleri ekleyin
    if (agentData['agent_social_media'] != null) {
      // agent_social_media string verisini JSON'a dönüştürün
      Map<String, dynamic> socialMediaData =
          json.decode(agentData['agent_social_media']);
      _facebookController.text = socialMediaData['facebook_account'] ?? '';
      _instagramController.text = socialMediaData['instagram_account'] ?? '';
      _twitterController.text = socialMediaData['twitter_account'] ?? '';
    } else {
      _facebookController.text = '';
      _instagramController.text = '';
      _twitterController.text = '';
    }
  }

  sendTrue(String isLoggedIn, int? agentID) async {
    var headers = {
      'Content-Type': 'application/json',
      'X-API-Key': API_KEY,
      'Cookie': 'session=...'
    };

    var request = http.Request(
        'GET', Uri.parse('$BASE_DOMAIN${API_ENDPOINT}get/profile/$agentID'));
    // request.body = json.encode({"loggedin": isLoggedIn, "agent_id": agentID});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      setState(() {
        agentData = json.decode(responseString)['agent_data'];
      });
    } else {
      showErrorAndLogoutDialog(context,
          "${response.reasonPhrase} Please login again. ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: agentData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'Bio'),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Agent ID: ${agentData['agent_id']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Social Media:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (agentData['agent_social_media'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _facebookController,
                          decoration:
                              const InputDecoration(labelText: 'Facebook'),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _instagramController,
                          decoration:
                              const InputDecoration(labelText: 'Instagram'),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _twitterController,
                          decoration:
                              const InputDecoration(labelText: 'Twitter'),
                        ),
                      ],
                    ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              updateProfile();
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15)),
                            onPressed: () {
                              // Cancel button pressed
                            },
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
