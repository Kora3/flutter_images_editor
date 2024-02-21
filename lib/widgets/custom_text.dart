import 'package:flutter/material.dart';
import 'package:images_editor/utils/colors.dart';
import 'package:images_editor/utils/setting_values.dart';

Widget customText(String text, {required Color color, required double fontSize, FontStyle fontStyle = FontStyle.normal,
  FontWeight fontWeight = FontWeight.normal, TextAlign textAlign = TextAlign.center, TextDecoration textDecoration = TextDecoration.none,
  TextOverflow textOverflow = TextOverflow.clip}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: textOverflow,
    textScaleFactor: 1.0,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      decoration: textDecoration,
    ),
  );
}

ScaffoldFeatureController showSnackBarMessage(BuildContext context, String title, CustomColor customColor) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: customColor.backgroundColor ?? backgroundColor,
      backgroundColor: customColor.primaryColor ?? whiteColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 0),
      content: customText(title, fontSize: 15.0, color: customColor.backgroundColor ?? backgroundColor,),
    ),
  );
}
