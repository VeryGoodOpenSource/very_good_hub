// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_hub/auth/auth.dart';

void main() {
  group('AuthEvent', () {
    group('AuthenticationRequested', () {
      test('can be instantiated', () {
        expect(
          AuthenticationRequested(
            username: 'username',
            password: 'password',
          ),
          isNotNull,
        );
      });

      test('supports equality comparison', () {
        expect(
          AuthenticationRequested(
            username: 'username',
            password: 'password',
          ),
          equals(
            AuthenticationRequested(
              username: 'username',
              password: 'password',
            ),
          ),
        );

        expect(
          AuthenticationRequested(
            username: 'username',
            password: 'password',
          ),
          isNot(
            equals(
              AuthenticationRequested(
                username: 'username',
                password: 'password2',
              ),
            ),
          ),
        );

        expect(
          AuthenticationRequested(
            username: 'username',
            password: 'password',
          ),
          isNot(
            equals(
              AuthenticationRequested(
                username: 'username2',
                password: 'password',
              ),
            ),
          ),
        );
      });
    });

    group('SignUpRequested', () {
      test('can be instantiated', () {
        expect(
          SignUpRequested(
            username: 'username',
            name: 'name',
            password: 'password',
            passwordConfirm: 'passwordConfirm',
          ),
          isNotNull,
        );
      });

      test('supports equality comparison', () {
        expect(
          SignUpRequested(
            username: 'username',
            name: 'name',
            password: 'password',
            passwordConfirm: 'passwordConfirm',
          ),
          equals(
            SignUpRequested(
              username: 'username',
              name: 'name',
              password: 'password',
              passwordConfirm: 'passwordConfirm',
            ),
          ),
        );

        expect(
          SignUpRequested(
            username: 'username',
            name: 'name',
            password: 'password',
            passwordConfirm: 'passwordConfirm',
          ),
          isNot(
            equals(
              SignUpRequested(
                username: 'username',
                name: 'name',
                password: 'password',
                passwordConfirm: 'passwordConfirm2',
              ),
            ),
          ),
        );

        expect(
          SignUpRequested(
            username: 'username',
            name: 'name',
            password: 'password',
            passwordConfirm: 'passwordConfirm',
          ),
          isNot(
            equals(
              SignUpRequested(
                username: 'username',
                name: 'name',
                password: 'password2',
                passwordConfirm: 'passwordConfirm',
              ),
            ),
          ),
        );

        expect(
          SignUpRequested(
            username: 'username',
            name: 'name',
            password: 'password',
            passwordConfirm: 'passwordConfirm',
          ),
          isNot(
            equals(
              SignUpRequested(
                username: 'username',
                name: 'name2',
                password: 'password',
                passwordConfirm: 'passwordConfirm',
              ),
            ),
          ),
        );

        expect(
          SignUpRequested(
            username: 'username',
            name: 'name',
            password: 'password',
            passwordConfirm: 'passwordConfirm',
          ),
          isNot(
            equals(
              SignUpRequested(
                username: 'username2',
                name: 'name',
                password: 'password',
                passwordConfirm: 'passwordConfirm',
              ),
            ),
          ),
        );
      });
    });
  });
}
