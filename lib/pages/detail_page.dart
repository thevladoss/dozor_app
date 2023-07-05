import 'dart:io';

import 'package:DoZor/utils/app_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../blocs/detail_bloc.dart';
import '../ui/Painters.dart';
import '../utils/app_colors.dart';

class DetailPage extends StatelessWidget {
  final String imagePath;

  DetailPage({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(),
      child: BlocBuilder<DetailBloc, DetailState>(
        builder: (ctx, state) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 0.75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Transform.scale(
                              scale: 1,
                              child: RepaintBoundary(
                                key: ctx.read<DetailBloc>().imageKey,
                                child: PhotoView(
                                  onTapUp: (_, event, photo) => ctx
                                      .read<DetailBloc>()
                                      .add(DetailSelectPixel(
                                          position: event.localPosition)),
                                  onTapDown: (_, event, photo) => ctx
                                      .read<DetailBloc>()
                                      .add(DetailHidePoint()),
                                  onScaleEnd: (_, event, photo) => ctx
                                      .read<DetailBloc>()
                                      .add(DetailHidePoint()),
                                  minScale: PhotoViewComputedScale.covered,
                                  backgroundDecoration: const BoxDecoration(
                                      color: Colors.transparent),
                                  imageProvider: FileImage(File(imagePath)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (state is DetailResult)
                            ? CustomPaint(
                                painter: PointPainter(
                                    x: ctx.read<DetailBloc>().x,
                                    y: ctx.read<DetailBloc>().y,
                                    color: state.pickedColor,
                                    colorRound: state.resultColor),
                              )
                            : Container(),
                        Positioned.fill(
                          child: IgnorePointer(
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              strokeWidth: 4,
                              color: Colors.white,
                              borderPadding: EdgeInsets.all(2),
                              strokeCap: StrokeCap.round,
                              dashPattern: [25, 15],
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 129,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CupertinoButton(
                                    child: Icon(
                                      AppIcons.back,
                                      size: 16,
                                      color: AppColors.primary,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              Text(
                                "Выберите область для анализа",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Результат',
                              style: TextStyle(
                                fontSize: 22,
                                color: AppColors.primary,
                              ),
                            ),
                            Expanded(
                              child: (state is DetailResult)
                                  ? _buildResult(state)
                                  : _buildDefaultResult(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column _buildResult(DetailResult state) {
    return Column(
      children: [
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.butter,
              color: AppColors.green,
              size: 20,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              state.dairy.val,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: AppColors.green,
              ),
            )
          ],
        ),
        Spacer(),
        Row(
          children: [
            SizedBox(
              width: 16,
            ),
            Text(
              'Жирность:',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              state.resultPercent,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.green,
              ),
            ),
            Spacer(),
            Text(
              'RGB: (${state.pickedColor.red}, ${state.pickedColor.green}, ${state.pickedColor.blue})',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        Spacer()
      ],
    );
  }

  Column _buildDefaultResult() {
    return Column(
      children: [
        Spacer(),
        Text(
          'Для отображения результата сначала выберите область анализа',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
        Spacer()
      ],
    );
  }
}

// class DetailPage extends StatelessWidget {
//   final String imagePath;

//   DetailPage({required this.imagePath, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => DetailBloc(),
//       child: BlocBuilder<DetailBloc, DetailState>(
//         builder: (ctx, state) {
//           return Scaffold(
//             appBar: AppBar(
//               centerTitle: true,
//               backgroundColor: AppColors.primary,
//               title: Text(
//                 S.current.detailTitle,
//                 style: TextStyle(
//                   fontSize: 20.0,
//                   fontFamily: AppFonts.openSans,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             body: Stack(
//               children: <Widget>[
//                 RepaintBoundary(
//                   key: ctx.read<DetailBloc>().imageKey,
//                   child: PhotoView(
//                     onTapUp: (_, event, photo) => ctx
//                         .read<DetailBloc>()
//                         .add(DetailSelectPixel(position: event.localPosition)),
//                     onTapDown: (_, event, photo) =>
//                         ctx.read<DetailBloc>().add(DetailHidePoint()),
//                     onScaleEnd: (_, event, photo) =>
//                         ctx.read<DetailBloc>().add(DetailHidePoint()),
//                     minScale: PhotoViewComputedScale.covered,
//                     backgroundDecoration:
//                         const BoxDecoration(color: Colors.transparent),
//                     customSize: MediaQuery.of(context).size,
//                     imageProvider: FileImage(File(imagePath)),
//                   ),
//                 ),
//                 (ctx.read<DetailBloc>().pointVisibility)
//                     ? CustomPaint(
//                         painter: PointPainter(
//                             x: ctx.read<DetailBloc>().x,
//                             y: ctx.read<DetailBloc>().y,
//                             color: ctx.read<DetailBloc>().pickedColor,
//                             colorRound: ctx.read<DetailBloc>().resultColor),
//                       )
//                     : Container(),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     height: 80,
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(20)),
//                     ),
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       children: <Widget>[
//                         Stack(
//                           alignment: Alignment.center,
//                           children: <Widget>[
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: ctx.read<DetailBloc>().resultColor,
//                               ),
//                               height: 48,
//                               width: 48,
//                             ),
//                             Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: ctx.read<DetailBloc>().pickedColor,
//                               ),
//                               height: 40,
//                               width: 40,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           width: 16.0,
//                         ),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 'rgb(${ctx.read<DetailBloc>().pickedColor.red}, ${ctx.read<DetailBloc>().pickedColor.green}, ${ctx.read<DetailBloc>().pickedColor.blue})',
//                                 style: TextStyle(
//                                     fontSize: 16.0,
//                                     fontFamily: AppFonts.openSans),
//                                 textAlign: TextAlign.center,
//                               ),
//                               const SizedBox(
//                                 height: 1.0,
//                               ),
//                               Text(
//                                 ctx.read<DetailBloc>().result,
//                                 style: TextStyle(
//                                     fontSize: 24.0,
//                                     fontFamily: AppFonts.openSans,
//                                     fontWeight: FontWeight.w600),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                               ),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             floatingActionButton: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 SpeedDial(
//                   overlayOpacity: 0.3,
//                   overlayColor: Colors.black,
//                   activeIcon: Icons.arrow_drop_down,
//                   icon: Icons.arrow_drop_up,
//                   iconTheme: const IconThemeData(size: 40),
//                   backgroundColor: AppColors.primary,
//                   foregroundColor: Colors.white,
//                   children: [
//                     SpeedDialChild(
//                       child: Icon(AppIcons.butter),
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       label: S.current.butterText,
//                       labelStyle: TextStyle(
//                           fontFamily: AppFonts.openSans,
//                           fontWeight: FontWeight.w600),
//                       onTap: () =>
//                           ctx.read<DetailBloc>().add(DetailSetButterMode()),
//                     ),
//                     SpeedDialChild(
//                       child: const Icon(AppIcons.milk),
//                       backgroundColor: AppColors.primary,
//                       foregroundColor: Colors.white,
//                       label: S.current.oilText,
//                       labelStyle: TextStyle(
//                           fontFamily: AppFonts.openSans,
//                           fontWeight: FontWeight.w600),
//                       onTap: () =>
//                           ctx.read<DetailBloc>().add(DetailSetOilMode()),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 80,
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
