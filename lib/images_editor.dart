import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:images_editor/filter_image_widgets/filter_image.dart';
import 'package:images_editor/utils/colors.dart';
import 'package:images_editor/utils/setting_values.dart';
import 'package:images_editor/widgets/my_modal.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as img;
import 'widgets/crop_image.dart';
import 'edit_images/image_text.dart';
import 'edit_images/text_info.dart';
import 'filter_image_widgets/filters_utils.dart';
import 'widgets/custom_text.dart';
import 'widgets/loader.dart';
import 'widgets/my_text_input_field.dart';

class ImagesEditor extends StatefulWidget {
  final List<File> files;
  final void Function(List<Uint8List>) onFinish;
  final CustomText? customText;
  final CustomColor? customColor;
  final CustomWidget? customWidget;
  final InputDecoration? textInputDecoration;
  final double? imageHeight;
  final double? imageWidth;
  const ImagesEditor({super.key, required this.files, required this.onFinish, this.customText,
    this.customColor, this.customWidget, this.textInputDecoration, this.imageHeight, this.imageWidth,});

  @override
  State<ImagesEditor> createState() => _ImagesEditorState();
}

class _ImagesEditorState extends State<ImagesEditor> {

  late List<File> files;
  late List<img.Image> images;
  late List<Uint8List> uint8lists;
  int index = 0;

  ScreenshotController screenshotController = ScreenshotController();
  final TextEditingController textEditingController = TextEditingController();
  late List<List<TextInfo>> texts;
  int currentTextIndex = 0;

  late CustomText customTextC;
  late CustomColor customColor;
  late CustomWidget customWidget;

  @override
  void initState() {
    // TODO: implement initState
    customTextC = widget.customText ?? CustomText();
    customColor = widget.customColor ?? CustomColor();
    customWidget = widget.customWidget ?? CustomWidget();

    files = widget.files.toList();
    images = files.map((e) => img.decodeImage(e.readAsBytesSync())!).toList() ;
    uint8lists = files.map((e) => e.readAsBytesSync()).toList();
    texts = uint8lists.map((e) => <TextInfo>[]).toList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: customColor.backgroundColor ?? backgroundColor,
      appBar: _appBar,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: showItem(uint8lists[index], texts[index]),
            ),
            const SizedBox(height: 50,),

