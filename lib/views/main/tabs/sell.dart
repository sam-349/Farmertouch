import 'dart:io';
import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/repo/product_repo.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  List<String> dropDownItems = [
    "fertilizer",
    "pesticide",
    "crop",
  ];

  String? selectedProductType;
  TextEditingController productName = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController price = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void removeImage() {
    setState(() {
      _image = null;
    });
  }

  void clearFields() {
    productName.clear();
    quantity.clear();
    price.clear();
    setState(() {
      _image = null;
      selectedProductType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownMenu<String>(
                  menuStyle: MenuStyle(
                    maximumSize:
                        MaterialStateProperty.all(Size(width - 60, 300)),
                    backgroundColor:
                        MaterialStateProperty.all(ColorsUtil.onPrimary),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: ColorsUtil.bgColor,
                    filled: true,
                  ),
                  textStyle: theme.textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                  ),
                  width: width - 60,
                  label: const Text("Product Type"),
                  dropdownMenuEntries: dropDownItems.map((item) {
                    return DropdownMenuEntry<String>(value: item, label: item);
                  }).toList(),
                  onSelected: (String? value) {
                    setState(() {
                      selectedProductType = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: productName,
                  decoration: const InputDecoration(labelText: "Product Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 60,
                      width: width / 2.5,
                      child: TextFormField(
                        controller: quantity,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Quantity"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: width / 2.5,
                      child: TextFormField(
                        controller: price,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Price"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: getImage,
                  child: Container(
                    height: 200,
                    width: width - 60,
                    decoration: BoxDecoration(
                      color: ColorsUtil.bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _image == null
                        ? const Center(child: Text("Attach Image"))
                        : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                  height: 200,
                                  width: width - 60,
                                  child:
                                      Image.file(_image!, fit: BoxFit.cover)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                  onPressed: removeImage,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: width - 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await ProductRepo().createProduct(
                          Provider.of<UserProvider>(context, listen: false)
                              .userID!,
                          productName.text.trim(),
                          selectedProductType!,
                          double.parse(price.text.trim()),
                          int.parse(quantity.text.trim()),
                          _image,
                        );
                        if (response != null) {
                          //assuming createProduct returns a non-null response on success.
                          clearFields();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Product posted successfully!')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to post product.')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsUtil.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Send",
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
