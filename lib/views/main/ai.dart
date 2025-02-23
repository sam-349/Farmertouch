import 'dart:convert';
import 'dart:io';

import 'package:farmers_touch/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class AI extends StatefulWidget {
  const AI({super.key});

  @override
  State<AI> createState() => _AIState();
}

class _AIState extends State<AI> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final Gemini _gemini = Gemini.instance; // Initialize Gemini instance
  final String prompt = '''
    Analyze the given image of a crop leaf and predict the possible disease affecting the plant. Provide the following details in the response:

    Predicted Disease: Identify the disease affecting the crop.
    Confidence Level: Provide a confidence score (e.g., percentage) for the prediction.
    Symptoms Analysis: Describe the symptoms observed in the leaf that led to the diagnosis.
    Possible Causes: List the potential reasons for this disease (e.g., fungal, bacterial, viral infection, or nutrient deficiency).
    Suggestive Measures: Provide actionable recommendations to control or prevent the disease, including:
    Natural Remedies: Organic or environmentally friendly solutions.
    Chemical Treatments: Suitable pesticides, fungicides, or fertilizers.
    Preventive Measures: Best farming practices to avoid recurrence.
    Output Format: Present the results in a structured JSON format for easy integration into the app, as shown below:
      {
      "predicted_disease": "Leaf Blight",
      "confidence": "92%",
      "symptoms_analysis": "Yellowing and browning of leaf edges with dark spots.",
      "possible_causes": ["Fungal infection", "High humidity", "Poor air circulation"],
      "suggestive_measures": {
        "natural_remedies": ["Use neem oil spray", "Improve soil drainage"],
        "chemical_treatments": ["Apply copper-based fungicide"],
        "preventive_measures": ["Ensure proper crop spacing", "Avoid overhead watering"]
      }
    }

    ''';
  final Map<String, dynamic> diseasePrediction = {
    "predicted_disease": "Leaf Blight",
    "confidence": "92%",
    "symptoms_analysis":
        "Yellowing and browning of leaf edges with dark spots.",
    "possible_causes": [
      "Fungal infection",
      "High humidity",
      "Poor air circulation"
    ],
    "suggestive_measures": {
      "natural_remedies": ["Use neem oil spray", "Improve soil drainage"],
      "chemical_treatments": ["Apply copper-based fungicide"],
      "preventive_measures": [
        "Ensure proper crop spacing",
        "Avoid overhead watering"
      ]
    }
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage(String source) async {
    final pickedFile = await _picker.pickImage(
        source:
            (source == "gallery") ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _analyzeImage(_image!);
    }
  }

  Future<void> _analyzeImage(File imageFile) async {
    try {
      // Create a FileDataPart
      FileDataPart filePart = FileDataPart(
        fileUri: imageFile.path,
        mimeType: lookupMimeType(imageFile.path),
      );
      debugPrint(filePart.mimeType);

      _gemini.chat(
        // model: ,
        // model: "gemini-pro-vision",
        [
          // Part.text(prompt),
          Content(parts: [Part.file(filePart)]),
        ],
      ).then((value) {
        debugPrint("Got response: ${value!.output}");
        //   if (value.error != null) {
        //   debugPrint("Gemini Error: ${value.error}");
        // }
      }).catchError((e) => debugPrint("Error: " + e.toString()));

      // if (response != null) {
      //   _showResult(response.output);
      // }
    } catch (e) {
      print("Error analyzing image: $e");
    }
  }

  double spacing = 30.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analyze your crops',
          style: theme.textTheme.titleLarge!.copyWith(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: spacing),
              Container(
                height: height / 3.5,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: (_image == null)
                      ? Image.asset(
                          fit: BoxFit.cover,
                          'assets/images/crop_image.jpg',
                        )
                      : Image.file(
                          fit: BoxFit.cover,
                          File(_image!.path),
                          errorBuilder: ((context, error, stackTrace) {
                            return const Center(
                              child: Text('Image Not found'),
                            );
                          }),
                        ),
                ),
              ),
              SizedBox(height: spacing),
              Text("Upload an image and analyze to see results"),
              SizedBox(height: spacing),
              Row(
                children: [
                  Text(
                    "Upload image",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () async {
                      _pickImage("gallery");
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: ColorsUtil.bgColor,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Icon(Icons.photo, size: 30.0),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () async {
                      _pickImage("camera");
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: ColorsUtil.bgColor,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      child: Icon(
                        Icons.camera,
                        size: 30.0,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_image != null) {
                      _analyzeImage(_image!);
                    }
                  },
                  child: Text("Analyze image"),
                ),
              ),
              SizedBox(height: spacing),
              Container(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisSize: MainAxisSize.max,
                                children: [
                                  Center(
                                    child: Container(
                                      height: 5,
                                      alignment: Alignment.center,
                                      width: width / 3,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(360),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _buildSectionTitle('Predicted Disease'),
                                  _buildText(
                                      diseasePrediction['predicted_disease']),
                                  SizedBox(height: 12),
                                  _buildSectionTitle('Confidence'),
                                  _buildText(diseasePrediction['confidence']),
                                  SizedBox(height: 12),
                                  _buildSectionTitle('Symptoms Analysis'),
                                  _buildText(
                                      diseasePrediction['symptoms_analysis']),
                                  SizedBox(height: 12),
                                  _buildSectionTitle('Possible Causes'),
                                  ..._buildList(
                                      diseasePrediction['possible_causes']),
                                  SizedBox(height: 12),
                                  _buildSectionTitle('Suggestive Measures'),
                                  _buildSubSection(
                                      'Natural Remedies',
                                      diseasePrediction['suggestive_measures']
                                          ['natural_remedies']),
                                  _buildSubSection(
                                      'Chemical Treatments',
                                      diseasePrediction['suggestive_measures']
                                          ['chemical_treatments']),
                                  _buildSubSection(
                                      'Preventive Measures',
                                      diseasePrediction['suggestive_measures']
                                          ['preventive_measures']),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Text("See Results"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16),
    );
  }

  List<Widget> _buildList(List<String> items) {
    return items
        .map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 8),
                  Text(item),
                ],
              ),
            ))
        .toList();
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
        ..._buildList(items),
      ],
    );
  }
}
