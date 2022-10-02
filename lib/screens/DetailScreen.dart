import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../algo/predict.dart';
import '../models/pair.dart';

class DetailScreen extends StatefulWidget {
  final String imagePath;

  const DetailScreen({required this.imagePath, Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<int> imageDataList = List<int>.empty(growable: false);
  bool isLoading = false;
  late Image image;
  final imageKey = GlobalKey();
  final onColorPicked = ValueNotifier<Pair<String, Color>>(
      Pair('Выберите пиксель', Colors.black));
  final ButterClassifier butterClassifier = ButterClassifier();

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
                setState(() {
                  isLoading = true;
                });
                imageDataList = await captureImage();
                await getPixelColor(event.localPosition);
                setState(() {
                  isLoading = false;
                });
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
                ValueListenableBuilder<Pair<String, Color>>(
                    valueListenable: onColorPicked,
                    builder: (_, pair, child) {
                      return Row(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: pair.color,
                            ),
                            height: 48,
                            width: 48,
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "rgb(${pair.color.red}, ${pair.color.green}, ${pair.color.blue})",
                                style: GoogleFonts.openSans(
                                    height: 1.0,
                                    textStyle: const TextStyle(fontSize: 16.0)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                pair.result,
                                style: GoogleFonts.openSans(
                                    height: 1.0,
                                    textStyle: const TextStyle(fontSize: 24.0),
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
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
          (isLoading) ? const LinearProgressIndicator() : Container()
        ],
      ),
    );
  }

  Future<void> getPixelColor(Offset position) async {
    if (imageDataList.isEmpty) return;
    final w = image.width;
    final h = image.height;
    final x = position.dx.round().clamp(0, w - 1);

    final y = position.dy.round().clamp(0, h - 1);

    final list = imageDataList;
    var i = y * (w * 4) + x * 4;

    onColorPicked.value = Pair(
        await butterClassifier.predict(list[i + 3], list[i], list[i + 1]),
        Color.fromARGB(
          list[i + 3],
          list[i],
          list[i + 1],
          list[i + 2],
        ));
  }

  Future<List<int>> captureImage() async {
    final ro =
        imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    image = await ro.toImage();
    final bytes = (await image.toByteData(format: ImageByteFormat.rawRgba))!;
    return bytes.buffer.asUint8List().toList(growable: false);
  }
}
