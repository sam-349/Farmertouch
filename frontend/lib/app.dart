import 'package:farmers_touch/main_screen.dart';
import 'package:farmers_touch/theme.dart';
import 'package:farmers_touch/views/auth/login.dart';
import 'package:farmers_touch/views/main/homescreen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Login(),
    );
  }
}
