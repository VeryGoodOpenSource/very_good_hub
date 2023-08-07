import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/bootstrap.dart';

void main() {
  final tokenProvider = TokenProvider();
  final apiClient = ApiClient(
    baseUrl: 'http://localhost:8080',
    tokenProvider: tokenProvider,
  );

  bootstrap(
    () => App(
      authenticationRepository: AuthenticationRepository(
        apiClient: apiClient,
      ),
      userRepository: UserRepository(
        apiClient: apiClient,
      ),
      tokenProvider: tokenProvider,
    ),
  );
}
