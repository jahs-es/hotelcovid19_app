import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotelcovid19_app/common/date_time_picker.dart';
import 'package:hotelcovid19_app/common/platform_exception_alert_dialog.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';

import 'models/measure.dart';

class MeasureEdit extends StatefulWidget {
  final Measure measure;

  const MeasureEdit({Key key, this.measure}) : super(key: key);

  static Future<void> show({
    BuildContext context,
    Measure measure,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MeasureEdit(measure: measure),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _MeasureEditState createState() => _MeasureEditState();
}

class _MeasureEditState extends State<MeasureEdit> {
  final _formKey = GlobalKey<FormState>();
  final measureRepository = MeasureRepository();

  int _id;
  DateTime _date;
  TimeOfDay _time;
  double _temperatureAt8;

  @override
  void initState() {
    super.initState();

    if (widget.measure != null) {
      _id = widget.measure.id;
      _date = widget.measure.date;
      _time = TimeOfDay.fromDateTime(widget.measure.date);
      _temperatureAt8 = widget.measure.temperatureAt8;
    } else {
      final start = DateTime.now();

      _date = DateTime(start.year, start.month, start.day);
      _time = TimeOfDay.fromDateTime(start);
      _temperatureAt8 = 0;
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

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        DateTime dateToSend = new DateTime(
            _date.year, _date.month, _date.day, _time.hour, _time.minute);
        final measure =
            Measure(id: _id, date: dateToSend, temperatureAt8: _temperatureAt8);

        Measure savedMeasure = await measureRepository.save(measure);

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
        title: Text(widget.measure == null ? 'New Measure' : 'Edit Measure'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
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
      TextFormField(
        decoration: InputDecoration(labelText: 'Temperatura a las 08:00'),
        initialValue: _temperatureAt8.toString(),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: true,
        ),
        validator: (value) =>
            value.isNotEmpty ? null : 'Temperature can\'t be empty',
        onSaved: (value) => _temperatureAt8 = double.tryParse(value) ?? 0,
      ),
    ];
  }
}
