import 'package:flutter/material.dart';

class UserImageMessageWidget extends StatelessWidget {
  final String imageID;
  final Map<String, dynamic> message;

  const UserImageMessageWidget(
      {super.key, required this.imageID, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.teal.shade100,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['role'],
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              message["timestamp"] ?? '',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 4.0),
            Image.network('https://drive.google.com/uc?export=view&id=$imageID',
                width: 250),
          ],
        ),
      ),
    );
  }
}
