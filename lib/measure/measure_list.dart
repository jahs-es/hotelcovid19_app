import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';
import 'package:intl/intl.dart';

import '../models/measure.dart';
import 'measure_edit.dart';

class MeasureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final measureRepository = MeasureRepository();

    return BlocBuilder<MeasureBloc, MeasureState>(
      builder: (context, state) {
        if (state is MeasureError) {
          return Center(
            child: Text('Error en la carga de mediciones'),
          );
        }
        if (state is MeasureLoaded) {
          print("Paso MeasureLoaded");
          if (state.measures.isEmpty) {
            return Center(
              child: Text('no hay mediciones'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) => Dismissible(
              key: Key('measure-${state.measures[index].id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) =>
                  measureRepository.delete(state.measures[index].id),
              child: _buildTitle(context, state.measures[index]),
            ),
            itemCount: state.measures.length,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context, Measure measure) {
    var formatter = new DateFormat('dd-MM-yyyy HH:mm');
    String formatted = formatter.format(measure.date);
    final _measureBloc = BlocProvider.of<MeasureBloc>(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/termo.jpeg'),
      ),
      title: Text(formatted),
      subtitle: Text(measure.temperatureAt8.toString()),
      dense: true,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<MeasureEdit>(
          builder: (context) {
            return BlocProvider.value(
              value: _measureBloc,
              child: MeasureEdit(measure: measure),
            );
          },
          fullscreenDialog: true,
        ),
      ),
    );
  }
}
