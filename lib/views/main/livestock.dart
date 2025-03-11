import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/repo/market_price_repo.dart';
import 'package:farmers_touch/views/main/bargraph/barchat_data.dart';
import 'package:farmers_touch/views/main/bargraph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ItemPrice {
  final String item;
  final int price;
  final String category;

  ItemPrice({required this.item, required this.price, required this.category});
}

class LiveStock extends StatefulWidget {
  const LiveStock({super.key});

  @override
  State<LiveStock> createState() => _LiveStockState();
}

class _LiveStockState extends State<LiveStock> {
  List<MarketPriceModel> priceData = [
    // MarketPriceModel(item: "Tomato", price: 25, category: "vegetable"),
    // MarketPriceModel(item: "Onion", price: 8, category: "vegetable"),
    // MarketPriceModel(item: "Apple", price: 100, category: "fruits"),
  ];

  List<IndividualBar> barData = [];
  Map<int, String> itemLabels = {};

  void initializeBarData(List<MarketPriceModel> prices) {
    barData = [];
    itemLabels = {};

    for (int i = 0; i < prices.length; i++) {
      barData.add(IndividualBar(x: i, y: prices[i].price!.toDouble()));
      itemLabels[i] = prices[i].item!; // Map x value to item name
    }
  }

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      setState(() {});
      final market_prices = await MarketPriceRepo().getMarketPrices();
      if (market_prices != null) {
        priceData = market_prices;
        initializeBarData(market_prices);
      } else {
        debugPrint("error: " + market_prices.toString());
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxPrice = priceData.isNotEmpty
        ? priceData
            .map((item) => item.price)
            .reduce((a, b) => a! > b! ? a : b)
            ?.toDouble()
        : 0.0; // Default value when no data is available

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Market Prices"),
              Spacer(),
              (isLoading)
                  ? CircularProgressIndicator(
                      color: ColorsUtil.primaryColor,
                    )
                  : SizedBox(
                      height: height / 2,
                      child: BarChart(
                        BarChartData(
                          maxY: ((maxPrice ?? 0) + 50),
                          minY: 5,
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(
                              show: true,
                              border: Border(
                                left: BorderSide(),
                                bottom: BorderSide(),
                              )),
                          barGroups: barData
                              .map(
                                (data) => BarChartGroupData(
                                  x: data.x,
                                  barRods: [
                                    BarChartRodData(
                                      toY: data.y,
                                      width: 20,
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorsUtil.primaryColor,
                                      backDrawRodData:
                                          BackgroundBarChartRodData(
                                        show: true,
                                        toY: ((maxPrice ?? 0) + 50),
                                        color: ColorsUtil.primaryColor
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(
                                      itemLabels[value.toInt()] ?? "",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                                reservedSize: 40,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 40),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
