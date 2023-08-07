import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/profile/profile.dart';

import '../../helpers/helpers.dart';

class _MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('ProfilePage', () {
    testWidgets('route renders a ProfileView', (tester) async {
      await tester.pumpRoute(
        ProfilePage.route(),
        providers: [
          RepositoryProvider<UserRepository>(
            create: (_) => _MockUserRepository(),
          ),
        ],
      );

      expect(find.byType(ProfileView), findsOneWidget);
    });
  });
}
