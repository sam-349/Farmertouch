import "package:farmers_touch/app.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_gemini/flutter_gemini.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Gemini.init(apiKey: "AIzaSyBaddpZYCGYwy5vx3tBflUPAK5Vb8iZkcI");
  runApp(MyApp());
}
