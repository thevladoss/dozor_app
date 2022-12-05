import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../algo/butter_counterfeit_classifier.dart';
import '../algo/oil_classifier.dart';
import '../generated/l10n.dart';

part 'detail_event.dart';

part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  late Image _image;
  final imageKey = GlobalKey();
  List<int> _imageDataList = List<int>.empty(growable: false);
  ButterCounterfeitClassifier butterClassifier = ButterCounterfeitClassifier();
  OilClassifier oilClassifier = OilClassifier();
  bool _isButter = true;
  double x = 0.0;
  double y = 0.0;
  Color pickedColor = Colors.black;
  Color resultColor = Colors.black;
  String result = S.current.detailScreenSelectPixel;
  bool pointVisibility = false;


  DetailBloc() : super(DetailButter()) {
    on<DetailEvent>((event, emit) async {
      if (event is DetailSelectPixel) {
        await predictionByPixel(event.position);
        (_isButter) ? emit(DetailButter()) : emit(DetailOil());
      } else if (event is DetailHidePoint) {
        pointVisibility = false;
        (_isButter) ? emit(DetailButter()) : emit(DetailOil());
      } else if (event is DetailSetButterMode) {
        _isButter = true;
        emit(DetailButter());
      } else if (event is DetailSetOilMode) {
        _isButter = false;
        emit(DetailOil());
      }
    });
  }

  Future<void> predictionByPixel(Offset position) async {
    _imageDataList = await captureImage();
    if (_imageDataList.isEmpty) return;

    final w = _image.width;
    final h = _image.height;
    x = position.dx.round().clamp(0, w - 1).toDouble();

    y = position.dy.round().clamp(0, h - 1).toDouble();

    final list = _imageDataList;
    int i = (y * (w * 4) + x * 4).toInt();

    pickedColor = Color.fromARGB(
      list[i + 3],
      list[i],
      list[i + 1],
      list[i + 2],
    );

    result = (_isButter) ? await butterClassifier.predict(
        pickedColor.red, pickedColor.green, pickedColor.blue) : await oilClassifier.predict(
        pickedColor.red, pickedColor.green, pickedColor.blue);


    resultColor = (result == S.current.detailScreenFalsification) ? Colors.red : Colors.green;

    pointVisibility = true;
  }

  Future<List<int>> captureImage() async {
    final ro =
        imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    _image = await ro.toImage();
    final bytes = (await _image.toByteData(format: ImageByteFormat.rawRgba))!;
    return bytes.buffer.asUint8List().toList(growable: false);
  }
}
