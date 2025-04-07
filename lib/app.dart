import 'package:farmers_touch/main_screen.dart';
import 'package:farmers_touch/provider/cart_provider.dart';
import 'package:farmers_touch/provider/launguage_provider.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/theme.dart';
import 'package:farmers_touch/views/auth/login.dart';
import 'package:farmers_touch/views/main/chatbot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
        return MaterialApp(
          // Enable localization
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English
            Locale('te', ''), // Telugu
            // Add more locales as needed
          ],
          locale: languageProvider.currentLocale,
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
        );
      }),
    );
  }
}
