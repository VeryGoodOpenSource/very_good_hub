import 'package:api_client/api_client.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/auth/auth.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

class _MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  group('App', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      when(() => authenticationRepository.session)
          .thenAnswer((_) => const Stream.empty());
    });
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        App(
          authenticationRepository: authenticationRepository,
          userRepository: _MockUserRepository(),
          tokenProvider: _MockTokenProvider(),
        ),
      );
      expect(find.byType(AuthViewView), findsOneWidget);
    });
  });
}
