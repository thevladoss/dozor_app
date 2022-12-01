import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

import '../blocs/detail_bloc.dart';
import '../generated/l10n.dart';
import '../ui/Painters.dart';

class DetailScreen extends StatelessWidget {
  final String imagePath;

  const DetailScreen({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(),
      child: BlocBuilder<DetailBloc, DetailState>(
        builder: (ctx, state) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  S.current.detailTitle,
                  style: GoogleFonts.openSans(
                      height: 1.0,
                      textStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  RepaintBoundary(
                    key: ctx.read<DetailBloc>().imageKey,
                    child: PhotoView(
                      onTapUp: (_, event, photo) => ctx.read<DetailBloc>().add(
                          DetailSelectPixel(position: event.localPosition)),
                      onTapDown: (_, event, photo) =>
                          ctx.read<DetailBloc>().add(DetailHidePoint()),
                      onScaleEnd: (_, event, photo) =>
                          ctx.read<DetailBloc>().add(DetailHidePoint()),
                      minScale: PhotoViewComputedScale.covered,
                      backgroundDecoration:
                          const BoxDecoration(color: Colors.transparent),
                      customSize: MediaQuery.of(context).size,
                      imageProvider: FileImage(File(imagePath)),
                    ),
                  ),
                  (ctx.read<DetailBloc>().pointVisibility)
                      ? CustomPaint(
                          painter: PointPainter(
                              x: ctx.read<DetailBloc>().x,
                              y: ctx.read<DetailBloc>().y,
                              color: ctx.read<DetailBloc>().pickedColor,
                              colorRound: ctx.read<DetailBloc>().resultColor),
                        )
                      : Container(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ctx.read<DetailBloc>().resultColor,
                                ),
                                height: 48,
                                width: 48,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ctx.read<DetailBloc>().pickedColor,
                                ),
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 16.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'rgb(${ctx.read<DetailBloc>().pickedColor.red}, ${ctx.read<DetailBloc>().pickedColor.green}, ${ctx.read<DetailBloc>().pickedColor.blue})',
                                  style: GoogleFonts.openSans(
                                      height: 1.0,
                                      textStyle: const TextStyle(fontSize: 16.0)),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 2.0,
                                ),
                                Text(
                                  ctx.read<DetailBloc>().result,
                                  style: GoogleFonts.openSans(
                                      height: 1.0,
                                      textStyle: const TextStyle(fontSize: 24.0),
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SpeedDial(
                      overlayOpacity: 0.3,
                      overlayColor: Colors.black,
                      activeIcon: Icons.arrow_drop_down,
                      icon: Icons.arrow_drop_up,
                      iconTheme: const IconThemeData(size: 40),
                      foregroundColor: Colors.white,
                      children: [
                        SpeedDialChild(
                            child: const ImageIcon(
                              AssetImage('img/FakeButterDetectionIcon.png'),
                              size: 35,
                            ),
                            backgroundColor: Colors.lightGreen,
                            foregroundColor: Colors.white,
                            label: S.current.butterText,
                            labelStyle: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600),
                            onTap: () => ctx
                                .read<DetailBloc>()
                                .add(DetailSetButterMode())),
                        SpeedDialChild(
                            child: const ImageIcon(
                              AssetImage('img/VegOilRegressionIcon.png'),
                              size: 80,
                            ),
                            backgroundColor: Colors.lightGreen,
                            foregroundColor: Colors.white,
                            label: S.current.oilText,
                            labelStyle: GoogleFonts.openSans(
                                fontWeight: FontWeight.w600),
                            onTap: () =>
                                ctx.read<DetailBloc>().add(DetailSetOilMode())),
                      ]),
                  const SizedBox(
                    height: 80,
                  )
                ],
              ));
        },
      ),
    );
  }
}
