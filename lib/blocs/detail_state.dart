// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'detail_bloc.dart';

@immutable
abstract class DetailState {}

class DetailDeafult extends DetailState {}

class DetailResult extends DetailState {
  final Dairy dairy;
  final Color pickedColor;
  final Color resultColor;
  final String? resultPercent;

  DetailResult({
    required this.dairy,
    required this.pickedColor,
    required this.resultColor,
    this.resultPercent,
  });
}
