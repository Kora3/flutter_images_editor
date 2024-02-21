import 'package:flutter/material.dart';

class CustomText {
  String? nextText;

  String? alertDialogTitle;

  String? alertDialogAdd;

  String? alertDialogCancel;

  String? onSelectText;

  String? onDeleteText;

  CustomText({this.nextText, this.alertDialogTitle, this.alertDialogAdd, this.alertDialogCancel,
    this.onSelectText, this.onDeleteText});
}


class CustomColor {
  /// Use as app primaryThemeColor
  Color? primaryColor;

  /// Use as app scaffold backgroundColor
  Color? backgroundColor;

  /// Use as app modalBottomSheet backgroundColor
  Color? modalBackgroundColor;

  CustomColor({this.primaryColor, this.backgroundColor, this.modalBackgroundColor});
}

class CustomWidget {
  Widget? circularIndicator;

  CustomWidget({this.circularIndicator});
}
