import 'package:authentication_repository/authentication_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:db_client/db_client.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:session_repository/session_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub_api/middlewares/middlewares.dart';
import 'package:very_good_hub_api/models/models.dart';

Handler middleware(Handler handler) {
  return handler
      .use(
        bearerAuthentication<ApiSession>(
          authenticator: (context, token) async {
            final authenticationReposity =
                context.read<AuthenticationRepository>();
            final session =
                Session.fromJson(authenticationReposity.verify(token));

            final userRepository = context.read<UserRepository>();
            final user = await userRepository.findUserById(session.userId);

            if (user != null) {
              return ApiSession(user: user, session: session);
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
