import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_editor/images_editor.dart';
import 'package:images_editor/utils/setting_values.dart';

import 'show_images.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<Uint8List> images = [];

  Future<List<File>> pickMultiple() async {
    List<File> files = [];
    final pickedImage = await ImagePicker().pickMultiImage(imageQuality: 50);
    for (var file in pickedImage) {
      files.add(File(file.path));
    }
    return files;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Images Editor",
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Images Editor', style: TextStyle(fontSize: 25.0, color: Colors.white),),
          actions: [
            if (images.isNotEmpty)...[
              IconButton(
                onPressed: () {
                  setState(() {
                    images = [];
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ],
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              if (images.isNotEmpty) {
                return ShowImages(
                  images: images,
                  onDelete: (index) {
                    setState(() {
                      images.removeAt(index);
                    });
                  },
                );
              } else {
                return ElevatedButton(
                  onPressed: () async {
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
                            customText: CustomText(),
                            customColor: CustomColor(),
                            customWidget: CustomWidget(),
                          );
                        }));
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Select images to edit', style: TextStyle(fontSize: 15.0, color: Colors.white)),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}