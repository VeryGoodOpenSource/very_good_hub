import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/create_post/create_post.dart';

import '../../helpers/helpers.dart';

class _MockUserRepository extends Mock implements UserRepository {}

class _MockPostRepository extends Mock implements PostRepository {}

void main() {
  group('CreatePostPage', () {
    testWidgets('route renders a CreatePostView', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: MultiRepositoryProvider(
            providers: [
              RepositoryProvider<UserRepository>(
                create: (_) => _MockUserRepository(),
              ),
              RepositoryProvider<PostRepository>(
                create: (_) => _MockPostRepository(),
              ),
            ],
            child: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CreatePostPage.show(context),
                    );
                  },
                  child: const Text('Open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(CreatePostView), findsOneWidget);
    });
  });
}
