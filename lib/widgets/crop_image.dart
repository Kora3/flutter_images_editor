import 'dart:io';
import 'package:image_cropper/image_cropper.dart';

Future<File?> cropImage(File cropImage) async {
  final file = await ImageCropper().cropImage(
    sourcePath: cropImage.path,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    aspectRatioPresets: [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
    ],
    compressQuality: 80,
    compressFormat: ImageCompressFormat.jpg,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: "",
        hideBottomControls: false,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false
      ),
      IOSUiSettings(
        rotateClockwiseButtonHidden: false,
        rotateButtonsHidden: false,
      ),
    ],
  );
  if (file != null) {
    return File(file.path);
  } else {
    return null;
  }
}