import 'package:flutter/material.dart';

import 'profile_edit_page.dart';
import 'reset_password_page.dart';

class TabbedPage extends StatefulWidget {
  const TabbedPage({super.key});

  @override
  State<TabbedPage> createState() => _TabbedPageState();
}

class _TabbedPageState extends State<TabbedPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      // Rebuild the widget when the tab changes
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()), // Set the app bar title dynamically
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Edit Profile'),
            Tab(text: 'Reset Password'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProfileEditPage(),
          ResetPasswordPage(),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    if (_tabController.index == 0) {
      return 'Edit Profile';
    } else if (_tabController.index == 1) {
      return 'Reset Password';
    }
    return 'Tabs Example'; // Default title
  }
}
