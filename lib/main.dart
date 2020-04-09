import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotelcovid19_app/authentication/authentication.dart';
import 'package:hotelcovid19_app/common/common.dart';
import 'package:hotelcovid19_app/login/login_page.dart';
import 'package:hotelcovid19_app/services/login_repository.dart';
import 'package:hotelcovid19_app/splash/splash.dart';
import 'package:provider/provider.dart';
import 'measure/measure_list.dart';

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

  runApp(Provider<AuthBase>(
    create: (context) => BackendAuthentication(),
    child: BlocProvider<AuthenticationBloc>(
      create: (context) {
        final backendAuthentication = Provider.of<BackendAuthentication>(context);

        return AuthenticationBloc(backendAuthentication: backendAuthentication)
          ..add(AppStarted());
      },
      child: App(),
    ),
  ));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HotelCovid19',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return MeasureList();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginPage();
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
