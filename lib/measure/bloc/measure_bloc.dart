import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';
import 'package:hotelcovid19_app/models/measure.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';

class MeasureBloc extends Bloc<MeasureEvent, MeasureState> {
  final measureRepository = MeasureRepository();

  @override
  get initialState => MeasureUninitialized();

  @override
  Stream<MeasureState> mapEventToState(MeasureEvent event) async* {
    if (event is Fetch) {
      yield* _mapMeasureFetchToState();
    } else if (event is Update) {
      yield* _mapMeasureUpdateToState(event);
    }
  }

  Stream<MeasureState> _mapMeasureFetchToState() async* {
    try {
      if (state is MeasureUninitialized) {
        final measures = await measureRepository.getMeasures();
        yield MeasureLoaded(measures: measures);
        return;
      }
    } catch (_) {
      yield MeasureError();
    }
  }

  Stream<MeasureState> _mapMeasureUpdateToState(Update event) async* {
    if (state is MeasureLoaded) {
      try {
        bool newMeasure = event.measure.id == null ? true : false;
        Measure savedMeasure = await measureRepository.save(event.measure);

        if (newMeasure) {
          final List<Measure> updatedMeasures  =
              List.from((state as MeasureLoaded).measures)..add(savedMeasure);

          yield MeasureLoaded(measures: updatedMeasures);
        } else {
          List<Measure> updatedMeasures =
              (state as MeasureLoaded).measures.map((measure) {
            return measure.id == event.measure.id ? event.measure : measure;
          }).toList();

          yield MeasureLoaded(measures: updatedMeasures);
        }

        return;
      } catch (_) {
        yield MeasureError();
      }
    }
  }
}
