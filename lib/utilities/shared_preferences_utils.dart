import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future<int?> getAgentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('agent_id');
  }
}
