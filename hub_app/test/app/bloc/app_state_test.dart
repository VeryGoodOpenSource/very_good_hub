// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_hub/app/app.dart';

void main() {
  group('AppState', () {
    group('AppInitial', () {
      test('can be instantiated', () {
        expect(AppInitial(), isNotNull);
      });

      test('supports equality', () {
        expect(AppInitial(), equals(AppInitial()));
      });
    });

    group('AppAuthenticated', () {
      const session1 = 'TOKEN_1';
      const session2 = 'TOKEN_2';
      test('can be instantiated', () {
        expect(AppAuthenticated(sessionToken: session1), isNotNull);
      });

      test('supports equality', () {
        expect(
          AppAuthenticated(sessionToken: session1),
          equals(AppAuthenticated(sessionToken: session1)),
        );

        expect(
          AppAuthenticated(sessionToken: session1),
          isNot(equals(AppAuthenticated(sessionToken: session2))),
        );
      });
    });
  });
}
