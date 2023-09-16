import 'package:flutter/material.dart';

class AgentImageMessageWidget extends StatelessWidget {
  final String imageID;
  final Map<String, dynamic> message;

  const AgentImageMessageWidget(
      {super.key, required this.imageID, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Agent ${message["agent_id"]}",
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              message["timestamp"] ?? '',
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 4.0),
            Image.network(
                'https://drive.google.com/uc?export=view&id=$imageID'),
          ],
        ),
      ),
    );
  }
}
