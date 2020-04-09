import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hotelcovid19_app/measure/models/measure.dart';
import 'package:hotelcovid19_app/services/api_path.dart';
import 'package:hotelcovid19_app/services/login_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';

class MeasureBloc extends Bloc<MeasureEvent, MeasureState> {
  final http.Client httpClient;
  final BackendAuthentication backendAuthentication;

  MeasureBloc(
      {@required this.httpClient, @required this.backendAuthentication});

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
          final measures = await _fetch(0, 20);
          yield MeasureLoaded(measures: measures, hasReachedMax: false);
          return;
        }
        if (currentState is MeasureLoaded) {
          final measures = await _fetch(currentState.measures.length, 20);
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

  Future<List<Measure>> _fetch(int startIndex, int limit) async {
    String token = await this.backendAuthentication.getToken();

    final response = await httpClient.get(APIPath.getMeasuresUrl, headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;

      List<Measure> measuresList = [];

      data.forEach((measure) {
        measuresList.add(Measure.fromJson(measure));
      });
      return measuresList;
    } else {
      throw Exception('error fetching measures');
    }
  }
}
