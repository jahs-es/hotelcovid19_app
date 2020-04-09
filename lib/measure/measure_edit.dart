import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelcovid19_app/common/date_time_picker.dart';
import 'package:hotelcovid19_app/common/platform_exception_alert_dialog.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';

import '../models/measure.dart';
import 'bloc/measure_bloc.dart';

class MeasureEdit extends StatefulWidget {
  final Measure measure;

  const MeasureEdit({Key key, this.measure}) : super(key: key);

  @override
  _MeasureEditState createState() => _MeasureEditState();
}

class _MeasureEditState extends State<MeasureEdit> {
  final _formKey = GlobalKey<FormState>();
  final measureRepository = MeasureRepository();

  int _id;
  DateTime _date;
  TimeOfDay _time;
  Map<String, double> doubleValues = {
    'temperatureAt8': 0,
    'temperatureAt20': 0,
  };
  Map<String, bool> checkboxValues = {
    'cought': false,
    'troubleToBreathe': false,
    'sputum': false,
    'soreThroat': false,
    'ostTaste': false,
    'flutter': false,
    'diarrhea': false,
    'headache': false,
    'musclePain': false,
  };
  String _notes;

  @override
  void initState() {
    super.initState();

    if (widget.measure != null) {
      _id = widget.measure.id;
      _date = widget.measure.date;
      _time = TimeOfDay.fromDateTime(widget.measure.date);
      doubleValues["temperatureAt8"] = widget.measure.temperatureAt8;
      doubleValues["temperatureAt20"] = widget.measure.temperatureAt20;
      checkboxValues["cought"] = widget.measure.cought;
      checkboxValues["troubleToBreathe"] = widget.measure.troubleToBreathe;
      checkboxValues["sputum"] = widget.measure.sputum;
      checkboxValues["soreThroat"] = widget.measure.soreThroat;
      checkboxValues["ostTaste"] = widget.measure.ostTaste;
      checkboxValues["flutter"] = widget.measure.flutter;
      checkboxValues["diarrhea"] = widget.measure.diarrhea;
      checkboxValues["headache"] = widget.measure.headache;
      checkboxValues["musclePain"] = widget.measure.musclePain;
      _notes = widget.measure.notes;
    } else {
      final start = DateTime.now();

      _date = DateTime(start.year, start.month, start.day);
      _time = TimeOfDay.fromDateTime(start);
      _notes = "";
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit(BuildContext context) async {
    if (_validateAndSaveForm()) {
      try {
        DateTime dateToSend = new DateTime(
          _date.year,
          _date.month,
          _date.day,
          _time.hour,
          _time.minute,
        );

        final measure = Measure(
            id: _id,
            date: dateToSend,
            temperatureAt8: doubleValues["temperatureAt8"],
            temperatureAt20: doubleValues["temperatureAt20"],
            cought: checkboxValues["cought"],
            troubleToBreathe: checkboxValues["troubleToBreathe"],
            sputum: checkboxValues["sputum"],
            soreThroat: checkboxValues["soreThroat"],
            ostTaste: checkboxValues["ostTaste"],
            flutter: checkboxValues["flutter"],
            diarrhea: checkboxValues["diarrhea"],
            headache: checkboxValues["headache"],
            musclePain: checkboxValues["musclePain"],
            notes: _notes,
        );

        final measureBloc = BlocProvider.of<MeasureBloc>(context);

        measureBloc.add(Update(measure: measure));

        Navigator.of(context).pop();
      } catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e.toString(),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
            widget.measure == null ? 'Nueva medida' : 'Editando medida'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _submit(context),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      DateTimePicker(
        labelText: 'Fecha y hora',
        selectedDate: _date,
        selectedTime: _time,
        onSelectedDate: (date) => setState(() => _date = date),
        onSelectedTime: (time) => setState(() => _time = time),
      ),
      _buildTemperatureField('Temperatura a las 08:00', "temperatureAt8"),
      _buildTemperatureField('Temperatura a las 20:00', "temperatureAt20"),
      _buildCheckBox('¿Tos seca?', "cought"),
      _buildCheckBox('¿Dificultad para respirar?', "troubleToBreathe"),
      _buildCheckBox('¿Esputos?', "sputum"),
      _buildCheckBox('¿Dolor de gargante?', "soreThroat"),
      _buildCheckBox('¿Perdida del gusto?', "ostTaste"),
      _buildCheckBox('¿Palpitaciones?', "flutter"),
      _buildCheckBox('¿Diarrea?', "diarrhea"),
      _buildCheckBox('¿Dolor de cabeza?', "headache"),
      _buildCheckBox('¿Dolor muscular?', "musclePain"),
      _buildNotesField(),
    ];
  }

  Widget _buildTemperatureField(String labelText, String key) {
    return TextFormField(
      decoration: InputDecoration(labelText: labelText),
      initialValue: doubleValues[key].toString(),
      keyboardType: TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      ),
      validator: (value) =>
      value.isNotEmpty ? null : 'Temperature can\'t be empty',
      onSaved: (value) => doubleValues[key] = double.tryParse(value) ?? 0,
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Notas"),
      initialValue: _notes,
      onSaved: (value) => _notes = value,
    );
  }

  Widget _buildCheckBox(String labelText, String key) {
    return new CheckboxListTile(
      value: checkboxValues[key],
      onChanged: (bool newValue) =>
          setState(() => checkboxValues[key] = newValue),
      title: new Text(labelText),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.blueAccent,);
  }

}
