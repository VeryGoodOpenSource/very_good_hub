// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:very_good_hub/home/home.dart';

void main() {
  group('HomeState', () {
    test('can be instantiated', () {
      expect(HomeState(), isNotNull);
    });

    test('supports value comparisons', () {
      expect(HomeState(), equals(HomeState()));

      expect(
        HomeState(),
        isNot(
          equals(
            HomeState(
              posts: const [
                Post(
                  id: '1',
                  userId: '1',
                  message: '',
                ),
              ],
            ),
          ),
        ),
      );

      expect(
        HomeState(),
        isNot(
          equals(
            HomeState(status: HomeStateStatus.loading),
          ),
        ),
      );
    });

    test('copyWith return new instances with the new values', () {
      final state = HomeState();
      final copy = state.copyWith(
        posts: const [
          Post(
            id: '1',
            userId: '1',
            message: '',
          ),
        ],
        status: HomeStateStatus.loading,
      );
      expect(copy.posts, isNot(equals(state.posts)));
      expect(copy.status, isNot(equals(state.status)));
    });
  });
}
