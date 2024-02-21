import 'package:flutter/material.dart';
import 'package:images_editor/widgets/custom_text.dart';
import 'text_info.dart';

class ImageText extends StatelessWidget {
  final TextInfo textInfo;

  const ImageText({super.key, required this.textInfo,});

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(textInfo.position / 360),
      child: customText(
        textInfo.text,
        textAlign: textInfo.textAlign,
        fontSize: textInfo.fontSize,
        fontWeight: textInfo.fontWeight,
        fontStyle: textInfo.fontStyle,
        color: textInfo.color,
      ),
    );
  }
}