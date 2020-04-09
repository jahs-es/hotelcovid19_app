import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';
import 'package:rxdart/rxdart.dart';

class MeasureBloc extends Bloc<MeasureEvent, MeasureState> {
  final measureRepository = MeasureRepository();

  @override
  Stream<MeasureState> transformEvents(
    Stream<MeasureEvent> events,
    Stream<MeasureState> Function(MeasureEvent event) next,
  ) {
    return super.transformEvents(
      events.debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  get initialState => MeasureUninitialized();

  @override
  Stream<MeasureState> mapEventToState(MeasureEvent event) async* {
    final currentState = state;
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MeasureUninitialized) {
          final measures = await measureRepository.getMeasures();
          yield MeasureLoaded(measures: measures, hasReachedMax: false);
          return;
        }
        if (currentState is MeasureLoaded) {
          final measures = await measureRepository.getMeasures();
          yield measures.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MeasureLoaded(
                  measures: currentState.measures + measures,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield MeasureError();
      }
    }
  }

  bool _hasReachedMax(MeasureState state) => state is MeasureLoaded && state.hasReachedMax;
}
