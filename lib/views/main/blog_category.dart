import 'dart:typed_data';

import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/blog_model.dart';
import 'package:farmers_touch/repo/blog_repo.dart';
import 'package:farmers_touch/views/main/blog_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shimmer/shimmer.dart';

class BlogCategory extends StatefulWidget {
  final String category;
  const BlogCategory({super.key, required this.category});

  @override
  State<BlogCategory> createState() => _BlogCategoryState();
}

class _BlogCategoryState extends State<BlogCategory> {
  bool isLoading = false;
  List<BlogModel> blogs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      final blogs_res = await BlogRepo().getBlogsByCategory(widget.category);
      if (blogs_res != null && blogs_res.isNotEmpty) {
        setState(() {
          blogs = blogs_res;
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: (!isLoading)
            ? (blogs != null && blogs.length > 0)
                ? SingleChildScrollView(
                    child: Column(
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
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      color: ColorsUtil.onPrimary,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: []),
                                  child: Row(
                                    children: [
                                      // Image Container (leading)
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(360),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(360),
                                          child: (blog.images!.length > 0)
                                              ? Image.memory(
                                                  Uint8List.fromList(blog
                                                      .images![0].data!
                                                      .cast<int>()),
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return Center(
                                                      child: Text("img"),
                                                    );
                                                  },
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(Icons.image),
                                        ),
                                      ),
                                      // Spacer to provide some space between the image and text
                                      SizedBox(width: 16),

                                      // Column to display title and content
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Title
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                              ),
                                              child: Text(
                                                blog.title ?? "title",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme
                                                    .textTheme.displayLarge,
                                              ),
                                            ),
                                            // Subtitle / Content
                                            Text(
                                              blog.content ?? "No content yet",
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList()
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: 20),
                      Text("No blogs"),
                    ],
                  )
            : Shimmer.fromColors(
                baseColor: Color(0xFFF0F0F0),
                highlightColor: Color(0xFFE0E0E0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
    );
  }
}
