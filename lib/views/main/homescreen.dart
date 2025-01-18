import 'package:carousel_slider/carousel_slider.dart';
import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/address_model.dart';
import 'package:farmers_touch/models/weather_model.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:farmers_touch/views/main/chat_screen.dart';
import 'package:farmers_touch/views/main/chatbot.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> carousel_images = [
    "https://img.freepik.com/premium-photo/view-sa-dec-flower-garden-dong-thap-province-vietnam-its-famous-mekong-delta-preparing-transport-flowers-market-sale-tet-holiday_991182-14414.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://img.freepik.com/premium-photo/indian-farmer-working-green-pigeon-peas-field-with-bullock_54391-6543.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://img.freepik.com/free-photo/senior-hardworking-farmer-agronomist-soybean-field-checking-crops-before-harvest_342744-1260.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://img.freepik.com/free-photo/farmer-holds-rice-hand_1150-6063.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
  ];

  List<String> grid_text = [
    "Crop",
    "Livestock",
    "Equipment",
    "Consulting",
    "Training",
    "Soil",
    "Harvest",
    "Regulatory",
    "Transport",
    "Analysis",
    "Account",
    "Financial",
  ];

  List<String> grid_images = [
    "https://cdn-icons-png.freepik.com/256/6089/6089661.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/3319/3319363.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/14087/14087122.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/5024/5024800.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/1376/1376421.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/18007/18007373.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/4832/4832398.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/18619/18619584.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/11845/11845726.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/3703/3703299.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/17515/17515464.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/2953/2953423.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
  ];

  Address? cur_address;
  Weather? weather;

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> _getAddressFromCoordinates(
      Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Select the most relevant placemark
    Placemark place = placemarks.firstWhere(
      (placemark) => placemark.street != null && placemark.locality != null,
      orElse: () => placemarks[0],
    );

    // Return address details as a JSON-like map
    return {
      "street": place.street,
      "locality": place.locality,
      "administrativeArea": place.administrativeArea,
      "country": place.country,
      "postalCode": place.postalCode,
      "subLocality": place.subLocality,
      "thoroughfare": place.thoroughfare,
      "subThoroughfare": place.subThoroughfare,
    };
  }

  Future<Weather> getWeather(double latitude, double longitude) async {
    String apiKey = '0c2ec8b3f7414263a0a1918d217722bb';
    String url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      debugPrint("Weather: " + response.body);
      Weather data = Weather.fromJson(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<void> getAddress() async {
    Position position = await _getCurrentPosition();
    Address address =
        Address.fromJson(await _getAddressFromCoordinates(position));
    debugPrint(address.toString());
    debugPrint(
        position.latitude.toString() + " " + position.latitude.toString());
    var cur_weather = await getWeather(position.latitude, position.longitude);
    debugPrint(weather.toString());
    setState(() {
      cur_address = address;
      weather = cur_weather;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: AppBar(
        backgroundColor: ColorsUtil.primaryColor,
        leadingWidth: 100,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: Row(children: [
            Icon(
              Icons.location_on,
              color: ColorsUtil.onPrimary,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Home",
              style: theme.textTheme.titleMedium,
            )
          ]),
        ),
        title: Text(
          "Farmer Touch",
          style: theme.textTheme.titleLarge!.copyWith(letterSpacing: 1),
        ),
        centerTitle: true,
        actions: [
          Icon(
            Icons.notifications_active,
            color: ColorsUtil.onPrimary,
          ),
          SizedBox(
            width: 15,
          ),
        ],
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            CarouselSlider.builder(
              itemCount: carousel_images.length + 1,
              itemBuilder: (context, ind, a) {
                return Container(
                  // height: 100,
                  width: width,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  // child:
                  child: (ind == (carousel_images.length))
                      ? Column(
                          children: [
                            Spacer(),
                            ListTile(
                              title: Text("Today"),
                              subtitle: Text(
                                (weather != null)
                                    ? (weather!.weather![0].main.toString() +
                                            ": " +
                                            weather!.main!.tempMax.toString() +
                                            " / " +
                                            weather!.main!.tempMin
                                                .toString()) ??
                                        ""
                                    : "loading....",
                              ),
                              trailing: Container(
                                height: 50,
                                width: 100,
                                // decoration: BoxDecoration(color: Colors.red),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (weather != null)
                                          ? weather!.weather![0].main ?? ""
                                          : "loading....",
                                      style:
                                          theme.textTheme.titleMedium!.copyWith(
                                        color: ColorsUtil.txtColor,
                                      ),
                                    ),
                                    // Icon(Icons.wb_sunny),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.red.shade200,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: (cur_address != null)
                                  ? ListTile(
                                      leading: Icon(Icons.location_on),
                                      title: Text(
                                          (cur_address!.locality ?? "") +
                                              ", " +
                                              (cur_address!.postalCode ?? "")),
                                    )
                                  : ListTile(
                                      leading: Icon(Icons.location_on),
                                      title:
                                          Text("Location permission required "),
                                      trailing: Text("Allow"),
                                    ),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            carousel_images[ind],
                            fit: BoxFit.cover,
                          ),
                        ),
                );
              },
              options: CarouselOptions(
                height: 200,
                // autoPlay: true,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(360)),
                    child: Reusable.textField(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: grid_text.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, ind) {
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Spacer(),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                              ),
                              child: Image.network(
                                grid_images[ind],
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(grid_text[ind]),
                            Spacer(),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatBot(),
            ),
          );
        },
        backgroundColor: ColorsUtil.primaryColor,
        child: Icon(
          Icons.chat_rounded,
          color: ColorsUtil.onPrimary,
        ),
      ),
    );
  }
}
