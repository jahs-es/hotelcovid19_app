import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelcovid19_app/authentication/authentication.dart';
import 'package:hotelcovid19_app/common/common.dart';
import 'package:hotelcovid19_app/home_screen.dart';
import 'package:hotelcovid19_app/login/login_page.dart';
import 'package:hotelcovid19_app/measure/bloc/bloc.dart';
import 'package:hotelcovid19_app/services/login_repository.dart';
import 'package:hotelcovid19_app/services/measure_repository.dart';
import 'package:hotelcovid19_app/splash/splash.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final backendAuthentication = BackendAuthentication();
  runApp(
    BlocProvider<AuthenticationBloc>(
      create: (context) {
        return AuthenticationBloc(backendAuthentication: backendAuthentication)
          ..add(AppStarted());
      },
      child: App(backendAuthentication: backendAuthentication),
    ),
  );
}

class App extends StatelessWidget {
  final BackendAuthentication backendAuthentication;

  App({Key key, @required this.backendAuthentication})
      : assert(backendAuthentication != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final measureRepository = MeasureRepository();

    return MaterialApp(
      title: 'Hcovid19',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return BlocProvider(
              create: (BuildContext context) =>
                  MeasureBloc(measureRepository: measureRepository)
                    ..add(Fetch()),
              child: HomeScreen(),
            );
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage(
              backendAuthentication: this.backendAuthentication,
            );
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return SplashPage();
        },
      ),
    );
  }
}
