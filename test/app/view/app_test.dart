import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_hub/app/app.dart';

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

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
        ),
      );
      expect(find.byType(SignInView), findsOneWidget);
    });
  });
}
