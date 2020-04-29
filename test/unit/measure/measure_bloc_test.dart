import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';
import 'package:hotelcovid19_app/measure/bloc/measure_bloc.dart';
import 'package:hotelcovid19_app/models/measure.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';
import 'package:mockito/mockito.dart';

class MockMeasureRepository extends Mock implements MeasureRepository {}

class MockMeasure extends Mock implements Measure {}

void main() {
  MeasureBloc measureBloc;
  MeasureRepository measureRepository;

  final existingMeasure = Measure(id: 1, temperatureAt8: 20);
  final modifiedMeasure = Measure(id: 1, temperatureAt8: 35);
  final newMeasure = Measure(temperatureAt8: 36);

  final List<Measure> measureList = [existingMeasure];
  final List<Measure> measureListWithNewMeasure = [existingMeasure, newMeasure];

  setUp(() {
    measureRepository = MockMeasureRepository();
    measureBloc = MeasureBloc(measureRepository: measureRepository);
  });

  tearDown(() {
    measureBloc?.close();
  });

  test('after initialization bloc state is correct', () {
    expect(MeasureUninitialized(), measureBloc.initialState);
  });

  test('after closing bloc does not emit any states', () {
    expectLater(measureBloc, emitsInOrder([MeasureUninitialized(), emitsDone]));
    measureBloc.close();
  });

  test('after fetching MeasureLoaded event expected', () {
    final expectedResponse = [
      MeasureUninitialized(),
      MeasureLoaded(measures: measureList),
    ];

    when(measureRepository.getMeasures())
        .thenAnswer((_) => Future.value(measureList));

    expectLater(measureBloc, emitsInOrder(expectedResponse));
    measureBloc.add(Fetch());
  });

  //With blocTest we omit first initial state MeasureUninitialized by default (skip = 1)
  //https://pub.dev/packages/bloc_test
  group('Fetch', () {
    blocTest(
      'emits [MeasureLoaded] after fetching',
      build: () async {
        when(measureRepository.getMeasures())
            .thenAnswer((_) => Future.value(measureList));
        return measureBloc;
      },
      act: (bloc) => bloc.add(Fetch()),
      expect: [
        MeasureLoaded(measures: measureList),
      ],
    );
  });

  group('Update', () {

    blocTest(
      'emits MeasureLoaded with 2 measures when adding a new one',
      build: () async {
        when(measureRepository.getMeasures())
            .thenAnswer((_) => Future.value(measureList));
        when(measureRepository.save(newMeasure))
        .thenAnswer((_) => Future.value(newMeasure));
        return measureBloc..add(Fetch());
      },
      act: (bloc) => bloc.add(Update(measure: newMeasure)),
      skip: 2,
      expect: [MeasureLoaded(measures: measureListWithNewMeasure)],
    );

    blocTest(
      'emits MeasureLoaded with 1 measure when updating a existing one',
      build: () async {
        when(measureRepository.getMeasures())
            .thenAnswer((_) => Future.value(measureList));
        when(measureRepository.save(newMeasure))
        .thenAnswer((_) => Future.value(newMeasure));
        return measureBloc..add(Fetch());
      },
      act: (bloc) => bloc.add(Update(measure: modifiedMeasure)),
      skip: 2,
      expect: [isA<MeasureLoaded>()],
    );

  });
}
