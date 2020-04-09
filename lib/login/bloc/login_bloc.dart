import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hotelcovid19_app/authentication/authentication.dart';
import 'package:hotelcovid19_app/services/login_repository.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final backendAuthentication = BackendAuthentication();
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  }) : assert(authenticationBloc != null);

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await this.backendAuthentication.authenticate(
              username: event.username,
              password: event.password,
            );

        if (token != null) {
          authenticationBloc.add(LoggedIn(token: token));
          yield LoginInitial();
        } else {
          yield LoginFailure(error: 'Credenciales no válidas');
        }
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
