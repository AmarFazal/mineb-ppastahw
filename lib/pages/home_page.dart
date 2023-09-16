import 'package:flutter/material.dart';
import 'package:whatsapp_agent_android/pages/members_page.dart';
import 'package:whatsapp_agent_android/widgets/snackbar.dart';
import 'settings_page.dart';
import 'tabbed_page.dart';
import '../1frf_api.dart';
import 'notes_page.dart';
import 'security_page.dart';
import 'tasks_page.dart';
import 'users_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _appBarTitle = 'Users';
  String _userRole = '';
  bool isSuperAdminOrManager = false;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  _loadUserRole() async {
    String? userRole = await GetRole.getUserRole();
    setState(() {
      _userRole = userRole ??
          'agent'; // Eğer kullanıcı rolü null ise Ajan olarak ayarlar.
    });

    // Kullanıcı Admin veya Manager ise, isSuperAdminOrManager'i true yapın.
    if (_userRole == 'super_admin' || _userRole == 'manager') {
      setState(() {
        isSuperAdminOrManager = true;
      });
    }
  }

  final List<Widget> _children = [
    const UsersPage(),
    const TasksPage(),
    const NotesPage(),
    const SettingsPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        _appBarTitle = 'Users';
      } else if (index == 1) {
        _appBarTitle = 'Tasks';
      } else if (index == 2) {
        _appBarTitle = 'Notes';
      } else if (index == 3) {
        _appBarTitle = 'Settings';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            SizedBox(height: 10),
            Align(child: Image.asset('assets/logo.jpg', height: 80),alignment: Alignment.topLeft),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                  _appBarTitle = 'Users';
                });
                Navigator.pop(context);
              },
            ),ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: const Text("Marketing: bulk messaging"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text("Security"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SecurityPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("Members"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MembersPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TabbedPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.supervised_user_circle),
              title: const Text("User Role"),
              onTap: () async {
                String? userRole = await GetRole.getUserRole();
                Navigator.pop(context);
                if (userRole != null) {
                  MySnackBar(context, "Your Role Is: $userRole");
                } else {
                  MySnackBar(context, 'Your role not found');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text(
                          "Do you wish to proceed with logging out?"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text('Yes'),
                          onPressed: () {
                            AuthUtils.logout(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content:
                        const Text("Do you wish to proceed with logging out?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () {
                          AuthUtils.logout(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
        title: Text(_appBarTitle),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: isSuperAdminOrManager
            ? const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note_add),
                  label: 'Notes',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ]
            : const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat),
                  label: 'Chats',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note_add),
                  label: 'Notes',
                ),
              ],
      ),
    );
  }
}