            SizedBox(
              height: widget.imageHeight ?? MediaQuery.of(context).size.width / 2.5,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: uint8lists.map((e) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                index = uint8lists.indexWhere((element) => element == e);
                              });
                            },
                            child: Image.memory(
                              e,
                              fit: BoxFit.cover,
                              height: widget.imageHeight ?? MediaQuery.of(context).size.width / 2.5,
                              width: widget.imageWidth ?? MediaQuery.of(context).size.width / 3,
                            ),
                          ),
                        ),

                        if (uint8lists.length > 1)
                          GestureDetector(
                            onTap: () {
                              int index = uint8lists.indexWhere((element) => element == e);
                              setState(() {
                                this.index = 0;
                                files.removeAt(index);
                                images.removeAt(index);
                                uint8lists.removeAt(index);
                                texts.removeAt(index);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                child: Icon(Icons.close, size: 15, color: whiteColor,),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
      floatingActionButton: _addnewTextFab,
    );
  }

  void onFinish() async {
    loadingIn(context, loaderIn: customWidget.circularIndicator);
    await getPhotos().then((photos) {
      Navigator.pop(context);
      widget.onFinish(photos);
    });
  }

  Future<List<Uint8List>> getPhotos() async {
    List<Uint8List> photos = [];
    for (int i = 0; i < uint8lists.length; i++) {
      setState(() {
        index = i;
      });
      await screenshotController.capture().then((value) {
        if (value != null) {
          photos.add(value);
        }
      });
    }
    return photos;
  }

  Widget showItem(Uint8List uint8list, List<TextInfo> textInfos) {
    return Stack(
      children: [
        Center(
          child: Image.memory(
            uint8list,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),

        for (int i = 0; i < textInfos.length; i++)
          Positioned(
            left: textInfos[i].left,
            top: textInfos[i].top,
            child: GestureDetector(
              onLongPress: () {
                setState(() {
                  currentTextIndex = i;
                  removeText(context);
                });
              },
              onTap: () => setCurrentIndex(context, i),
              child: Draggable(
                feedback: ImageText(textInfo: textInfos[i]),
                child: ImageText(textInfo: textInfos[i]),
                onDragEnd: (drag) {
                  final renderBox = context.findRenderObject() as RenderBox;
                  Offset off = renderBox.globalToLocal(drag.offset);
                  setState(() {
                    textInfos[i].top = off.dy - 96;
                    textInfos[i].left = off.dx;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget get _addnewTextFab => FloatingActionButton(
    onPressed: () => addNewDialog(context),
    backgroundColor: customColor.modalBackgroundColor ?? secondaryGreyColor,
    tooltip: 'Add text',
    child: Icon(Icons.edit, color: customColor.primaryColor ?? whiteColor),
  );

  AppBar get _appBar => AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: customColor.backgroundColor ?? backgroundColor,
    foregroundColor: customColor.primaryColor ?? whiteColor,
    actions: [
      Center(
        child: TextButton(
          onPressed: () {
            onFinish();
          },
          child: customText(customTextC.nextText ?? "Next", fontSize: 15.0, color: blueColor,)
        ),
      ),
    ],
    title: SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          IconButton(
            icon: Icon(Icons.auto_fix_high, color: customColor.primaryColor ?? whiteColor),
            onPressed: () {
              myModal(
                context: context,
                factor: null,
                modalBackgroundColor: customColor.modalBackgroundColor ?? secondaryGreyColor,
                child: FilterImage(
                  image: images[index],
                  customColor: customColor,
                  customWidget: customWidget,
                  onChoose: (onChange) {
                    setState(() {
                      uint8lists[index] = onChange;
                      images[index] = img.decodeImage(uint8lists[index])!;
                    });
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.crop, color: customColor.primaryColor ?? whiteColor),
            onPressed: () async {
              await cropImage(files[index]).then((imageCrop) {
                if (imageCrop != null) {
                  FilterUtils.clearCache();
                  setState(() {
                    files[index] = imageCrop;
                  });
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return ImagesEditor(files: files, onFinish: widget.onFinish, customText: widget.customText,
                      customColor: widget.customColor, customWidget: widget.customWidget, textInputDecoration: widget.textInputDecoration,); }));
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.rotate_left, color: customColor.primaryColor ?? whiteColor),
            onPressed: rotateLeft,
            tooltip: 'Rotation à gauche',
          ),
          IconButton(
            icon: Icon(Icons.rotate_right, color: customColor.primaryColor ?? whiteColor),
            onPressed: rotateRight,
            tooltip: 'Rotation à droite',
          ),
          IconButton(
            icon: Icon(Icons.add, color: customColor.primaryColor ?? whiteColor),
            onPressed: increaseFontSize,
            tooltip: 'Augmenter la taille du texte',
          ),
          IconButton(
            icon: Icon(Icons.remove, color: customColor.primaryColor ?? whiteColor),
            onPressed: decreaseFontSize,
            tooltip: 'Diminuer la taille du texte',
          ),
          IconButton(
            icon: Icon(Icons.format_align_left, color: customColor.primaryColor ?? whiteColor),
            onPressed: alignLeft,
            tooltip: 'Aligner à gauche',
          ),
          IconButton(
            icon: Icon(Icons.format_align_center, color: customColor.primaryColor ?? whiteColor),
            onPressed: alignCenter,
            tooltip: 'Centré',
          ),
          IconButton(
            icon: Icon(Icons.format_align_right, color: customColor.primaryColor ?? whiteColor),
            onPressed: alignRight,
            tooltip: 'Aligner à droite',
          ),
          IconButton(
            icon: Icon(Icons.format_bold, color: customColor.primaryColor ?? whiteColor),
            onPressed: boldText,
            tooltip: 'Gras',
          ),
          IconButton(
            icon: Icon(Icons.format_italic, color: customColor.primaryColor ?? whiteColor),
            onPressed: italicText,
            tooltip: 'Italique',
          ),
          IconButton(
            icon: Icon(Icons.space_bar, color: customColor.primaryColor ?? whiteColor),
            onPressed: addLinesToText,
            tooltip: 'Ajouter une ligne',
          ),
          Tooltip(
            message: 'Rouge',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.red),
              child: const CircleAvatar(backgroundColor: Colors.red,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Blanc',
            child: GestureDetector(
              onTap: () => changeTextColor(whiteColor,),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: backgroundColor),
                  shape: BoxShape.circle
                ),
                child: CircleAvatar(backgroundColor: whiteColor, radius: 18,)
              ),
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Noir',
            child: GestureDetector(
              onTap: () => changeTextColor(backgroundColor,),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: whiteColor),
                  shape: BoxShape.circle
                ),
                child: CircleAvatar(backgroundColor: backgroundColor),
              ),
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Bleue',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.blue),
              child: const CircleAvatar(backgroundColor: Colors.blue,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Jaune',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.yellow),
              child: const CircleAvatar(backgroundColor: Colors.yellow,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Vert',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.green),
              child: const CircleAvatar(backgroundColor: Colors.green,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Orange',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.orange),
              child: const CircleAvatar(backgroundColor: Colors.orange,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Ambre',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.amber),
              child: const CircleAvatar(backgroundColor: Colors.amber,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Rose',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.pink),
              child: const CircleAvatar(backgroundColor: Colors.pink,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Violet',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.purple),
              child: const CircleAvatar(backgroundColor: Colors.purple,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Gris',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.grey),
              child: const CircleAvatar(backgroundColor: Colors.grey,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Indigo',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.indigo),
              child: const CircleAvatar(backgroundColor: Colors.indigo,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Brun',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.brown),
              child: const CircleAvatar(backgroundColor: Colors.brown,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Cyan',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.cyan),
              child: const CircleAvatar(backgroundColor: Colors.cyan,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Lime',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.lime),
              child: const CircleAvatar(backgroundColor: Colors.lime,)
            ),
          ),
          const SizedBox(width: 5,),
          Tooltip(
            message: 'Teal',
            child: GestureDetector(
              onTap: () => changeTextColor(Colors.teal),
              child: const CircleAvatar(backgroundColor: Colors.teal,)
            ),
          ),
          const SizedBox(width: 5,),
        ],
      ),
    ),
  );

  void removeText(BuildContext context) {
    setState(() {
      texts[index].removeAt(currentTextIndex);
    });
    showSnackBarMessage(context, customTextC.onDeleteText ?? "Text deleted", customColor);
  }

  void setCurrentIndex(BuildContext context, index) {
    setState(() {
      currentTextIndex = index;
    });
    showSnackBarMessage(context, customTextC.onSelectText ?? "Text selected", customColor);
  }

  void changeTextColor(Color color) {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].color = color;
      });
    }
  }

  void increaseFontSize() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].fontSize += 2;
      });
    }
  }

  void decreaseFontSize() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].fontSize -= 2;
      });
    }
  }

  void alignLeft() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].textAlign = TextAlign.left;
      });
    }
  }

  void alignCenter() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].textAlign = TextAlign.center;
      });
    }
  }

  void alignRight() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].textAlign = TextAlign.right;
      });
    }
  }

  void boldText() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        if (texts[index][currentTextIndex].fontWeight == FontWeight.bold) {
          texts[index][currentTextIndex].fontWeight = FontWeight.normal;
        } else {
          texts[index][currentTextIndex].fontWeight = FontWeight.bold;
        }
      });
    }
  }

  void italicText() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        if (texts[index][currentTextIndex].fontStyle == FontStyle.italic) {
          texts[index][currentTextIndex].fontStyle = FontStyle.normal;
        } else {
          texts[index][currentTextIndex].fontStyle = FontStyle.italic;
        }
      });
    }
  }

  void addLinesToText() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        if (texts[index][currentTextIndex].text.contains('\n')) {
          texts[index][currentTextIndex].text = texts[index][currentTextIndex].text.replaceAll('\n', ' ');
        } else {
          texts[index][currentTextIndex].text = texts[index][currentTextIndex].text.replaceAll(' ', '\n');
        }
      });
    }
  }

  void rotateLeft() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].position -= 10;
      });
    }
  }

  void rotateRight() {
    if (texts.isNotEmpty && texts[index].isNotEmpty) {
      setState(() {
        texts[index][currentTextIndex].position += 10;
      });
    }
  }

  void addNewText(BuildContext context) {
    setState(() {
      texts[index].add(
        TextInfo(
          text: textEditingController.text,
          left: 0,
          top: 0,
          color: Colors.black,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.normal,
          fontSize: 20,
          textAlign: TextAlign.left,
          position: 0,
        ),
      );
      Navigator.pop(context);
    });
  }

  Future<void> addNewDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: customColor.modalBackgroundColor ?? secondaryGreyColor,
        title: customText(customTextC.alertDialogTitle ?? 'Add text', color: customColor.primaryColor ?? whiteColor, fontSize: 15.0),
        content: MyTextInputField(
          hintText: 'Text',
          controller: textEditingController,
          customColor: customColor,
          decoration: widget.textInputDecoration,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: customText(customTextC.alertDialogCancel ?? "Cancel", color: customColor.primaryColor ?? whiteColor, fontSize: 15.0)
          ),
          TextButton(
            onPressed: () {
              addNewText(context);
              setState(() {
                textEditingController.text = '';
              });
            },
            child: customText(customTextC.alertDialogAdd ?? "Add", fontSize: 15.0, color: blueColor,),
          ),
        ],
      ),
    );
  }
}