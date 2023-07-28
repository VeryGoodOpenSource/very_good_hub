// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements Response {}

void main() {
  group('AuthenticationRepository', () {
    late ApiClient apiClient;
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      apiClient = _MockApiClient();
      authenticationRepository = AuthenticationRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(
        AuthenticationRepository(apiClient: _MockApiClient()),
        isNotNull,
      );
    });

    group('login', () {
      test('emits a new session when log in is successful', () async {
        final now = DateTime.now();
        final session = Session(
          id: 'id',
          token: 'token',
          userId: 'userId',
          expiryDate: now.add(const Duration(days: 2)),
          createdAt: now,
        );

        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(session.toJson()));

        when(
          () => apiClient.post(
            'auth/sign_in',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              'username': 'username',
              'password': 'password',
            }),
          ),
        ).thenAnswer((_) async => response);

        await authenticationRepository.login(
          username: 'username',
          password: 'password',
        );

        expect(
          await authenticationRepository.session.first,
          session,
        );
      });

      test(
        'throws AuthenticationFailure when the status code is not 200',
        () async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(HttpStatus.unauthorized);

          when(
            () => apiClient.post(
              'auth/sign_in',
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: jsonEncode({
                'username': 'username',
                'password': 'password',
              }),
            ),
          ).thenAnswer((_) async => response);

          await expectLater(
            () => authenticationRepository.login(
              username: 'username',
              password: 'password',
            ),
            throwsA(
              isA<AuthenticationFailure>(),
            ),
          );
        },
      );

      test(
        'throws AuthenticationFailure when something unexpected happens',
        () async {
          when(
            () => apiClient.post(
              'auth/sign_in',
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: jsonEncode({
                'username': 'username',
                'password': 'password',
              }),
            ),
          ).thenThrow(Exception('Error'));

          await expectLater(
            () => authenticationRepository.login(
              username: 'username',
              password: 'password',
            ),
            throwsA(
              isA<AuthenticationFailure>(),
            ),
          );
        },
      );
    });

    group('signUp', () {
      test('makes the correct call', () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.noContent);

        when(
          () => apiClient.post(
            'auth/sign_up',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              'username': 'username',
              'name': 'name',
              'password': 'password',
            }),
          ),
        ).thenAnswer((_) async => response);

        await authenticationRepository.signUp(
          username: 'username',
          name: 'name',
          password: 'password',
        );

        verify(
          () => apiClient.post(
            'auth/sign_up',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
            body: jsonEncode({
              'username': 'username',
              'name': 'name',
              'password': 'password',
            }),
          ),
        ).called(1);
      });

      test(
        'throws SignUpFailure when the status code is not 204',
        () async {
          final response = _MockResponse();
          when(() => response.statusCode)
              .thenReturn(HttpStatus.internalServerError);
          when(() => response.body).thenReturn('Error');

          when(
            () => apiClient.post(
              'auth/sign_up',
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
              },
              body: jsonEncode({
                'username': 'username',
                'name': 'name',
                'password': 'password',
              }),
            ),
          ).thenAnswer((_) async => response);

          await expectLater(
            () => authenticationRepository.signUp(
              username: 'username',
              name: 'name',
              password: 'password',
            ),
            throwsA(
              isA<SignUpFailure>(),
            ),
          );
        },
      );
    });
  });
}
