import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/bootstrap.dart';
import 'package:very_good_hub/token_provider_storage/token_provider_storage.dart';

void main() {
  final tokenProviderStorage = TokenProviderStorage();
  final tokenProvider = TokenProvider(
    getToken: tokenProviderStorage.getToken,
    storeToken: tokenProviderStorage.storeToken,
    clearToken: tokenProviderStorage.clearToken,
  );
  final apiClient = ApiClient(
    baseUrl: 'https://api.example.com',
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