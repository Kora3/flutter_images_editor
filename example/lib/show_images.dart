import 'dart:typed_data';
import 'package:flutter/material.dart';

class ShowImages extends StatefulWidget {
  final List<Uint8List> images;
  final Function(int index) onDelete;
  const ShowImages({super.key, required this.images, required this.onDelete});

  @override
  State<ShowImages> createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {

  OverlayEntry? entry;
  final double minScale = 1;
  final double maxScale = 4;
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        final uint8list = widget.images[index];
        return SizedBox(
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.height / 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.0),
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    showOverlay(uint8list);
                  },
                  child: Image.memory(
                    uint8list,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      widget.onDelete(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Icon(Icons.close, size: 15, color: Colors.white,),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void removeOverlay() {
    entry?.remove();
    entry = null;
  }

  void showOverlay(Uint8List uint8list) {
    entry = OverlayEntry(
      builder: (context) {
        final opacity = ((scale - 1) / (maxScale -1)).clamp(minScale, maxScale);
        return SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13.0),
                      child: Image.memory(uint8list, fit: BoxFit.cover,),
                    ),
                    const SizedBox(height: 10,),
                    TextButton(
                      onPressed: () {
                        removeOverlay();
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );

    final overlay = Overlay.of(context);
    overlay.insert(entry!);
  }
}
