// ignore_for_file: prefer_const_constructors

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_hub/app/app.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('AppBloc', () {
    late AuthenticationRepository authenticationRepository;
    final now = DateTime.now();

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      when(() => authenticationRepository.session)
          .thenAnswer((_) => const Stream.empty());
    });

    test(
      'has the correct initial state',
      () {
        expect(
          AppBloc(
            authenticationRepository: authenticationRepository,
          ).state,
          equals(AppInitial()),
        );
      },
    );

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when session is added',
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
      ),
      setUp: () {
        when(() => authenticationRepository.session).thenAnswer(
          (_) => Stream.fromIterable(
            [
              Session(
                id: 'mock-user-id',
                userId: 'userId',
                token: 'token',
                createdAt: now,
                expiryDate: now.add(const Duration(days: 1)),
              ),
            ],
          ),
        );
      },
      expect: () => [
        AppAuthenticated(
          session: Session(
            id: 'mock-user-id',
            userId: 'userId',
            token: 'token',
            createdAt: now,
            expiryDate: now.add(const Duration(days: 1)),
          ),
        ),
      ],
    );

    blocTest<AppBloc, AppState>(
      'calls login on AuthenticationRequested',
      setUp: () {
        when(
          () => authenticationRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async {},
        );
      },
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) => bloc.add(
        AuthenticationRequested(
          username: 'u',
          password: 'p',
        ),
      ),
      verify: (_) {
        verify(
          () => authenticationRepository.login(
            username: 'u',
            password: 'p',
          ),
        ).called(1);
      },
    );

    blocTest<AppBloc, AppState>(
      'emits AppAuthenticationFailed when something goes wrong',
      setUp: () {
        when(
          () => authenticationRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          Exception('oops'),
        );
      },
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) => bloc.add(
        AuthenticationRequested(
          username: 'u',
          password: 'p',
        ),
      ),
      expect: () => [
        AppLoading(),
        AppAuthenticationFailed(),
      ],
    );
  });
}
