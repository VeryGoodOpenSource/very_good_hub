import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:hub_domain/hub_domain.dart';

/// Exception thrown when there is no authenticated user.
class AuthenticationFailure implements Exception {}

/// {@template user_information_failure}
///  Exception thrown when there is an error getting user information.
/// {@endtemplate}
class UserInformationFailure implements Exception {
  /// {@macro user_information_failure}
  const UserInformationFailure({
    required this.message,
    required this.stackTrace,
  });

  /// Message describing the error.
  final String message;

  /// Stack trace of the error.
  final StackTrace stackTrace;
}

/// {@template user_repository}
/// Repository with user related features
/// {@endtemplate}
class UserRepository {
  /// {@macro user_repository}
  const UserRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  /// Gets the user profile.
  Future<User> getUserProfile() async {
    final response = await _apiClient.authenticatedGet(
      'hub/profile',
    );

    if (response.statusCode == HttpStatus.unauthorized) {
      throw AuthenticationFailure();
    } else if (response.statusCode != HttpStatus.ok) {
      throw UserInformationFailure(
        message: 'Error getting user profile:\n${response.statusCode}'
            '\n${response.body}',
        stackTrace: StackTrace.current,
      );
    } else {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromJson(json);
    }
  }
}
