import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveAgentId(int agentId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('agent_id', agentId);
}