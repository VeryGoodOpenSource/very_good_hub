// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:very_good_hub/create_post/create_post.dart';

void main() {
  group('can be instantiated', () {
    test('CreatePostState', () {
      expect(CreatePostState(), isNotNull);
    });

    test('support equality', () {
      expect(CreatePostState(), equals(CreatePostState()));
      expect(
        CreatePostState(),
        isNot(
          equals(
            CreatePostState(
              status: CreatePostStatus.success,
            ),
          ),
        ),
      );
      expect(
        CreatePostState(),
        isNot(
          equals(
            CreatePostState(
              post: Post(
                id: 'id',
                userId: 'userId',
                message: 'message',
              ),
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with the specified fields', () {
      expect(
        CreatePostState().copyWith(status: CreatePostStatus.success),
        equals(
          CreatePostState(
            status: CreatePostStatus.success,
          ),
        ),
      );
      expect(
        CreatePostState().copyWith(
          post: Post(
            id: 'id',
            userId: 'userId',
            message: 'message',
          ),
        ),
        equals(
          CreatePostState(
            post: Post(
              id: 'id',
              userId: 'userId',
              message: 'message',
            ),
          ),
        ),
      );
      expect(
        CreatePostState().copyWith(
          failure: CreatePostFailure.unexpected,
        ),
        equals(
          CreatePostState(
            failure: CreatePostFailure.unexpected,
          ),
        ),
      );
    });
  });
}
