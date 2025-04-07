import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/address_model.dart';
import 'package:farmers_touch/models/cart_model.dart';
import 'package:farmers_touch/models/weather_model.dart';
import 'package:farmers_touch/provider/launguage_provider.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/repo/blog_repo.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:farmers_touch/views/main/ai.dart';
import 'package:farmers_touch/views/main/blog_details.dart';
import 'package:farmers_touch/views/main/cart.dart';
import 'package:farmers_touch/views/main/chat_screen.dart';
import 'package:farmers_touch/views/main/chatbot.dart';
import 'package:farmers_touch/views/main/crop.dart';
import 'package:farmers_touch/views/main/livestock.dart';
import 'package:farmers_touch/views/main/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/blog_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<String> carousel_images = [
    "https://img.freepik.com/premium-photo/view-sa-dec-flower-garden-dong-thap-province-vietnam-its-famous-mekong-delta-preparing-transport-flowers-market-sale-tet-holiday_991182-14414.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://img.freepik.com/premium-photo/indian-farmer-working-green-pigeon-peas-field-with-bullock_54391-6543.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://img.freepik.com/free-photo/senior-hardworking-farmer-agronomist-soybean-field-checking-crops-before-harvest_342744-1260.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://img.freepik.com/free-photo/farmer-holds-rice-hand_1150-6063.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
  ];

  // List<String> grid_text = [
  //   "Crop",
  //   "Livestock",
  //   "AI",
  //   "Training",
  // ];

  List<BlogModel> blogs = [];

  List<String> grid_images = [
    "https://cdn-icons-png.freepik.com/256/6089/6089661.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/3319/3319363.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://img.freepik.com/premium-vector/artificial-intelligence-vector-illustration_1237743-62154.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
    "https://cdn-icons-png.freepik.com/256/1376/1376421.png?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
  ];

  List<Widget> grid_screens = [
    Crop(),
    LiveStock(),
    AI(),
    Training(),
  ];

  Address? cur_address;
  Weather? weather;
  bool isLoading = false;
  String searchString = "";
  bool locationPermissionDenied = false;
  bool fetchingLocationAgain = false;
  bool locationServicesDisabled =
      false; // Track if location services are disabled
  bool hasPromptedForLocation =
      false; // New flag to track if we've asked user already

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Add observer for app lifecycle changes
    Provider.of<UserProvider>(context, listen: false).loadDataFromPrefs();
    getAddress();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      setState(() {});
      debugPrint("get blogs called");
      final blogs_res = await BlogRepo().getBlogs();
      if (blogs_res != null) {
        blogs.addAll(blogs_res);
        setState(() {
          isLoading = false;
        });
      } else {
        debugPrint("error: " + blogs_res.toString());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Clean up observer
    super.dispose();
  }

  // This method is called when the app lifecycle changes (e.g. comes back from background)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // When app resumes (comes back from settings or another app)
    if (state == AppLifecycleState.resumed) {
      // Check if location services were previously disabled
      if (locationServicesDisabled) {
        _checkLocationServicesAndRefresh();
      }
    }
  }

  // Function to check if location services are now enabled and refresh data
  Future<void> _checkLocationServicesAndRefresh() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // If location services were disabled but are now enabled
    if (serviceEnabled && locationServicesDisabled) {
      debugPrint("Location services now enabled, refreshing data");
      getAddress(forceRefresh: true);
    }
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationServicesDisabled = true;
      });

      // Only show dialog if we haven't prompted the user yet
      if (!hasPromptedForLocation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showLocationServicesDialog();
        });
      }

      return Future.error('Location services are disabled.');
    } else {
      setState(() {
        locationServicesDisabled = false;
      });
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationPermissionDenied = true;
          hasPromptedForLocation = true; // Mark that we've prompted the user
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationPermissionDenied = true;
        hasPromptedForLocation = true; // Mark that we've prompted the user
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    setState(() {
      locationPermissionDenied = false;
    });
    return await Geolocator.getCurrentPosition();
  }

  // Show dialog to prompt user to enable location services
  void _showLocationServicesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enable Location Services'),
          content: Text(
              'Location services are disabled. Would you like to enable them for weather updates and local information?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                setState(() {
                  hasPromptedForLocation = true;
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  hasPromptedForLocation = true;
                });
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to open app settings with auto-check on return
  Future<void> _openAppSettings() async {
    await Geolocator.openLocationSettings();
    // We don't need to do anything here as the didChangeAppLifecycleState
    // will handle refreshing the location when the app resumes
  }

  Future<Map<String, dynamic>> _getAddressFromCoordinates(
      Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.firstWhere(
      (placemark) => placemark.street != null && placemark.locality != null,
      orElse: () => placemarks[0],
    );

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
    String apiKey =
        '0c2ec8b3f7414263a0a1918d217722bb'; // Replace with your API key
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

  Future<void> getAddress({bool forceRefresh = false}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (!forceRefresh && userProvider.hasLocationData) {
      setState(() {
        cur_address = userProvider.address;
        weather = userProvider.weather;
      });
      return;
    }

    setState(() {
      fetchingLocationAgain = forceRefresh;
    });

    try {
      Position position = await _getCurrentPosition();
      Address address =
          Address.fromJson(await _getAddressFromCoordinates(position));
      var fetchedWeather =
          await getWeather(position.latitude, position.longitude);

      setState(() {
        cur_address = address;
        weather = fetchedWeather;
      });

      userProvider.setLocation(address, weather);
    } catch (e) {
      debugPrint("Error fetching location: $e");
      // locationPermissionDenied and locationServicesDisabled will handle different states
    } finally {
      setState(() {
        fetchingLocationAgain = false;
      });
    }
  }

  // Function to open app settings
  // Future<void> _openAppSettings() async {
  //   final Uri appSettingsUri = Uri(
  //     scheme: "package",
  //     path: "farmers_touch", // Replace with your app's package name
  //   );
  //   await launchUrl(appSettingsUri);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance
  //       .addObserver(this); // Add observer for app lifecycle changes
  //   Provider.of<UserProvider>(context, listen: false).loadDataFromPrefs();
  //   getAddress();

  //   SchedulerBinding.instance.addPostFrameCallback((_) async {
  //     isLoading = true;
  //     setState(() {});
  //     debugPrint("get blogs called");
  //     final blogs_res = await BlogRepo().getBlogs();
  //     if (blogs_res != null) {
  //       blogs.addAll(blogs_res);
  //       setState(() {
  //         isLoading = false;
  //       });
  //     } else {
  //       debugPrint("error: " + blogs_res.toString());
  //     }
  //   });
  // }

  //Update the grid_text to use translations
  late List<String> grid_text;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update text based on current locale
    final localizations = AppLocalizations.of(context)!;
    grid_text = [
      localizations.crop,
      localizations.livestock,
      localizations.ai,
      localizations.training,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<UserProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: ColorsUtil.bgColor,
      appBar: AppBar(
        backgroundColor: ColorsUtil.primaryColor,
        // leadingWidth: 140,
        // leading:
        //     Container(), // Remove location display from AppBar as requested
        title: Text(
          localizations.appTitle,
          style: theme.textTheme.titleLarge!.copyWith(letterSpacing: 1),
        ),
        // centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart_rounded,
              color: ColorsUtil.onPrimary,
            ),
          ),
          // Add a language selector button
          PopupMenuButton<Locale>(
            icon: Icon(Icons.language, color: ColorsUtil.onPrimary),
            onSelected: (Locale locale) {
              Provider.of<LanguageProvider>(context, listen: false)
                  .changeLanguage(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: Locale('en', ''),
                child: Text('English'),
              ),
              PopupMenuItem(
                value: Locale('te', ''),
                child: Text('తెలుగు'),
              ),
              // Add more languages as needed
            ],
          ),
          const SizedBox(width: 15),
        ],
        toolbarHeight: 100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CarouselSlider.builder(
              itemCount: carousel_images.length + 1,
              itemBuilder: (context, ind, a) {
                return Container(
                  width: width,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: (ind == (carousel_images.length))
                      ? Column(
                          children: [
                            const Spacer(),
                            // Weather information section
                            ListTile(
                              leading: weather != null &&
                                      weather!.weather!.isNotEmpty
                                  ? Image.network(
                                      "https://openweathermap.org/img/wn/${weather!.weather![0].icon}@2x.png",
                                      width: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Icon(Icons.error_outline),
                                    )
                                  : Icon(
                                      Icons.cloud,
                                      size: 50,
                                    ),
                              title: Text(
                                localizations.today,
                              ),
                              subtitle: Text(
                                (weather != null)
                                    ? ("${weather!.weather![0].main ?? ""} : ${weather!.main!.tempMax.toString()}°C / ${weather!.main!.tempMin.toString()}°C")
                                    : localizations.weatherUnavailable,
                              ),
                              trailing: Container(
                                height: 50,
                                width: 100,
                                child: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      (weather != null)
                                          ? weather!.weather![0].description
                                                  ?.toUpperCase() ??
                                              "N/A"
                                          : locationServicesDisabled
                                              ? "Location Off"
                                              : locationPermissionDenied
                                                  ? "Location Denied"
                                                  : "Loading...",
                                      style:
                                          theme.textTheme.titleMedium!.copyWith(
                                        color: ColorsUtil.txtColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Location information section - updated with better UI for different states
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: locationServicesDisabled ||
                                        locationPermissionDenied
                                    ? Colors.orange
                                        .shade200 // Warning color when location not available
                                    : Colors.red.shade200,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: locationServicesDisabled
                                  ? ListTile(
                                      leading: const Icon(Icons.location_off),
                                      title: Text(localizations
                                          .locationServicesDisabled),
                                      trailing: ElevatedButton(
                                        onPressed: _openAppSettings,
                                        child: Text(localizations.enable),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              ColorsUtil.primaryColor,
                                          foregroundColor: ColorsUtil.onPrimary,
                                        ),
                                      ),
                                    )
                                  : locationPermissionDenied
                                      ? ListTile(
                                          leading: const Icon(
                                              Icons.location_disabled),
                                          title: Text(localizations
                                              .locationPermissionRequired),
                                          trailing: ElevatedButton(
                                            onPressed: () =>
                                                getAddress(forceRefresh: true),
                                            child: Text(localizations.allow),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  ColorsUtil.primaryColor,
                                              foregroundColor:
                                                  ColorsUtil.onPrimary,
                                            ),
                                          ),
                                        )
                                      : fetchingLocationAgain
                                          ? ListTile(
                                              leading: Icon(Icons.refresh),
                                              title: Text(localizations
                                                  .fetchingLocation),
                                              trailing:
                                                  CircularProgressIndicator(),
                                            )
                                          : ListTile(
                                              leading:
                                                  const Icon(Icons.location_on),
                                              title: Text(cur_address != null
                                                  ? "${cur_address!.locality ?? ""}, ${cur_address!.postalCode ?? ""}"
                                                  : localizations
                                                      .locationUnknown),
                                              trailing: IconButton(
                                                icon: Icon(Icons.refresh),
                                                onPressed: () => getAddress(
                                                    forceRefresh: true),
                                                tooltip: "Refresh location",
                                              ),
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
                height: 230,
                enlargeCenterPage: true,
                enlargeFactor: 0.2,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: grid_text.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, ind) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => grid_screens[ind],
                            ),
                          );
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Spacer(),
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                ),
                                child: Image.network(
                                  grid_images[ind],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(grid_text[ind]),
                              const Spacer(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: width,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(360)),
                    child: Reusable.textField((val) async {
                      setState(() {
                        searchString = val.trim();
                        isLoading = true;
                      });
                      if (searchString.isEmpty) {
                        final content = await BlogRepo().getBlogs();
                        setState(() {
                          blogs = content!;
                          isLoading = false;
                        });
                      } else {
                        final content =
                            await BlogRepo().searchBlogs(searchString);
                        setState(() {
                          blogs = content!;
                          isLoading = false;
                        });
                      }
                    }, localizations.searchBlogs),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        localizations.blogs,
                        style: theme.textTheme.displayLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  (!isLoading)
                      ? (blogs.isNotEmpty)
                          ? Column(
                              children: [
                                ...blogs
                                    .map(
                                      (blog) => GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BlogDetails(
                                                blog: blog,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                              color: ColorsUtil.onPrimary,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey.shade300,
                                                    blurRadius: 2,
                                                    spreadRadius: 5),
                                              ]),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          360),
                                                  child: (blog
                                                          .images!.isNotEmpty)
                                                      ? Image.memory(
                                                          Uint8List.fromList(
                                                              blog.images![0]
                                                                  .data!
                                                                  .cast<int>()),
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Center(
                                                                child: Text(
                                                                    "img"));
                                                          },
                                                          fit: BoxFit.cover,
                                                        )
                                                      : const Icon(Icons.image),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8.0),
                                                      child: Text(
                                                        blog.title ?? "title",
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: theme.textTheme
                                                            .displayLarge,
                                                      ),
                                                    ),
                                                    Text(
                                                      blog.content ??
                                                          "No content yet",
                                                      maxLines: 6,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ],
                            )
                          : Text(localizations.noBlogs)
                      : Shimmer.fromColors(
                          baseColor: const Color(0xFFF0F0F0),
                          highlightColor: const Color(0xFFE0E0E0),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
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
