# images_editor

Images Editor allow you to edit multiple image on same frame


## Getting started

- Add the latest version of package to your pubspec.yaml (and run`dart pub get`):
```yaml
dependencies:
  images_editor: ^0.0.1
```

- Add UCropActivity into your AndroidManifest.xml
````xml
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
````

- Add `image_picker` as a dependency in your pubspec.yaml file and follow
  [setup instructions](https://pub.dev/packages/image_picker) or use any other package to pick images.


## Example

Examples to `/example` [folder](https://github.com/Kora3/flutter_images_editor/example).

```dart
import 'package:image_picker/image_picker.dart';
import 'package:images_editor/images_editor.dart';

Future<List<File>> pickMultiple() async {
  List<File> files = [];
  final pickedImage = await ImagePicker().pickMultiImage(imageQuality: 50);
  for (var file in pickedImage) {
    files.add(File(file.path));
    if (imageFiles.isNotEmpty) {

    }
  }
  return files;
}

void main() async {
  List<Uint8List> images = [];

  await pickMultiple().then((files) {
    if (files.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ImagesEditor(
          files: files,
          onFinish: (images) {
            Navigator.pop(context);
            setState(() {
              this.images = images;
            });
          },
        );
      }));
    }
  });
}
```


## Demo

[//]: # (|                                                                              Android                                                                              |                                                                               IOS                                                                                |)

[//]: # (|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------------------------------------------:|)

[//]: # (| <img src="https://github.com/CodingWithTashi/simple_barcode_scanner/blob/main/example/demo/scanner_android.gif?raw=true" alt="drawing" width="350" height="650"/> | <img src="https://github.com/CodingWithTashi/simple_barcode_scanner/blob/main/example/demo/barcode_mobile.gif?raw=true" width="400" height="600" alt="drawing"/> |)


## Documentation

| Property              | Description                                                                                                      |
|-----------------------|------------------------------------------------------------------------------------------------------------------|
| `files`               | List of File object representing picked images files.                                                            |
| `onFinish`            | Callback function that is invoked when editing is finished and returns the edited images as List of `Uint8List`. |
| `customText`          | Use to customize alerts and widgets text.                                                                        |
| `customColor`         | Use to customize widgets theme.                                                                                  |
| `customWidget`        | Use to customize widgets.                                                                                        |
| `textInputDecoration` | Use for input textField decoration.                                                                              |
| `imageHeight`         | Preview image height.                                                                                            |
| `imageWidth`          | Preview image width                                                                                              |


<br/>

## Contributing

I welcome contributions from the open-source community to make this project even better.
Whether you want to report a bug, suggest a new feature, or contribute code, I appreciate your help.

### Bug Reports and Feature Requests

If you encounter a bug or have an idea for a new feature, please open an issue on my
[GitHub Issues](https://github.com/Kora3/flutter_images_editor/issues) page. I will review it and
discuss the best approach to address it.

### Code Contributions

If you'd like to contribute code to this project, please follow these steps:

1. Fork the repository to your GitHub account.
2. Clone your forked repository to your local machine.

```bash
git clone https://github.com/Kora3/flutter_images_editor.git
```

<br/>

## Included Packages

This package uses several Flutter packages to provide a seamless editing experience.
Here's a list of the packages used in this project:

- [image](https://pub.dev/packages/image)
- [photofilters](https://pub.dev/packages/photofilters)
- [screenshot](https://pub.dev/packages/screenshot)
- [image_cropper](https://pub.dev/packages/image_cropper)

These packages play a crucial role in enabling various features and functionalities in this package.
