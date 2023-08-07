import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:db_client/db_client.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub_api/middlewares/middlewares.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        bearerAuthentication<User>(
          authenticator: (context, token) async {
            final sessionRepository = context.read<SessionRepository>();
            final session = await sessionRepository.sessionFromToken(token);

            if (session != null) {
              final userRepository = context.read<UserRepository>();
              return userRepository.findUserById(session.userId);
            }

            return null;
          },
        ),
      )
      .use(corsHeaders())
      .use(requestLogger())
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
