// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_hub/profile/profile.dart';

void main() {
  group('ProfileRequested', () {
    test('can be instantiated', () {
      expect(
        ProfileRequested(),
        isNotNull,
      );
    });

    test('supports value comparison', () {
      expect(
        ProfileRequested(),
        equals(
          ProfileRequested(),
        ),
      );
    });
  });
}
