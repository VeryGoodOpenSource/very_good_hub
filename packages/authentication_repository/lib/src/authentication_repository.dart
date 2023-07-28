import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:rxdart/rxdart.dart';

/// {@template authentication_failure}
/// Exception thrown when authentication fails.
/// {@endtemplate}
class AuthenticationFailure implements Exception {
  /// {@macro authentication_failure}
  AuthenticationFailure({
    required this.cause,
    required this.stackTrace,
  });

  /// The reason authentication failed
  final dynamic cause;

  /// Stack trace of the authentication failure
  final StackTrace stackTrace;
}

/// {@template sign_up_failure}
/// Exception thrown when sign up fails.
/// {@endtemplate}
class SignUpFailure implements Exception {
  /// {@macro sign_up_failure}
  SignUpFailure({
    required this.cause,
    required this.stackTrace,
  });

  /// The reason authentication failed
  final dynamic cause;

  /// Stack trace of the authentication failure
  final StackTrace stackTrace;
}

/// {@template authentication_repository}
/// Repository with authentication features
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final _sessionsSubject = BehaviorSubject<Session?>();

  /// Stream of [Session]s which will emit the current session
  /// when authentication changes.
  Stream<Session?> get session => _sessionsSubject.stream;

  /// Login with [username] and [password]
  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/sign_in',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == HttpStatus.ok) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final session = Session.fromJson(json);

        _sessionsSubject.add(session);
      } else {
        throw AuthenticationFailure(
          cause: 'Authentication failed',
          stackTrace: StackTrace.current,
        );
      }
    } on AuthenticationFailure {
      rethrow;
    } catch (e, s) {
      print(e);
      print(s);
      throw AuthenticationFailure(cause: e, stackTrace: s);
    }
  }

  /// Sign up with [username], [name] and [password].
  Future<void> signUp({
    required String username,
    required String name,
    required String password,
  }) async {
    final response = await _apiClient.post(
      'auth/sign_up',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'name': name,
        'password': password,
      }),
    );

    if (response.statusCode != HttpStatus.noContent) {
      throw SignUpFailure(
        cause: 'Sign up failed, received status code ${response.statusCode} '
            'with message ${response.body}',
        stackTrace: StackTrace.current,
      );
    }
  }
}
