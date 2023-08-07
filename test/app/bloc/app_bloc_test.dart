// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_hub/app/app.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  group('AppBloc', () {
    late AuthenticationRepository authenticationRepository;
    late TokenProvider tokenProvider;
    final now = DateTime.now();

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      when(() => authenticationRepository.session)
          .thenAnswer((_) => const Stream.empty());

      tokenProvider = _MockTokenProvider();
    });

    test(
      'has the correct initial state',
      () {
        expect(
          AppBloc(
            authenticationRepository: authenticationRepository,
            tokenProvider: tokenProvider,
          ).state,
          equals(AppInitial()),
        );
      },
    );

    blocTest<AppBloc, AppState>(
      'emits [authenticated] when session is added and apply the token in '
      'the provider',
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
        tokenProvider: tokenProvider,
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
      verify: (_) {
        verify(() => tokenProvider.applyToken('token')).called(1);
      },
    );

    blocTest<AppBloc, AppState>(
      'clears the token when the the session is null',
      build: () => AppBloc(
        authenticationRepository: authenticationRepository,
        tokenProvider: tokenProvider,
      ),
      seed: () => AppAuthenticated(
        session: Session(
          id: 'mock-user-id',
          userId: 'userId',
          token: 'token',
          createdAt: now,
          expiryDate: now.add(const Duration(days: 1)),
        ),
      ),
      setUp: () {
        when(() => authenticationRepository.session).thenAnswer(
          (_) => Stream.fromIterable(
            [null],
          ),
        );
      },
      expect: () => [
        AppInitial(),
      ],
      verify: (_) {
        verify(() => tokenProvider.clear()).called(1);
      },
    );
  });
}
