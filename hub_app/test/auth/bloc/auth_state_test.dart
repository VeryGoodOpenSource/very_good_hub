// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_hub/auth/auth.dart';

void main() {
  group('AuthState', () {
    group('AuthInitial', () {
      test('can be instantiated', () {
        expect(AuthInitial(), isNotNull);
      });

      test('supports equality comparison', () {
        expect(AuthInitial(), equals(AuthInitial()));
      });
    });

    group('AppLoading', () {
      test('can be instantiated', () {
        expect(AuthLoading(), isNotNull);
      });

      test('supports equality comparison', () {
        expect(AuthLoading(), equals(AuthLoading()));
      });
    });

    group('AuthAuthenticationFailed', () {
      test('can be instantiated', () {
        expect(AuthAuthenticationFailed(), isNotNull);
      });

      test('supports equality comparison', () {
        expect(AuthAuthenticationFailed(), equals(AuthAuthenticationFailed()));
      });
    });

    group('AuthSignUpFailed', () {
      test('can be instantiated', () {
        expect(
          AuthSignUpFailed(error: SignUpError.passwordMismatch),
          isNotNull,
        );
      });

      test('supports equality comparison', () {
        expect(
          AuthSignUpFailed(error: SignUpError.passwordMismatch),
          equals(
            AuthSignUpFailed(error: SignUpError.passwordMismatch),
          ),
        );

        expect(
          AuthSignUpFailed(error: SignUpError.passwordMismatch),
          isNot(
            equals(
              AuthSignUpFailed(error: SignUpError.signUpFailed),
            ),
          ),
        );
      });
    });

    group('AuthSignUpSuccess', () {
      test('can be instantiated', () {
        expect(AuthSignUpSuccess(), isNotNull);
      });

      test('supports equality comparison', () {
        expect(AuthSignUpSuccess(), equals(AuthSignUpSuccess()));
      });
    });
  });
}
