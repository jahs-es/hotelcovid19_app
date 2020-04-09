import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hotelcovid19_app/authentication/authentication_bloc.dart';
import 'package:hotelcovid19_app/authentication/authentication_event.dart';
import 'package:hotelcovid19_app/login/bloc/login_bloc.dart';
import 'package:hotelcovid19_app/services/login_repository.dart';
import 'package:mockito/mockito.dart';

class MockBackendAuthentication extends Mock implements BackendAuthentication {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

void main() {
  LoginBloc loginBloc;
  MockBackendAuthentication backendAuthentication;
  MockAuthenticationBloc authenticationBloc;

  setUp(() {
    backendAuthentication = MockBackendAuthentication();
    authenticationBloc = MockAuthenticationBloc();
    loginBloc = LoginBloc(
      backendAuthentication: backendAuthentication,
      authenticationBloc: authenticationBloc,
    );
  });

  tearDown(() {
    loginBloc?.close();
    authenticationBloc?.close();
  });

  test('throws AssertionError when backendAuthentication is null', () {
    expect(
      () => LoginBloc(
        backendAuthentication: null,
        authenticationBloc: authenticationBloc,
      ),
      throwsAssertionError,
    );
  });

  test('throws AssertionError when authenticationBloc is null', () {
    expect(
      () => LoginBloc(
        backendAuthentication: backendAuthentication,
        authenticationBloc: null,
      ),
      throwsAssertionError,
    );
  });

  test('initial state is correct', () {
    expect(LoginInitial(), loginBloc.initialState);
  });

  test('close does not emit new states', () {
    expectLater(
      loginBloc,
      emitsInOrder([LoginInitial(), emitsDone]),
    );
    loginBloc.close();
  });

  group('LoginButtonPressed', () {
    blocTest(
      'emits [LoginLoading, LoginInitial] and token on success',
      build: () async {
        when(backendAuthentication.authenticate(
          username: 'valid.username',
          password: 'valid.password',
        )).thenAnswer((_) => Future.value('token'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        LoginButtonPressed(
          username: 'valid.username',
          password: 'valid.password',
        ),
      ),
      expect: [
        LoginLoading(),
        LoginInitial(),
      ],
      verify: (_) async {
        verify(authenticationBloc.add(LoggedIn(token: 'token'))).called(1);
      },
    );

    blocTest(
      'emits [LoginLoading, LoginFailure] on failure',
      build: () async {
        when(backendAuthentication.authenticate(
          username: 'valid.username',
          password: 'valid.password',
        )).thenThrow(Exception('login-error'));
        return loginBloc;
      },
      act: (bloc) => bloc.add(
        LoginButtonPressed(
          username: 'valid.username',
          password: 'valid.password',
        ),
      ),
      expect: [
        LoginLoading(),
        LoginFailure(error: 'Exception: login-error'),
      ],
      verify: (_) async {
        verifyNever(authenticationBloc.add(any));
      },
    );
  });
}
