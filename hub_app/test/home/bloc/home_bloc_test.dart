// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_hub/home/home.dart';

class _MockPostRepository extends Mock implements PostRepository {}

void main() {
  group('HomeBloc', () {
    late PostRepository postRepository;

    setUp(() {
      postRepository = _MockPostRepository();
    });

    test('has the correct initial state', () {
      final bloc = HomeBloc(postRepository: postRepository);
      expect(bloc.state, equals(HomeState()));
    });

    blocTest<HomeBloc, HomeState>(
      'load the posts on HomeEventLoaded',
      build: () => HomeBloc(postRepository: postRepository),
      setUp: () {
        when(postRepository.listHomePosts).thenAnswer(
          (_) async => [
            Post(
              id: '',
              message: '',
              userId: '',
            ),
          ],
        );
      },
      act: (bloc) => bloc.add(HomeEventLoaded()),
      expect: () => [
        HomeState(status: HomeStateStatus.loading),
        HomeState(
          posts: const [
            Post(
              id: '',
              message: '',
              userId: '',
            ),
          ],
          status: HomeStateStatus.loaded,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emit error when something goes wrong on HomeEventLoaded',
      build: () => HomeBloc(postRepository: postRepository),
      setUp: () {
        when(postRepository.listHomePosts).thenThrow(
          Exception('oops'),
        );
      },
      act: (bloc) => bloc.add(HomeEventLoaded()),
      expect: () => [
        HomeState(status: HomeStateStatus.loading),
        HomeState(
          status: HomeStateStatus.error,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'add a new post on HomeEventPostInserted',
      build: () => HomeBloc(postRepository: postRepository),
      seed: () => HomeState(
        posts: const [
          Post(
            id: '1',
            message: '',
            userId: '',
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        HomeEventInserted(
          Post(
            id: '2',
            message: '',
            userId: '',
          ),
        ),
      ),
      expect: () => [
        HomeState(
          posts: const [
            Post(
              id: '2',
              message: '',
              userId: '',
            ),
            Post(
              id: '1',
              message: '',
              userId: '',
            ),
          ],
        ),
      ],
    );
  });
}
