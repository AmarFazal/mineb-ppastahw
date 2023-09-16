import 'package:flutter/material.dart';
import 'package:whatsapp_agent_android/pages/login_page.dart';
import '1frf_api.dart';
import 'utilities/colors.dart';
import 'utilities/redirect_to_new_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
            backgroundColor: Colors.lightBlue[200],
            contentTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400),
            elevation: 0,
            showCloseIcon: true,
            closeIconColor: Colors.black),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        useMaterial3: false,
        primarySwatch: customPrimaryColor,
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: CustomColors.primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        brightness: Brightness.light, // Açık (light) tema için parlaklık ayarı
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Giriş durumunu kontrol etmek için checkLoginStatus'u çağırın
    checkLoginStatus();
  }

  // Giriş durumunu kontrol etmek için
  Future<void> checkLoginStatus() async {
    int? agentId = await AuthUtils.getAgentIdFromSharedPreferences();
    if (agentId != null) {
      // Eğer agent ID mevcutsa, diğer sayfaya yönlendirin.
      redirectToNewPage(context);
    } else {
      // Eğer agent ID yoksa, login sayfasına yönlendirin.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
//https://www.youtube.com/shorts/k68GWadKItY