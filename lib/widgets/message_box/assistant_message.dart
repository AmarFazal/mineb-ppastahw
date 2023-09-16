import 'package:flutter/material.dart';

class AssistantMessage extends StatelessWidget {
  final Map<String, dynamic> message;

  const AssistantMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.shade100,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message['role'],
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              message["timestamp"] ?? 'No Time Found',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 4.0),
            Text(
              message["content"] ?? 'No Content Found',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
