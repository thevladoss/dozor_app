import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maslo_detector/painters/PointPainter.dart';
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
  late Image image;
  final imageKey = GlobalKey();
  final ButterClassifier butterClassifier = ButterClassifier();
  List<int> _imageDataList = List<int>.empty(growable: false);
  bool _isLoading = false;
  bool _pointVisibility = false;
  double _x = 0.0;
  double _y = 0.0;
  Color _pickedColor = Colors.black;
  Color _resultColor = Colors.black;
  String _result = 'Выберите пиксель';

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
              onTapUp: (_, event, photo) async {
                setState(() {
                  _isLoading = true;
                });
                _imageDataList = await captureImage();
                await getPixelColor(event.localPosition);
                setState(() {
                  _isLoading = false;
                  _pointVisibility = true;
                  _x = event.localPosition.dx;
                  _y = event.localPosition.dy;
                });
              },
              onTapDown: (_, event, photo) {
                setState(() {
                  _pointVisibility = false;
                });
              },
              onScaleEnd: (_, event, photo) {
                setState(() {
                  _pointVisibility = false;
                });
              },
              minScale: PhotoViewComputedScale.covered,
              backgroundDecoration:
                  const BoxDecoration(color: Colors.transparent),
              customSize: MediaQuery.of(context).size,
              imageProvider: FileImage(File(widget.imagePath)),
            ),
          ),
          (_pointVisibility)
              ? CustomPaint(
                  painter: PointPainter(
                      x: _x, y: _y, color: _pickedColor, colorRound: _resultColor),
                )
              : Container(),
          SlidingUpPanel(
            maxHeight: 280,
            minHeight: 80,
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            padding: const EdgeInsets.all(16.0),
            panel: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _resultColor,
                          ),
                          height: 48,
                          width: 48,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _pickedColor,
                          ),
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "rgb(${_pickedColor.red}, ${_pickedColor.green}, ${_pickedColor.blue})",
                          style: GoogleFonts.openSans(
                              height: 1.0,
                              textStyle: const TextStyle(fontSize: 16.0)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          _result,
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
                ),
                const SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(''),
                  ),
                ),
              ],
            ),
          ),
          (_isLoading)
              ? const LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                )
              : Container()
        ],
      ),
    );
  }

  Future<void> getPixelColor(Offset position) async {
    if (_imageDataList.isEmpty) return;
    final w = image.width;
    final h = image.height;
    final x = position.dx.round().clamp(0, w - 1);

    final y = position.dy.round().clamp(0, h - 1);

    final list = _imageDataList;
    var i = y * (w * 4) + x * 4;

    _pickedColor = Color.fromARGB(
      list[i + 3],
      list[i],
      list[i + 1],
      list[i + 2],
    );

    _result = await butterClassifier.predict(
        _pickedColor.red, _pickedColor.green, _pickedColor.blue);

    _resultColor = (_result == 'Фальсификат')
        ? Colors.red
        : Colors.green;
  }

  Future<List<int>> captureImage() async {
    final ro =
        imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    image = await ro.toImage();
    final bytes = (await image.toByteData(format: ImageByteFormat.rawRgba))!;
    return bytes.buffer.asUint8List().toList(growable: false);
  }
}
