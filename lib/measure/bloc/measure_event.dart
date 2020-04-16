import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hotelcovid19_app/models/measure.dart';

abstract class MeasureEvent extends Equatable {
  const MeasureEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends MeasureEvent {}

class Update extends MeasureEvent {
  final Measure measure;

  const Update({
    @required this.measure
  });

  @override
  List<Object> get props => [measure];

  @override
  String toString() => measure.id == null ? 'Update { new measure }': 'Update { measure: $measure.id }';

}
