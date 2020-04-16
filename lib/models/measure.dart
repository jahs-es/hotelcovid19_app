import 'dart:convert';

import 'package:equatable/equatable.dart';

Measure fromJson(String str) => Measure.fromJson(json.decode(str));

String toJson(Measure data) => json.encode(data.toJson());

class Measure extends Equatable {
  final int id;
  final DateTime date;
  final double temperatureAt8;
  final double temperatureAt20;
  final bool cought;
  final bool troubleToBreathe;
  final bool sputum;
  final bool soreThroat;
  final bool ostTaste;
  final bool flutter;
  final bool diarrhea;
  final bool headache;
  final bool musclePain;
  final String notes;

  Measure copyWith({int id}) {
    return Measure(
      id: id,
      date: this.date,
      temperatureAt8: this.temperatureAt8,
      temperatureAt20: this.temperatureAt20,
      cought: this.cought,
      troubleToBreathe: this.troubleToBreathe,
      sputum: this.sputum,
      soreThroat: this.soreThroat,
      ostTaste: this.ostTaste,
      flutter: this.flutter,
      diarrhea: this.diarrhea,
      headache: this.headache,
      musclePain: this.musclePain,
      notes: this.notes
    );
  }

  const Measure(
      {this.id,
      this.date,
      this.temperatureAt8,
      this.temperatureAt20,
      this.cought,
      this.troubleToBreathe,
      this.sputum,
      this.soreThroat,
      this.ostTaste,
      this.flutter,
      this.diarrhea,
      this.headache,
      this.musclePain,
      this.notes});

  @override
  List<Object> get props => [
        id,
        date,
        temperatureAt8,
        temperatureAt20,
        cought,
        troubleToBreathe,
        sputum,
        soreThroat,
        ostTaste,
        flutter,
        diarrhea,
        headache,
        musclePain,
        notes
      ];

  @override
  String toString() => 'Measure { id: $id }';

  Measure.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        date = DateTime.parse(json['date']).toLocal(),
        temperatureAt8 = json['temperatureAt8'],
        temperatureAt20 = json['temperatureAt20'],
        cought = json['cought'],
        troubleToBreathe = json['troubleToBreathe'],
        sputum = json['sputum'],
        soreThroat = json['soreThroat'],
        ostTaste = json['ostTaste'],
        flutter = json['flutter'],
        diarrhea = json['diarrhea'],
        headache = json['headache'],
        musclePain = json['musclePain'],
        notes = json['notes'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toUtc().toIso8601String(),
        'temperatureAt8': temperatureAt8 ?? 0,
        'temperatureAt20': temperatureAt20 ?? 0,
        'cought': cought ?? false,
        'troubleToBreathe': troubleToBreathe ?? false,
        'sputum': sputum ?? false,
        'soreThroat': soreThroat ?? false,
        'ostTaste': ostTaste ?? false,
        'flutter': flutter ?? false,
        'diarrhea': diarrhea ?? false,
        'headache': headache ?? false,
        'musclePain': musclePain ?? false,
        'notes': notes ?? '',
      };
}
