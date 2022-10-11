import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';

import '../algo/predict.dart';

part 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final ButterClassifier butterClassifier = ButterClassifier();
  late Image _image;
  final imageKey = GlobalKey();
  List<int> _imageDataList = List<int>.empty(growable: false);

  bool _pointVisibility = false;
  get pointVisibility => _pointVisibility;

  DetailCubit() : super(DetailInitial());

  Future<void> predictionByPixel(Offset position) async {
    _imageDataList = await captureImage();
    if (_imageDataList.isEmpty) return;

    final w = _image.width;
    final h = _image.height;
    final x = position.dx.round().clamp(0, w - 1);

    final y = position.dy.round().clamp(0, h - 1);

    final list = _imageDataList;
    int i = y * (w * 4) + x * 4;

    Color pickedColor = Color.fromARGB(
      list[i + 3],
      list[i],
      list[i + 1],
      list[i + 2],
    );

    String result = await butterClassifier.predict(
        pickedColor.red, pickedColor.green, pickedColor.blue);

    _pointVisibility = true;

    emit(DetailInitiated(
        x: x.toDouble(),
        y: y.toDouble(),
        pickedColor: pickedColor,
        resultColor: (result == 'Фальсификат') ? Colors.red : Colors.green,
        result: result));
  }

  Future<List<int>> captureImage() async {
    final ro =
        imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    _image = await ro.toImage();
    final bytes = (await _image.toByteData(format: ImageByteFormat.rawRgba))!;

    return bytes.buffer.asUint8List().toList(growable: false);
  }

  changeVisibilityOfPoint(DetailState state) {
    _pointVisibility = false;

    if (state is DetailInitiated) {
      emit(DetailInitiated(
          x: state.x,
          y: state.y,
          pickedColor: state.pickedColor,
          resultColor: state.resultColor,
          result: state.result));
    }
  }
}
