import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';
import 'package:session_repository/session_repository.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;
import 'package:user_repository/user_repository.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        fromShelfMiddleware(
          shelf.corsHeaders(
            headers: {
              shelf.ACCESS_CONTROL_ALLOW_ORIGIN: _hubUrl,
            },
          ),
        ),
      )
      .use(
        provider<SessionRepository>(
          (context) => SessionRepository(dbClient: context.read<DbClient>()),
        ),
      )
      .use(
        provider<UserRepository>(
          (context) => UserRepository(dbClient: context.read<DbClient>()),
        ),
      );
}

String get _hubUrl {
  final value = Platform.environment['HUB_URL'];
  if (value == null) {
    throw ArgumentError('HUB_URL is required to run the API');
  }
  return value;
}
