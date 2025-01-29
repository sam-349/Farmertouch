import 'package:farmers_touch/colors.dart';
import 'package:flutter/material.dart';

class Reusable {
  static Widget textField() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(360),
          borderSide: BorderSide.none,
        ),
        fillColor: ColorsUtil.onPrimary,
        filled: true,
        hintText: "Search Service",
        contentPadding: EdgeInsets.all(15),
      ),
    );
  }

  static TextFormField customField(
      String label, TextEditingController controller) {
    return TextFormField(
      keyboardType: (label.toLowerCase() == "price")
          ? TextInputType.number
          : TextInputType.text,
      cursorColor: ColorsUtil.primaryColor,
      decoration: InputDecoration(
        label: Text(label),
        border: border(),
        focusedBorder: focus_border(),
        enabledBorder: border(),
      ),
      controller: controller,
    );
  }

  static OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 2,
        color: ColorsUtil.bgColor,
      ),
    );
  }

  static OutlineInputBorder focus_border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(
        width: 2,
        color: ColorsUtil.primaryColor,
      ),
    );
  }
}
