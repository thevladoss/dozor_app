import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart' hide Image;
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maslo_detector/blocs/detail_cubit.dart';
import 'package:maslo_detector/painters/PointPainter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../algo/predict.dart';
import '../models/pair.dart';

class DetailScreen extends StatelessWidget {
  final String imagePath;

  DetailScreen({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailCubit(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.detailTitle,
            style: GoogleFonts.openSans(
                height: 1.0,
                textStyle: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.w600)),
          ),
        ),
        body: BlocBuilder<DetailCubit, DetailState>(
          builder: (ctx, state) {
            return Stack(
              children: <Widget>[
                RepaintBoundary(
                  key: ctx.read<DetailCubit>().imageKey,
                  child: PhotoView(
                    onTapUp: (_, event, photo) => ctx.read<DetailCubit>().getPixelColor(event.localPosition),
                    onTapDown: (_, event, photo) {
                    },
                    onScaleEnd: (_, event, photo) {
                    },
                    minScale: PhotoViewComputedScale.covered,
                    backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
                    customSize: MediaQuery
                        .of(context)
                        .size,
                    imageProvider: FileImage(File(imagePath)),
                  ),
                ),
                (state is DetailInitiated)
                    ? CustomPaint(
                  painter: PointPainter(
                      x: state.x,
                      y: state.y,
                      color: state.pickedColor,
                      colorRound: state.resultColor),
                )
                    : Container(),
                SlidingUpPanel(
                  maxHeight: 280,
                  minHeight: 80,
                  color: Colors.white,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
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
                                  color: (state is DetailInitiated) ? state.resultColor : Colors.black,
                                ),
                                height: 48,
                                width: 48,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (state is DetailInitiated) ? state.pickedColor : Colors.black,
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
                                (state is DetailInitiated) ? 'rgb(${state.pickedColor.red}, ${state.pickedColor
                                    .green}, ${state.pickedColor.blue})' : 'rgb(0, 0, 0)',
                                style: GoogleFonts.openSans(
                                    height: 1.0,
                                    textStyle: const TextStyle(fontSize: 16.0)),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 2.0,
                              ),
                              Text(
                                (state is DetailInitiated) ? state.result : 'Выберите пиксель',
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
              ],
            );
          },
        ),
      ),
    );
  }
}
