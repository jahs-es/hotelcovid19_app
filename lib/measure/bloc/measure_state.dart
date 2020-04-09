import 'package:equatable/equatable.dart';
import 'package:hotelcovid19_app/measure/models/measure.dart';

abstract class MeasureState extends Equatable {
  const MeasureState();

  @override
  List<Object> get props => [];
}

class MeasureUninitialized extends MeasureState {}

class MeasureError extends MeasureState {}

class MeasureLoaded extends MeasureState {
  final List<Measure> measures;
  final bool hasReachedMax;

  const MeasureLoaded({
    this.measures,
    this.hasReachedMax,
  });

  MeasureLoaded copyWith({
    List<Measure> measures,
    bool hasReachedMax,
  }) {
    return MeasureLoaded(
      measures: measures ?? this.measures,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [measures, hasReachedMax];

  @override
  String toString() =>
      'MeasureLoaded { posts: ${measures.length}, hasReachedMax: $hasReachedMax }';
}
