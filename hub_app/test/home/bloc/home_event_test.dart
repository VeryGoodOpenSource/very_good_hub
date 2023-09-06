// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:very_good_hub/home/home.dart';

void main() {
  group('HomeEventLoad', () {
    test('can be instantiated', () {
      expect(HomeEventLoaded(), isNotNull);
    });

    test('supports value comparisons', () {
      expect(HomeEventLoaded(), equals(HomeEventLoaded()));
    });
  });

  group('HomeEventInserted', () {
    const post1 = Post(
      id: '1',
      userId: '1',
      message: '',
    );

    const post2 = Post(
      id: '2',
      userId: '2',
      message: '',
    );

    test('can be instantiated', () {
      expect(HomeEventInserted(post1), isNotNull);
    });

    test('supports value comparisons', () {
      expect(
        HomeEventInserted(post1),
        equals(HomeEventInserted(post1)),
      );

      expect(
        HomeEventInserted(post1),
        isNot(
          equals(
            HomeEventInserted(post2),
          ),
        ),
      );
    });
  });
}
