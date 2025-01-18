import 'package:farmers_touch/views/main/account.dart';
import 'package:farmers_touch/views/main/buy_sell.dart';
import 'package:farmers_touch/views/main/homescreen.dart';
import 'package:farmers_touch/views/main/news.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
        label: "Home",
        icon: Icon(
          Icons.home,
        )),
    BottomNavigationBarItem(
      label: "buy/sell",
      icon: Icon(Icons.shopping_bag_outlined),
    ),
    BottomNavigationBarItem(
      label: "News",
      icon: Icon(Icons.padding_outlined),
    ),
    BottomNavigationBarItem(
      label: "Account",
      icon: Icon(Icons.account_circle_outlined),
    )
  ];

  List<Widget> screens = [
    HomeScreen(),
    BuySell(),
    News(),
    Account(),
  ];

  int current_ind = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[current_ind],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (ind) {
          setState(() {
            current_ind = ind;
          });
        },
        currentIndex: current_ind,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: items,
      ),
    );
  }
}
