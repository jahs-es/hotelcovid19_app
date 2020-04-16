import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/authentication_bloc.dart';
import 'authentication/authentication_event.dart';
import 'measure/bloc/measure_bloc.dart';
import 'measure/measure_edit.dart';
import 'measure/measure_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _measureBloc = BlocProvider.of<MeasureBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis mediciones'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _measureBloc,
        child: MeasureList(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<MeasureEdit>(
            builder: (context) {
              return BlocProvider.value(
                value: _measureBloc,
                child: MeasureEdit(measure: null),
              );
            },
            fullscreenDialog: true,
          ),
        ),
      ),
    );
  }
}
