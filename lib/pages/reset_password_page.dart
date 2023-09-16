import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Change your password", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              subtitle: const Text(
                "Lorem ipsum dolor sit amet consectetur adipisicing elit. Quasi, autem!",
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('Forgot Your Password'),
              ),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(labelText: "Current password"),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(labelText: "New password"),
            ),
            const SizedBox(height: 16.0),
            const TextField(
              decoration: InputDecoration(labelText: "Confirm password"),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Password requirements\n\n'
                  'To create a new password, you have to meet all of the following requirements:\n\n'
                  '• Minimum 8 characters\n'
                  '• At least one special character\n'
                  '• At least one number\n'
                  '• Can’t be the same as a previous password',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Update Password"),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
