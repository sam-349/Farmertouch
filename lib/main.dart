import "package:farmers_touch/app.dart";
import "package:farmers_touch/provider/user_provider.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gemini/flutter_gemini.dart";
import "package:provider/provider.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = UserProvider();
  await userProvider.loadUserFromPrefs();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Gemini.init(apiKey: "AIzaSyBaddpZYCGYwy5vx3tBflUPAK5Vb8iZkcI");
  runApp(
    ChangeNotifierProvider(
      create: (context) => userProvider,
      child: MyApp(),
    ),
  );
}
