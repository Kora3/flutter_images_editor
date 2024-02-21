import 'package:flutter/material.dart';

Future<void> myModal({required BuildContext context, required double? factor, required Color modalBackgroundColor, required Widget child}) {
  return showModalBottomSheet(
    backgroundColor: modalBackgroundColor,
    context: context,
    builder: (context) {
      return SizedBox(
        height: (factor == null) ? null : MediaQuery.of(context).size.height * factor,
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: child,
          ),
        ),
      );
    }
  );
}