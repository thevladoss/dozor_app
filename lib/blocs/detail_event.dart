part of 'detail_bloc.dart';

@immutable
abstract class DetailEvent {}

class DetailSelectPixel extends DetailEvent {
  final Offset position;

  DetailSelectPixel({
    required this.position,
  });
}

class DetailHidePoint extends DetailEvent {}

class DetailSetButterMode extends DetailEvent {}

class DetailSetOilMode extends DetailEvent {}