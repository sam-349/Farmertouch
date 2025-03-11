import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Training extends StatefulWidget {
  const Training({super.key});

  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  final List<Map<String, String>> trainingCenters = [
    {
      "name": "Agri Training Hub",
      "course": "Organic Farming",
      "image":
          "https://img.freepik.com/free-photo/african-american-greenhouse-worker-holding-crate-with-fresh-lettuce-talking-with-farmer-holding-laptop-about-delivery-local-business-bio-farm-workers-preparing-deliver-online-order-client_482257-46505.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
      "link": "https://www.isec.ac.in/adrtc/"
    },
    {
      "name": "GreenTech Academy",
      "course": "Smart Irrigation",
      "image":
          "https://img.freepik.com/free-photo/african-american-greenhouse-worker-holding-crate-with-fresh-lettuce-talking-with-farmer-holding-laptop-about-delivery-local-business-bio-farm-workers-preparing-deliver-online-order-client_482257-46505.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
      "link": "https://asci.org.in/agriculturerural-development/"
    },
    {
      "name": "Harvest Pro Institute",
      "course": "Crop Disease Management",
      "image":
          "https://img.freepik.com/free-photo/african-american-greenhouse-worker-holding-crate-with-fresh-lettuce-talking-with-farmer-holding-laptop-about-delivery-local-business-bio-farm-workers-preparing-deliver-online-order-client_482257-46505.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
      "link": "https://www.icar.org.in/"
    },
    {
      "name": "Future Farmers Academy",
      "course": "Sustainable Agriculture",
      "image":
          "https://img.freepik.com/free-photo/african-american-greenhouse-worker-holding-crate-with-fresh-lettuce-talking-with-farmer-holding-laptop-about-delivery-local-business-bio-farm-workers-preparing-deliver-online-order-client_482257-46505.jpg?ga=GA1.1.1483351532.1733847503&semt=ais_hybrid",
      "link":
          "https://www.icrisat.org/research/icrisat-development-center/about"
    },
  ];

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    double containerSize = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(title: const Text("Training Centers")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            childAspectRatio: 0.8, // Adjust height-to-width ratio
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
          ),
          itemCount: trainingCenters.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _launchURL(trainingCenters[index]['link']!),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        trainingCenters[index]['image']!,
                        width: containerSize,
                        height: containerSize * 0.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            trainingCenters[index]['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trainingCenters[index]['course']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
