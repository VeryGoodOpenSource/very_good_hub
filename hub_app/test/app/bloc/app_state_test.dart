// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
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
        expect(AppAuthenticated(session: session1), isNotNull);
      });

      test('supports equality', () {
        expect(
          AppAuthenticated(session: session1),
          equals(AppAuthenticated(session: session1)),
        );

        expect(
          AppAuthenticated(session: session1),
          isNot(equals(AppAuthenticated(session: session2))),
        );
      });
    });
  });
}
