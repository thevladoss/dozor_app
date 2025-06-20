import 'dart:io';

import 'package:DoZor/utils/app_icons.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../blocs/detail_bloc.dart';
import '../dairy_analyzer.dart';
import '../ui/Painters.dart';
import '../utils/app_colors.dart';

class DetailPage extends StatelessWidget {
  final String imagePath;
  final Dairy dairy;

  DetailPage({required this.imagePath, Key? key, required this.dairy})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(dairy: dairy),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height *
                              ((Platform.isIOS) ? 0.72 : 0.8),
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
                        _buildAppBar(context, ctx)
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

  Container _buildAppBar(BuildContext context, BuildContext ctx) {
    return Container(
      height: 129,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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
          Spacer(),
          Text(
            dairy.subtitle,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          Spacer(),
        ],
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
            // (state.resultPercent != null)
            //     ? Icon(
            //         AppIcons.butter,
            //         color: AppColors.green,
            //         size: 20,
            //       )
            //     : Container(),
            // SizedBox(
            //   width: 8,
            // ),
            Text(
              (state.resultColor == AppColors.green)
                  ? state.dairy.title
                  : (state.resultColor == AppColors.red)
                      ? 'Фальсификат'
                      : 'Плохой пиксель',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: state.resultColor,
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
              (state.resultPercent != null) ? 'Жирность:' : '',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              state.resultPercent ?? '',
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
