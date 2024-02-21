import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:images_editor/utils/colors.dart';
import 'package:images_editor/utils/setting_values.dart';
import 'package:images_editor/widgets/custom_text.dart';
import 'package:photofilters/photofilters.dart';
import 'filtered_image_widget.dart';

class FilterImage extends StatefulWidget {
  final img.Image image;
  final Function(Uint8List) onChoose;
  final CustomColor customColor;
  final CustomWidget customWidget;
  const FilterImage({super.key, required this.image, required this.onChoose,
    required this.customColor, required this.customWidget});

  @override
  State<FilterImage> createState() => _FilterImageState();
}

class _FilterImageState extends State<FilterImage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: presetFiltersList.length,
        itemBuilder: (context, index) {
          final filter = presetFiltersList[index];
          return Container(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilteredImageWidget(
                  filter: filter,
                  customWidget: widget.customWidget,
                  image: widget.image,
                  succes: (imageBytes) {
                    return InkWell(
                      onTap: () {
                        widget.onChoose(Uint8List.fromList(imageBytes));
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: widget.customColor.primaryColor ?? whiteColor,
                        backgroundImage: MemoryImage(Uint8List.fromList(imageBytes)),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5,),
                customText(filter.name, color: widget.customColor.primaryColor ?? whiteColor, fontSize: 13.0)
              ],
            ),
          );
        }
      ),
    );
  }
}
