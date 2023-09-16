import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDocumentMessageWidget extends StatelessWidget {
  final String documentID;
  final Map<String, dynamic> message;

  const UserDocumentMessageWidget({
    super.key,
    required this.message,
    required this.documentID,
  });

  Future<void> _launchDocumentUrl(String documentID) async {
    final url = 'https://drive.google.com/uc?export=view&id=$documentID';
    try {
      await canLaunch(url);
      await launch(url);
    } catch (e) {
      print('Hata: $e');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {
          // Belgeyi tıklanabilir bir bağlantı olarak aç
          _launchDocumentUrl(documentID);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(16.0),
          ),
          // Genişliği sınırla
          constraints: const BoxConstraints(maxWidth: 230),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['role'],
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                message["timestamp"] ?? 'No Time Found',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.insert_drive_file),
                  Text(
                    message["type"] ?? 'No Content Found',
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
