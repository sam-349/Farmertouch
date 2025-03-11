import 'dart:typed_data';

import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogDetails extends StatefulWidget {
  // final List<BlogImage> images;
  // final String title;
  // final String description;
  final BlogModel blog;
  const BlogDetails(
      {
      // {required this.title,
      // required this.images,
      // required this.description,
      required this.blog,
      super.key});

  @override
  State<BlogDetails> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  double spacing = 30.0;

  @override
  Widget build(BuildContext context) {
    // DateTime dateTime = DateTime.parse(widget.blog.createdAt)
    //     .toLocal(); // Convert to local time
    String formattedDate =
        DateFormat('dd MMM yyyy, hh:mm a').format(widget.blog.createdAt!);

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              widget.blog.title ?? "title",
              style: theme.textTheme.titleLarge!.copyWith(
                color: Colors.black,
              ),
            ),
            SizedBox(height: spacing),
            Container(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: (widget.blog.images!.length > 0)
                          ? Image.memory(
                              Uint8List.fromList(
                                  widget.blog.images![0].data!.cast<int>()),
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text("img"),
                                );
                              },
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.blog.userId!.username!,
                        style: theme.textTheme.displayLarge,
                      ),
                      SizedBox(height: 7.0),
                      Text(
                        formattedDate,
                        style: theme.textTheme.displayMedium!
                            .copyWith(color: ColorsUtil.txtColor),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: spacing),
            (widget.blog.images!.length > 0)
                ? Container(
                    height: 250,
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 700.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: (widget.blog.images!.length > 0)
                          ? Image.memory(
                              Uint8List.fromList(
                                  widget.blog.images![0].data!.cast<int>()),
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text("img"),
                                );
                              },
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image),
                    ),
                  )
                : SizedBox(),
            SizedBox(height: spacing),
            Text(
              widget.blog.content ?? "No content yet",
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: spacing),
          ]),
        ),
      ),
    );
  }
}
