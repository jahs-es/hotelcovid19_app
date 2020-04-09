import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelcovid19_app/authentication/authentication_bloc.dart';
import 'package:hotelcovid19_app/authentication/authentication_event.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';
import 'package:intl/intl.dart';

import 'measure_edit.dart';
import 'models/measure.dart';

class MeasureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: BlocProvider(
        create: (context) => MeasureBloc()..add(Fetch()),
        child: MeasureListStatefull(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => MeasureEdit.show(
          context: context,
          measure: null,
        ),
      ),
    );
  }
}

class MeasureListStatefull extends StatefulWidget {
  @override
  _MeasureListStatefullState createState() => _MeasureListStatefullState();
}

class _MeasureListStatefullState extends State<MeasureListStatefull> {
  MeasureBloc _measureBloc;

  @override
  void initState() {
    super.initState();
    _measureBloc = BlocProvider.of<MeasureBloc>(context);
  }

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
          if (state.measures.isEmpty) {
            return Center(
              child: Text('no hay mediciones'),
            );
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                (index >= state.measures.length)
                    ? BottomLoader()
                    : Dismissible(
                        key: Key('measure-${state.measures[index].id}'),
                        background: Container(color: Colors.red),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) =>
                            measureRepository.delete(state.measures[index].id),
                        child: MeasureTitle(measure: state.measures[index]),
                      ),
            itemCount: state.hasReachedMax
                ? state.measures.length
                : state.measures.length + 1,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
        ),
      ),
    );
  }
}

class MeasureTitle extends StatelessWidget {
  final Measure measure;

  MeasureTitle({
    Key key,
    @required Measure this.measure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = new DateFormat('dd-MM-yyyy HH:mm');
    String formatted = formatter.format(measure.date);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/termo.jpeg'),
      ),
      title: Text(formatted),
      dense: true,
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () => MeasureEdit.show(
        context: context,
        measure: this.measure,
      ),
    );
  }
}
