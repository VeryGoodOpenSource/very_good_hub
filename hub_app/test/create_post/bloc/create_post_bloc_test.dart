// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/create_post/create_post.dart';

class _MockPostRepository extends Mock implements PostRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('CreatePostBloc', () {
    late PostRepository postRepository;
    late UserRepository userRepository;

    setUp(() {
      postRepository = _MockPostRepository();
      userRepository = _MockUserRepository();
    });

    test('has the correct initial state', () {
      expect(
        CreatePostBloc(
          postRepository: postRepository,
          userRepository: userRepository,
        ).state,
        equals(CreatePostState()),
      );
    });

    blocTest<CreatePostBloc, CreatePostState>(
      'emits [CreatePostState(status: CreatePostStatus.success)] '
      'when CreatePostSubmitted is added.',
      build: () => CreatePostBloc(
        postRepository: postRepository,
        userRepository: userRepository,
      ),
      setUp: () {
        when(userRepository.getUserProfile).thenAnswer(
          (_) async => User(id: 'userId', name: 'name', username: ''),
        );

        when(
          () => postRepository.createPost(
            userId: any(named: 'userId'),
            message: any(named: 'message'),
          ),
        ).thenAnswer(
          (_) async => Post(
            id: 'id',
            userId: 'userId',
            message: 'message',
          ),
        );
      },
      act: (bloc) => bloc.add(CreatePostSubmitted('message')),
      expect: () => [
        CreatePostState(
          status: CreatePostStatus.success,
          post: Post(
            id: 'id',
            userId: 'userId',
            message: 'message',
          ),
        ),
      ],
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'emits [CreatePostState(status: CreatePostStatus.failure)] '
      'with the correct reason when create post fails.',
      build: () => CreatePostBloc(
        postRepository: postRepository,
        userRepository: userRepository,
      ),
      setUp: () {
        when(userRepository.getUserProfile).thenAnswer(
          (_) async => User(id: 'userId', name: 'name', username: ''),
        );

        when(
          () => postRepository.createPost(
            userId: any(named: 'userId'),
            message: any(named: 'message'),
          ),
        ).thenThrow(
          PostCreationFailure(CreatePostFailure.tooLong, StackTrace.empty),
        );
      },
      act: (bloc) => bloc.add(CreatePostSubmitted('message')),
      expect: () => [
        CreatePostState(
          status: CreatePostStatus.failure,
          failure: CreatePostFailure.tooLong,
        ),
      ],
    );

    blocTest<CreatePostBloc, CreatePostState>(
      'emits [CreatePostState(status: CreatePostStatus.failure)] '
      'with the unexpected when something not expected fails.',
      build: () => CreatePostBloc(
        postRepository: postRepository,
        userRepository: userRepository,
      ),
      setUp: () {
        when(userRepository.getUserProfile).thenAnswer(
          (_) async => User(id: 'userId', name: 'name', username: ''),
        );

        when(
          () => postRepository.createPost(
            userId: any(named: 'userId'),
            message: any(named: 'message'),
          ),
        ).thenThrow(Exception('This was not expected'));
      },
      act: (bloc) => bloc.add(CreatePostSubmitted('message')),
      expect: () => [
        CreatePostState(
          status: CreatePostStatus.failure,
          failure: CreatePostFailure.unexpected,
        ),
      ],
    );
  });
}
