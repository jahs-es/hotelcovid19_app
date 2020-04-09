import 'package:equatable/equatable.dart';

abstract class MeasureEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Fetch extends MeasureEvent {}
