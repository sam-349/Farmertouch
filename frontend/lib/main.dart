import "package:farmers_touch/app.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}
