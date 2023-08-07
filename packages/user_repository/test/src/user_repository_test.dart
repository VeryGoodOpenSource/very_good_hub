// ignore_for_file: prefer_const_constructors
import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_repository/user_repository.dart';

class _MockApiClient extends Mock implements ApiClient {}

class _MockResponse extends Mock implements Response {}

void main() {
  group('UserRepository', () {
    late ApiClient apiClient;
    late UserRepository userRepository;

    setUp(() {
      apiClient = _MockApiClient();
      userRepository = UserRepository(apiClient: apiClient);
    });

    test('can be instantiated', () {
      expect(
        UserRepository(apiClient: _MockApiClient()),
        isNotNull,
      );
    });

    group('getUserProfile', () {
      const user = User(
        id: 'id',
        name: 'name',
        username: 'username',
      );

      test('returns the user', () async {
        final response = _MockResponse();
        when(() => response.statusCode).thenReturn(HttpStatus.ok);
        when(() => response.body).thenReturn(jsonEncode(user.toJson()));

        when(() => apiClient.authenticatedGet('hub/profile'))
            .thenAnswer((_) async => response);

        final result = await userRepository.getUserProfile();
        expect(result, equals(user));
      });

      test(
        'throws AuthenticationFailure when the user is not authenticated',
        () async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(HttpStatus.unauthorized);

          when(() => apiClient.authenticatedGet('hub/profile'))
              .thenAnswer((_) async => response);

          await expectLater(
            () => userRepository.getUserProfile(),
            throwsA(isA<AuthenticationFailure>()),
          );
        },
      );

      test(
        'throws UserInformationFailure when something else goes wrong',
        () async {
          final response = _MockResponse();
          when(() => response.statusCode).thenReturn(
            HttpStatus.internalServerError,
          );
          when(() => response.body).thenReturn('Error');

          when(() => apiClient.authenticatedGet('hub/profile'))
              .thenAnswer((_) async => response);

          await expectLater(
            () => userRepository.getUserProfile(),
            throwsA(
              isA<UserInformationFailure>().having(
                (e) => e.message,
                'message',
                equals('Error getting user profile:\n500\nError'),
              ),
            ),
          );
        },
      );
    });
  });
}
