import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:images_editor/utils/colors.dart';
import 'package:images_editor/utils/setting_values.dart';
import 'package:images_editor/widgets/custom_text.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as img;
import 'filtered_image_widget.dart';

class FilteredImageListWidget extends StatelessWidget {
  final List<Filter> filters;
  final img.Image image;
  final ValueChanged<Filter> onChangedFilter;
  final CustomColor customColor;
  final CustomWidget customWidget;
  const FilteredImageListWidget({super.key, required this.filters, required this.image, required this.onChangedFilter,
    required this.customColor, required this.customWidget,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return InkWell(
            onTap: () {
              onChangedFilter(filter);
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilteredImageWidget(
                    filter: filter,
                    image: image,
                    customWidget: customWidget,
                    succes: (imageBytes) {
                      return CircleAvatar(
                        radius: 40,
                        backgroundColor: customColor.primaryColor ?? whiteColor,
                        backgroundImage: MemoryImage(Uint8List.fromList(imageBytes)),
                      );
                    },
                  ),
                  const SizedBox(height: 5,),
                  customText(filter.name, color: customColor.primaryColor ?? whiteColor, fontSize: 13.0)
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
