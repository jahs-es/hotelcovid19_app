import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelcovid19_app/authentication/authentication.dart';
import 'package:hotelcovid19_app/login/bloc/login_bloc.dart';
import 'package:hotelcovid19_app/login/login_form.dart';
import 'package:hotelcovid19_app/services/login_repository.dart';

class LoginPage extends StatelessWidget {
  final BackendAuthentication backendAuthentication;

  LoginPage(
      {@required this.backendAuthentication})
      : assert(backendAuthentication != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceso a HotelCovid19'),
      ),
      body: BlocProvider(
        create: (context) {
          return LoginBloc(
            authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
            backendAuthentication: this.backendAuthentication
          );
        },
        child: LoginForm(),
      ),
    );
  }
}
