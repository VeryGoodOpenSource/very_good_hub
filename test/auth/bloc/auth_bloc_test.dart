// ignore_for_file: prefer_const_constructors

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_hub/auth/auth.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('AuthBloc', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      when(() => authenticationRepository.session)
          .thenAnswer((_) => const Stream.empty());
    });

    test(
      'has the correct initial state',
      () {
        expect(
          AuthBloc(
            authenticationRepository: authenticationRepository,
          ).state,
          equals(AuthInitial()),
        );
      },
    );

    blocTest<AuthBloc, AuthState>(
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
      build: () => AuthBloc(
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

    blocTest<AuthBloc, AuthState>(
      'emits AuthAuthenticationFailed when something goes wrong',
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
      build: () => AuthBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) => bloc.add(
        AuthenticationRequested(
          username: 'u',
          password: 'p',
        ),
      ),
      expect: () => [
        AuthLoading(),
        AuthAuthenticationFailed(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'calls signUp on AuthenticationRequested and emits AuthAuthenticated '
      'when successful',
      setUp: () {
        when(
          () => authenticationRepository.signUp(
            name: any(named: 'name'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async {},
        );
      },
      build: () => AuthBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) => bloc.add(
        SignUpRequested(
          name: 'n',
          username: 'u',
          password: 'p',
          passwordConfirm: 'p',
        ),
      ),
      verify: (_) {
        verify(
          () => authenticationRepository.signUp(
            name: 'n',
            username: 'u',
            password: 'p',
          ),
        ).called(1);
      },
      expect: () => [
        AuthLoading(),
        AuthSignUpSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits AuthSignUpFailed when something goes wrong',
      setUp: () {
        when(
          () => authenticationRepository.signUp(
            name: any(named: 'name'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Oops'));
      },
      build: () => AuthBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) => bloc.add(
        SignUpRequested(
          name: 'n',
          username: 'u',
          password: 'p',
          passwordConfirm: 'p',
        ),
      ),
      expect: () => [
        AuthLoading(),
        AuthSignUpFailed(error: SignUpError.signUpFailed),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      "emits AuthSignUpFailed when passwords don't match",
      setUp: () {
        when(
          () => authenticationRepository.signUp(
            name: any(named: 'name'),
            username: any(named: 'username'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception('Oops'));
      },
      build: () => AuthBloc(
        authenticationRepository: authenticationRepository,
      ),
      act: (bloc) => bloc.add(
        SignUpRequested(
          name: 'n',
          username: 'u',
          password: 'p',
          passwordConfirm: 'r',
        ),
      ),
      expect: () => [
        AuthSignUpFailed(error: SignUpError.passwordMismatch),
      ],
    );
  });
}
