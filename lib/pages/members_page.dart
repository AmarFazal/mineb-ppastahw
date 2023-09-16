import 'package:flutter/material.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({Key? key}) : super(key: key);

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  // Sample list of users (you can replace this with your actual data)
  final List<User> users = [
    User("User 1", "user1@email.com", "Agent",
        'https://sb.kaleidousercontent.com/67418/1920x1545/c5f15ac173/samuel-raita-ridxdghg7pw-unsplash.jpg'),
    User("User 2", "user2@email.com", "Admin",
        'https://media.istockphoto.com/id/1300512215/photo/headshot-portrait-of-smiling-ethnic-businessman-in-office.webp?b=1&s=170667a&w=0&k=20&c=TXCiY7rYEvIBd6ibj2bE-VbJu0rRGy3MlHwxt2LHt9w='),
    // Add more users as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Members"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "SEATS USED",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Text(
                  "3 out of 7",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Upgrade'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "DEFAULT ROLE",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Text(
                  "Agent",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Change'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "USERS",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                const Text(
                  "Invite members",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Icon(Icons.person_add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            for (final user in users) UserListItem(user: user),
          ],
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String role;
  final String profileImageUrl;

  User(this.name, this.email, this.role, this.profileImageUrl);
}

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profileImageUrl),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: DropdownButton<String>(
        value: user.role,
        onChanged: (newValue) {
          // Handle role change here
        },
        items: <String>['Agent', 'Admin', 'User', 'Custom']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
