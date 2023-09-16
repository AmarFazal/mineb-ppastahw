import 'package:flutter/material.dart';
import '../utilities/colors.dart';
import 'settings_pages/ai_model_settings_page.dart';
import 'settings_pages/woocommerce_settings_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Widget> tabPages = [
    AiModelSettingsPage(),
    const WoocommerceSettingsPage(),
  ];

  final List<String> tabNames = [
    'Ai Model',
    'Woocommerce Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabPages.length,
      child: Scaffold(
        body: Container(
          color: CustomColors.primaryColor,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: [
                  for (int i = 0; i < tabNames.length; i++)
                    Tab(
                      text: tabNames[i],
                    ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: tabPages,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
