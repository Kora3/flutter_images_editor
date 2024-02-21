import 'package:flutter/material.dart';
import 'package:images_editor/utils/setting_values.dart';
import 'package:images_editor/widgets/loader.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as img;
import 'filters_utils.dart';

class FilteredImageWidget extends StatelessWidget {
  final Filter filter;
  final img.Image image;
  final Widget Function(List<int> image) succes;
  final CustomWidget customWidget;
  const FilteredImageWidget({super.key, required this.filter, required this.image, required this.succes, required this.customWidget,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<List<int>>(
      future: FilterUtils.applyFilter(image, filter),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return customWidget.circularIndicator ?? loader();
        }

        return succes(snapshot.data!);
      },
    );
  }
}


