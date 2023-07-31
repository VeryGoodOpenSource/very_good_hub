// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:very_good_hub/app/app.dart';

void main() {
  group('AppEvent', () {
    group('AuthenticationRequested', () {
      test('can be instantiated', () {
        expect(
          AuthenticationRequested(username: '', password: ''),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          AuthenticationRequested(username: '', password: ''),
          equals(
            AuthenticationRequested(username: '', password: ''),
          ),
        );
        expect(
          AuthenticationRequested(username: '', password: ''),
          isNot(
            equals(
              AuthenticationRequested(username: 'u', password: ''),
            ),
          ),
        );

        expect(
          AuthenticationRequested(username: '', password: ''),
          isNot(
            equals(
              AuthenticationRequested(username: '', password: 'p'),
            ),
          ),
        );
      });
    });

    group('SessionLoaded', () {
      final session1 = Session(
        id: '1',
        userId: '',
        token: '',
        createdAt: DateTime.now(),
        expiryDate: DateTime.now(),
      );
      final session2 = Session(
        id: '2',
        userId: '',
        token: '',
        createdAt: DateTime.now(),
        expiryDate: DateTime.now(),
      );
      test('can be instantiated', () {
        expect(
          SessionLoaded(session: session1),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          SessionLoaded(session: session1),
          equals(
            SessionLoaded(session: session1),
          ),
        );
        expect(
          SessionLoaded(session: session1),
          isNot(
            equals(
              SessionLoaded(session: session2),
            ),
          ),
        );
      });
    });
  });
}
