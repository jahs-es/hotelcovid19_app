import 'package:flutter_test/flutter_test.dart';
import 'package:hotelcovid19_app/authentication/authentication_event.dart';

void main() {
  group('AuthenticationEvent', () {
    group('AppStarted', () {
      test('props are []', () {
        expect(AppStarted().props, []);
      });

      test('toString is "AppStarted"', () {
        expect(AppStarted().toString(), 'AppStarted');
      });
    });

    group('LoggedIn', () {
      test('props are [token]', () {
        expect(LoggedIn(token: 'token').props, ['token']);
      });

      test('toString is "LoggedIn { token: token }"', () {
        expect(
          LoggedIn(token: 'token').toString(),
          'LoggedIn { token: token }',
        );
      });
    });

    group('LoggedOut', () {
      test('props are []', () {
        expect(LoggedOut().props, []);
      });

      test('toString is "LoggedOut"', () {
        expect(LoggedOut().toString(), 'LoggedOut');
      });
    });
  });
}
