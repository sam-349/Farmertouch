import 'package:flutter/material.dart';

class LiveStock extends StatefulWidget {
  const LiveStock({super.key});

  @override
  State<LiveStock> createState() => _LiveStockState();
}

class _LiveStockState extends State<LiveStock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Center(
            child: Text("Live stock"),
          )
        ],
      ),
    );
    ;
  }
}
