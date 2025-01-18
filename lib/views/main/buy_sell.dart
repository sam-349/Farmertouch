import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/views/main/tabs/buy.dart';
import 'package:farmers_touch/views/main/tabs/sell.dart';
import 'package:flutter/material.dart';

class BuySell extends StatefulWidget {
  const BuySell({super.key});

  @override
  State<BuySell> createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> with SingleTickerProviderStateMixin {
  late TabController tb;

  List<Tab> tabs = [
    Tab(
      text: "Buy",
    ),
    Tab(
      text: "Sell",
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tb = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 30,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: ColorsUtil.onPrimary,
          ),
        ),
        backgroundColor: ColorsUtil.primaryColor,
        title: Text(
          "New post",
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsUtil.bgColor,
                borderRadius: BorderRadius.circular(360),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TabBar(
                tabs: tabs,
                controller: tb,
                labelColor: Colors.white,
                labelStyle: theme.textTheme.titleMedium,
                indicator: BoxDecoration(
                  color: ColorsUtil.primaryColor,
                  borderRadius: BorderRadius.circular(360),
                ),
                dividerColor: Colors.transparent,
                tabAlignment: TabAlignment.fill,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tb,
                children: [
                  Buy(),
                  Sell(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
