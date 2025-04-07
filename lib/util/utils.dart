import 'package:farmers_touch/colors.dart';
import 'package:flutter/material.dart';

class Reusable {
  static Widget textField(callback, String text) {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(360),
          borderSide: BorderSide.none,
        ),
        fillColor: ColorsUtil.onPrimary,
        filled: true,
        hintText: text,
        contentPadding: EdgeInsets.all(15),
      ),
      onChanged: callback,
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
        labelStyle: TextStyle(
          color: ColorsUtil.primaryColor,
        ),
        border: border(),
        focusedBorder: focus_border(),
        enabledBorder: border(),
      ),
      controller: controller,
      validator: (txt) {
        if (txt!.trim().isEmpty) return "$label is required";
      },
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
