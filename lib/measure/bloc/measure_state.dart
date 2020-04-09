import 'package:equatable/equatable.dart';
import 'package:hotelcovid19_app/models/measure.dart';

abstract class MeasureState extends Equatable {
  const MeasureState();

  @override
  List<Object> get props => [];
}

class MeasureUninitialized extends MeasureState {}

class MeasureError extends MeasureState {}

class MeasureLoaded extends MeasureState {
  final List<Measure> measures;

  const MeasureLoaded({
    this.measures,
  });

  @override
  List<Object> get props => [measures];

  @override
  String toString() => 'MeasureLoaded { posts: ${measures.length}}';
}
