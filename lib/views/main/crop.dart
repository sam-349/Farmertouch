import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/views/main/blog_category.dart';
import 'package:flutter/material.dart';

class Crop extends StatefulWidget {
  const Crop({super.key});

  @override
  State<Crop> createState() => _CropState();
}

class _CropState extends State<Crop> with SingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController Search = TextEditingController();
  String searchString = "";

  List<Tab> tabs = [
    const Tab(
      child: Text('wheat'),
    ),
    const Tab(
      child: Text('paddy'),
    ),
    const Tab(
      child: Text('Fruits'),
    ),
    const Tab(
      child: Text('Vegetables'),
    ),
    const Tab(
      child: Text('Other'),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController =
        TabController(length: tabs.length, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
        child: Column(children: [
          //Search bar
          // Reusable.textField(context, 'Search Notes', Search,
          // //callback to update the search string
          //     onChange: (value) {
          //   setState(() {
          //     searchString = value;
          //   });
          // }),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            padding: const EdgeInsets.only(left: 5),
            child: TabBar(
              tabs: tabs,
              controller: tabController,
              labelColor: (theme.brightness == Brightness.light)
                  ? Colors.white
                  : Colors.black,
              // labelStyle: h2textStyle,
              indicator: BoxDecoration(
                color: ColorsUtil.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
            ),
          ),
          Expanded(
              child: TabBarView(
            controller: tabController,
            children: [
              BlogCategory(category: "wheat"),
              BlogCategory(category: "paddy"),
              BlogCategory(category: "fruits"),
              BlogCategory(category: "vegetables"),
              BlogCategory(category: "other"),
            ],
          )),
        ]),
      ),
    );
  }
}
