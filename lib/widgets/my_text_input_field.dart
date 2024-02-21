import 'package:flutter/material.dart';
import 'package:images_editor/utils/colors.dart';
import 'package:images_editor/utils/setting_values.dart';

class MyTextInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final InputDecoration? decoration;
  final CustomColor customColor;
  const MyTextInputField({super.key, required this.controller, required this.hintText, this.decoration, required this.customColor,});

  @override
  State<MyTextInputField> createState() => _MyTextInputFieldState();
}

class _MyTextInputFieldState extends State<MyTextInputField> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
      borderRadius: BorderRadius.circular(5.0),
    );

    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        fontSize: 15.0,
        color: widget.customColor.primaryColor ?? whiteColor,
      ),
      decoration: widget.decoration ?? InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontSize: 15.0,
          color: widget.customColor.primaryColor ?? whiteColor,
        ),
        filled: true,
        fillColor: widget.customColor.backgroundColor ?? backgroundColor,
        contentPadding: const EdgeInsets.only(top: 5, left: 10),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
      ),
      maxLines: 1,
      cursorColor: widget.customColor.primaryColor ?? whiteColor,
    );
  }
}