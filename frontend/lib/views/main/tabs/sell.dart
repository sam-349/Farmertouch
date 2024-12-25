import 'package:farmers_touch/colors.dart';
import 'package:farmers_touch/util/utils.dart';
import 'package:flutter/material.dart';

class Sell extends StatefulWidget {
  const Sell({super.key});

  @override
  State<Sell> createState() => _SellState();
}

class _SellState extends State<Sell> {
  List<String> dropDownItems = [
    "Paddy Trading",
    "Wheat Trading",
    "Sugarcane Trading",
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownMenu(
                menuStyle: MenuStyle(
                  maximumSize: MaterialStateProperty.all(Size(width - 60, 300)),
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
                label: Text("Pick Type"),
                dropdownMenuEntries: dropDownItems.map((item) {
                  return DropdownMenuEntry(value: item, label: item);
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                // expands: true,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: 10,
                minLines: 1,
                cursorColor: ColorsUtil.primaryColor,
                decoration: InputDecoration(
                  label: Text("Address"),
                  border: Reusable.border(),
                  focusedBorder: Reusable.border(),
                  enabledBorder: Reusable.border(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    width: width / 3,
                    child: Center(child: Text("Limit = 30")),
                    decoration: BoxDecoration(
                      color: ColorsUtil.bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownMenu(
                    width: width / 2.5,
                    menuStyle: MenuStyle(
                      maximumSize: MaterialStateProperty.all(Size(100, 300)),
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
                    label: Text("Units"),
                    dropdownMenuEntries: ["Kg", "Ton"].map((item) {
                      return DropdownMenuEntry(value: item, label: item);
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    width: width / 3,
                    child: Reusable.customField("Quantity"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 60,
                    width: width / 2.5,
                    child: Reusable.customField("Price"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                width: width - 60,
                decoration: BoxDecoration(
                  color: ColorsUtil.bgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text("Attach Images"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //send button
              Container(
                height: 50,
                // width: width - 60,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Send",
                    style: theme.textTheme.titleMedium,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsUtil.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
