import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;

  const DetailScreen({required this.imagePath, Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<int> imageDataList = List<int>.empty(growable: false);
  late Image image;
  final imageKey = GlobalKey();
  final onColorPicked = ValueNotifier<Color>(Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.detailTitle,
          style: GoogleFonts.openSans(
              height: 1.0,
              textStyle:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          RepaintBoundary(
            key: imageKey,
            child: PhotoView(
              onTapDown: (_, event, photo) async {
                imageDataList = await captureImage();
                getPixelColor(event.localPosition);
              },
              minScale: PhotoViewComputedScale.covered,
              backgroundDecoration:
              const BoxDecoration(color: Colors.transparent),
              customSize: MediaQuery.of(context).size,
              imageProvider: FileImage(File(widget.imagePath)),
            ),
          ),
          SlidingUpPanel(
            maxHeight: 280,
            minHeight: 80,
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            padding: const EdgeInsets.all(16.0),
            panel: Column(
              children: <Widget>[
                ValueListenableBuilder<Color>(
                    valueListenable: onColorPicked,
                    builder: (_, color, child) {
                      return Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                            height: 48,
                            width: 48,
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Text(
                            "rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})",
                            style: GoogleFonts.openSans(
                                height: 1.0,
                                textStyle: const TextStyle(fontSize: 22.0)),
                            textAlign: TextAlign.center,
                          )
                        ],
                      );
                    }),
                const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(''),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getPixelColor(Offset position) {
    if (imageDataList.isEmpty) return;
    final w = image.width;
    final h = image.height;
    final x = position.dx.round().clamp(0, w - 1);

    final y = position.dy.round().clamp(0, h - 1);

    final list = imageDataList;
    var i = y * (w * 4) + x * 4;

    onColorPicked.value = Color.fromARGB(
      list[i + 3],
      list[i],
      list[i + 1],
      list[i + 2],
    );
  }

  Future<List<int>> captureImage() async {
    final ro =
        imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    image = await ro.toImage();
    final bytes = (await image.toByteData(format: ImageByteFormat.rawRgba))!;
    return bytes.buffer.asUint8List().toList(growable: false);
  }
}
