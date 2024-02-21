import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:images_editor/utils/colors.dart';

Widget loader() {
  if (Platform.isIOS) {
    return Center(
      child: CupertinoActivityIndicator(color: redColor,),
    );
  } else {
    return Center(
      child: CircularProgressIndicator(color: redColor,),
    );
  }
}

Future loadingIn(BuildContext context, {Widget? loaderIn}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        children: [
          loaderIn ?? loader(),
        ],
      );
    },
  );
}