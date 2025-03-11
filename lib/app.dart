import 'package:farmers_touch/main_screen.dart';
import 'package:farmers_touch/provider/cart_provider.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/theme.dart';
import 'package:farmers_touch/views/auth/login.dart';
import 'package:farmers_touch/views/main/chatbot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Farmers Touch',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.user != null) {
              // User is logged in, navigate to home screen
              return MainScreen();
            } else {
              // User is not logged in, navigate to login screen
              return Login();
            }
          },
        ),
      ),
    );
  }
}
