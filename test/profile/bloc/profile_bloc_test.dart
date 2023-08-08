import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/profile/profile.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('ProfileBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = _MockUserRepository();
    });

    test('can be instantiated', () {
      expect(
        ProfileBloc(userRepository: _MockUserRepository()),
        isNotNull,
      );
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits the profile when fetching data succeeds',
      build: () => ProfileBloc(
        userRepository: userRepository,
      ),
      setUp: () {
        when(userRepository.getUserProfile).thenAnswer(
          (_) async => const User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        );
      },
      act: (bloc) => bloc.add(const ProfileRequested()),
      expect: () => const [
        ProfileLoadInProgress(),
        ProfileLoaded(
          User(
            id: 'id',
            name: 'name',
            username: 'username',
          ),
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits ProfileLoadFailure when the fetching fails',
      build: () => ProfileBloc(
        userRepository: userRepository,
      ),
      setUp: () {
        when(userRepository.getUserProfile).thenThrow(Exception('Ops'));
      },
      act: (bloc) => bloc.add(const ProfileRequested()),
      expect: () => const [
        ProfileLoadInProgress(),
        ProfileLoadFailure(),
      ],
    );
  });
}
