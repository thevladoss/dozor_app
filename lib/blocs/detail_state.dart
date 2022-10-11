part of 'detail_cubit.dart';

@immutable
abstract class DetailState {}

class DetailInitial extends DetailState {}

class DetailInitiated extends DetailState {
  final double x;
  final double y;
  final Color pickedColor;
  final Color resultColor;
  final String result;

  DetailInitiated({
    required this.x,
    required this.y,
    required this.pickedColor,
    required this.resultColor,
    required this.result,
  });
}
