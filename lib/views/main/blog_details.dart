import 'package:farmers_touch/colors.dart';
import 'package:flutter/material.dart';

class BlogDetails extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  const BlogDetails(
      {required this.title,
      required this.image,
      required this.description,
      super.key});

  @override
  State<BlogDetails> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  double spacing = 30.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            widget.title,
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
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Swaroop',
                      style: theme.textTheme.displayLarge,
                    ),
                    SizedBox(height: 7.0),
                    Text(
                      '23 Feb 2025',
                      style: theme.textTheme.displayMedium!
                          .copyWith(color: ColorsUtil.txtColor),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: spacing),
          Container(
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
              child: Image.network(
                fit: BoxFit.cover,
                widget.image,
              ),
            ),
          ),
          SizedBox(height: spacing),
          Text(
            widget.description,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: spacing),
        ]),
      ),
    );
  }
}
