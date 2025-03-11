import 'dart:io';

import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/provider/user_provider.dart';
import 'package:farmers_touch/repo/blog_repo.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BlogAdd extends StatefulWidget {
  const BlogAdd({super.key});

  @override
  State<BlogAdd> createState() => _BlogAddState();
}

class _BlogAddState extends State<BlogAdd> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  List<XFile> files = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double spacing = 30.0;
    List<String> category = ["Fruits", "Vegetables", "Crops"];
    ImagePicker picker = ImagePicker();
    final provider = Provider.of<UserProvider>(context);
    String selectedCategory = "";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorsUtil.primaryColor,
        title: Text(
          "Add a Blog",
          style: theme.textTheme.titleLarge,
        ),
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: spacing),
                Reusable.customField('title', title),
                SizedBox(height: spacing),
                Reusable.customField('content', content),
                SizedBox(height: spacing),
                DropdownMenu(
                  onSelected: (val) {
                    setState(() {
                      selectedCategory = val!;
                    });
                  },
                  menuStyle: MenuStyle(
                    // maximumSize: MaterialStateProperty.all(Size(300, 300)),
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
                  width: width - 40,
                  label: Text("Choose category"),
                  dropdownMenuEntries: category.map((item) {
                    return DropdownMenuEntry(value: item, label: item);
                  }).toList(),
                ),
                SizedBox(height: spacing),
                Text("Attach Images"),
                SizedBox(height: spacing),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        List<XFile> galleryImages =
                            await picker.pickMultiImage();
                        files.addAll(galleryImages);
                        setState(() {});
                        debugPrint(files.toString());
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
                        XFile? cameraImage =
                            await picker.pickImage(source: ImageSource.camera);
                        files.add(cameraImage!);
                        setState(() {});
                        debugPrint(files.toString());
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
                (files.length > 0) ? Text("Attached Images") : SizedBox(),
                SizedBox(height: spacing),
                Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        final response = await BlogRepo().uploadBlog(
                            title.text.toString(),
                            content.text.toString(),
                            selectedCategory,
                            provider.userID!,
                            files);
                      },
                      child: Text("submit")),
                ),
                SizedBox(height: spacing),
                (files.length > 0)
                    ? Container(
                        height: width,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: files.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                          itemBuilder: (context, ind) {
                            return Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Stack(
                                alignment: Alignment.topRight,
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    width: (width / 2) - 40,
                                    height: (width / 2) - 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.file(
                                        fit: BoxFit.cover,
                                        File(files[ind].path),
                                        errorBuilder:
                                            ((context, error, stackTrace) {
                                          return const Center(
                                            child: Text('Image Not found'),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 3,
                                    right: 3,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            files.remove(files[ind]);
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(360),
                                              color: Colors.grey.shade700,
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
