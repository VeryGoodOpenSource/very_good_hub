// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:very_good_hub/create_post/create_post.dart';

void main() {
  group('CreatePostEvent', () {
    group('CreatePostSubmitted', () {
      test('can be instantiated', () {
        expect(CreatePostSubmitted(''), isNotNull);
      });

      test('supports equality', () {
        expect(CreatePostSubmitted(''), equals(CreatePostSubmitted('')));
        expect(
          CreatePostSubmitted(''),
          isNot(
            equals(
              CreatePostSubmitted('a'),
            ),
          ),
        );
      });
    });
  });
}
