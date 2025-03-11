import 'dart:typed_data';

import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/farmer_user_model.dart';
import 'package:farmers_touch/models/product_model.dart';
import 'package:farmers_touch/repo/farmer_user_repo.dart';
import 'package:farmers_touch/repo/product_repo.dart';
import 'package:farmers_touch/views/main/farmer_details.dart';
import 'package:farmers_touch/views/main/productDetail2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:heroicons/heroicons.dart';

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  bool isLoading = false;
  List<ProductModel> products = [];
  List<Farmer> farmers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      setState(() {});
      debugPrint("get blogs called");
      final products_res = await ProductRepo().getProducts();
      if (products_res != null) {
        products.addAll(products_res);
      } else {
        debugPrint("error: " + products_res.toString());
      }

      final farmers_res = await FarmerUserRepo().getFarmers();
      if (farmers_res != null) {
        farmers.addAll(farmers_res);
      } else {
        debugPrint("error: " + farmers_res.toString());
      }

      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              // Text(
              //   "Trending Products 🔥",
              //   style: theme.textTheme.displayLarge,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Container(
              //   height: height / 2.8,
              //   width: width,
              //   child: ListView.builder(
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 5,
              //     itemBuilder: (context, ind) {
              //       return Stack(
              //         children: [
              //           Container(
              //             height: height / 2.8,
              //             width: width / 1.7,
              //             margin: EdgeInsets.symmetric(horizontal: 5.0),
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(20),
              //               color: Colors.grey[300],
              //               image: DecorationImage(
              //                 fit: BoxFit.fitHeight,
              //                 image: NetworkImage(
              //                   "https://img.freepik.com/premium-photo/roundup-is-postgrowth-herbicide-with-active-ingredient_1197797-244915.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
              //                 ),
              //               ),
              //             ),
              //           ),
              //           Positioned(
              //             bottom: 0,
              //             child: Container(
              //               height: height / 2.8,
              //               width: width / 1.7,
              //               margin: EdgeInsets.symmetric(horizontal: 5.0),
              //               padding: EdgeInsets.all(10),
              //               decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(20),
              //                 gradient: LinearGradient(
              //                   begin: Alignment.topCenter,
              //                   end: Alignment.bottomCenter,
              //                   colors: [
              //                     Colors.transparent,
              //                     Colors.black.withOpacity(0.8),
              //                   ],
              //                 ),
              //               ),
              //               child: Column(
              //                 // mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   Spacer(),
              //                   Container(
              //                     height: 60,
              //                     width: 60,
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(360),
              //                       color: Colors.blue.shade800,
              //                     ),
              //                     child: Center(
              //                       child: Icon(
              //                         Icons.play_arrow,
              //                         color: ColorsUtil.onPrimary,
              //                         size: 30,
              //                       ),
              //                     ),
              //                   ),
              //                   Spacer(),
              //                   Row(
              //                     children: [
              //                       Icon(
              //                         Icons.video_library_outlined,
              //                         color: ColorsUtil.onPrimary,
              //                       ),
              //                       SizedBox(
              //                         width: 5,
              //                       ),
              //                       Text(
              //                         "00:54",
              //                         style: theme.textTheme.displayMedium,
              //                       ),
              //                       SizedBox(
              //                         width: 10,
              //                       ),
              //                       Container(
              //                         height: 20,
              //                         width: 2,
              //                         color: Colors.white,
              //                       ),
              //                       SizedBox(
              //                         width: 10,
              //                       ),
              //                       Icon(
              //                         Icons.coronavirus_outlined,
              //                         color: ColorsUtil.onPrimary,
              //                       ),
              //                       SizedBox(
              //                         width: 5,
              //                       ),
              //                       Text(
              //                         "Pesiticides",
              //                         style: theme.textTheme.displayMedium,
              //                       )
              //                     ],
              //                   ),
              //                   SizedBox(
              //                     height: 10,
              //                   ),
              //                   Container(
              //                     // height: 70,
              //                     width: width / 1.5,
              //                     // padding: EdgeInsets.all(10),
              //                     decoration: BoxDecoration(
              //                       borderRadius: BorderRadius.circular(20),
              //                       color: Colors.white,
              //                     ),
              //                     child: ListTile(
              //                       leading: Container(
              //                         height: 50,
              //                         width: 50,
              //                         decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(10),
              //                           color: Colors.grey[300],
              //                         ),
              //                         child: HeroIcon(
              //                           HeroIcons.shoppingCart,
              //                           color: ColorsUtil.txtColor,
              //                         ),
              //                       ),
              //                       title: Text("Go to product"),
              //                       subtitle: Text("Super star"),
              //                       trailing: HeroIcon(
              //                         HeroIcons.chevronRight,
              //                         color: ColorsUtil.txtColor,
              //                       ),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: ColorsUtil.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.shop_outlined,
                            // color: ColorsUtil.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Products",
                        style: theme.textTheme.displayLarge,
                      ),
                    ],
                  ),
                  // Text(
                  //   "View All",
                  //   style: theme.textTheme.displayLarge!.copyWith(
                  //     color: Colors.blue.shade600,
                  //     fontWeight: FontWeight.w800,
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 250,
                width: width,
                child: (isLoading)
                    ? Column(
                        children: [
                          CircularProgressIndicator(
                            color: ColorsUtil.primaryColor,
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, ind) {
                          return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ProductDetailsPage(
                              //       product: products[ind],
                              //     ),
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    productData: products[ind],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              // height: 200,
                              width: width / 2.5,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // color: Colors.grey[300],
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: (products[ind].image != null)
                                        ? Image.memory(
                                            height: 100,
                                            width: width / 2.5,
                                            Uint8List.fromList(products[ind]
                                                .image!
                                                .data!
                                                .cast<int>()),
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Text("img"),
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          )
                                        : Center(child: Icon(Icons.grass)),
                                  ),
                                  Spacer(),
                                  ListTile(
                                    title: Text(
                                      products[ind].productName ?? "product",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.titleSmall!.copyWith(
                                        color: ColorsUtil.txtColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      String.fromCharCode(8377) +
                                              products[ind].price.toString() ??
                                          "price",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      // style: theme.textTheme.titleSmall!.copyWith(
                                      //   color: ColorsUtil.txtColor,
                                      // ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 10.0),
                                  //   child: Text(
                                  //     "1km away",
                                  //     overflow: TextOverflow.ellipsis,
                                  //     maxLines: 1,
                                  //   ),
                                  // ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(
                height: 20,
              ),
              //Listview builder which scrolls horizontally to display farmer photo and details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: ColorsUtil.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_outline,
                            // color: ColorsUtil.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Farmers",
                        style: theme.textTheme.displayLarge,
                      ),
                    ],
                  ),
                  // Text(
                  //   "View All",
                  //   style: theme.textTheme.displayLarge!.copyWith(
                  //     color: Colors.blue.shade600,
                  //     fontWeight: FontWeight.w800,
                  //   ),
                  // )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 220,
                width: width,
                child: (isLoading)
                    ? Column(
                        children: [
                          CircularProgressIndicator(
                            color: ColorsUtil.primaryColor,
                          ),
                        ],
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: farmers.length,
                        itemBuilder: (context, ind) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FarmerDetailsPage(
                                    farmer: farmers[ind],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              // height: 200,
                              width: width / 2.5,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                // color: Colors.grey[300],
                                border: Border.all(
                                  width: 1.5,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    child: (farmers[ind].pic != null)
                                        ? Image.memory(
                                            height: 100,
                                            width: width / 2.5,
                                            Uint8List.fromList(farmers[ind]
                                                .pic!
                                                .data!
                                                .cast<int>()),
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Center(
                                                child: Text("img"),
                                              );
                                            },
                                            fit: BoxFit.cover,
                                          )
                                        : Center(
                                            child: Icon(Icons.account_circle)),
                                  ),
                                  Spacer(),
                                  ListTile(
                                    title: Text(
                                      farmers[ind].username ?? "farmer",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.titleSmall!.copyWith(
                                        color: ColorsUtil.txtColor,
                                      ),
                                    ),
                                    subtitle: Text(
                                      farmers[ind].location ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      // style: theme.textTheme.titleSmall!.copyWith(
                                      //   color: ColorsUtil.txtColor,
                                      // ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(left: 10.0),
                                  //   child: Text(
                                  //     "1km away",
                                  //     overflow: TextOverflow.ellipsis,
                                  //     maxLines: 1,
                                  //   ),
                                  // ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
