import 'dart:async';
import 'dart:ui';

import 'package:DoZor/dairy_analyzer.dart';
import 'package:DoZor/utils/app_colors.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final Dairy dairy;
  late Image _image;
  final imageKey = GlobalKey();
  List<int> _imageDataList = List<int>.empty(growable: false);
  double x = 0.0;
  double y = 0.0;
  bool pointVisibility = false;

  DetailBloc({required this.dairy}) : super(DetailDeafult()) {
    on<DetailEvent>((event, emit) async {
      if (event is DetailSelectPixel) {
        emit(await predictionByPixel(event.position));
      } else if (event is DetailHidePoint) {
        pointVisibility = false;
      }
      //  else if (event is DetailSetDairyMode) {
      //   emit(DetailDeafult());
      // }
    });
  }

  Future<DetailState> predictionByPixel(Offset position) async {
    _imageDataList = await captureImage();
    if (_imageDataList.isEmpty) return DetailDeafult();
    final w = _image.width;
    final h = _image.height;
    x = position.dx.round().clamp(0, w - 1).toDouble();

    y = position.dy.round().clamp(0, h - 1).toDouble();

    final list = _imageDataList;
    int i = (y * (w * 4) + x * 4).toInt();

    Color pickedColor = Color.fromARGB(
      list[i + 3],
      list[i],
      list[i + 1],
      list[i + 2],
    );

    pointVisibility = true;

    DairyAnalyzer analyzer = DairyAnalyzer.fromDairy(
        dairy: dairy,
        r: pickedColor.red.toDouble(),
        g: pickedColor.green.toDouble());

    return DetailResult(
        dairy: dairy,
        pickedColor: pickedColor,
        resultColor: (analyzer.dairyType == DairyType.real)
            ? AppColors.green
            : (analyzer.dairyType == DairyType.fake)
                ? AppColors.red
                : AppColors.accent,
        resultPercent: (analyzer.dairyType == DairyType.real)
            ? analyzer.resultPercent
            : null);
  }

  Future<List<int>> captureImage() async {
    final ro =
        imageKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    _image = await ro.toImage();
    final bytes = (await _image.toByteData(format: ImageByteFormat.rawRgba))!;
    return bytes.buffer.asUint8List().toList(growable: false);
  }
}
