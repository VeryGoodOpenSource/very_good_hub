// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_hub/app/app.dart';

void main() {
  group('AppEvent', () {
    group('SessionLoaded', () {
      const session1 = 'TOKEN_1';
      const session2 = 'TOKEN_2';
      test('can be instantiated', () {
        expect(
          SessionLoaded(sessionToken: session1),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          SessionLoaded(sessionToken: session1),
          equals(
            SessionLoaded(sessionToken: session1),
          ),
        );
        expect(
          SessionLoaded(sessionToken: session1),
          isNot(
            equals(
              SessionLoaded(sessionToken: session2),
            ),
          ),
        );
      });
    });

    group('SessionLoggedOff', () {
      test('can be instantiated', () {
        expect(
          SessionLoggedOff(),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          SessionLoggedOff(),
          equals(
            SessionLoggedOff(),
          ),
        );
      });
    });
  });
}
