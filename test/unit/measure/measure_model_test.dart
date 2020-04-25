import 'package:flutter_test/flutter_test.dart';
import 'package:hotelcovid19_app/models/measure.dart';

void main() {
  group('fromJson', () {
    test('measure with some properties, not received null', () {
      final measure = Measure.fromJson(
          {'date': '2020-04-19T18:00:00Z', 'temperatureAt8': 20.0});
      expect(
          measure,
          Measure(
              date: DateTime(2020, 4, 19, 20, 0),
              temperatureAt8: 20.0,
              cought: null));
    });
  });

  group('toJson', () {
    test('null properties or not set are set to default values', () {
      final measure = Measure(
          date: DateTime(2020, 4, 19, 20, 0),
          temperatureAt8: 20.0,
          cought: null);
      expect(measure.toJson(), {
        'id': null,
        'date': '2020-04-19T18:00:00.000Z',
        'temperatureAt8': 20.0,
        'temperatureAt20': 0,
        'cought': false,
        'troubleToBreathe': false,
        'sputum': false,
        'soreThroat': false,
        'ostTaste': false,
        'flutter': false,
        'diarrhea': false,
        'headache': false,
        'musclePain': false,
        'notes': ''
      });
    });
  });
}
