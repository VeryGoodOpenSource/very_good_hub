// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:very_good_hub/create_post/create_post.dart';

import '../../helpers/helpers.dart';

class _MockCreatePostBloc extends MockBloc<CreatePostEvent, CreatePostState>
    implements CreatePostBloc {}

void main() {
  group('CreatePostView', () {
    late CreatePostBloc bloc;

    void mockState(CreatePostState state) {
      whenListen(
        bloc,
        Stream.fromIterable([state]),
        initialState: state,
      );
    }

    setUp(() {
      bloc = _MockCreatePostBloc();
      mockState(const CreatePostState());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpsubject(createPostBloc: bloc);

      expect(find.byType(CreatePostView), findsOneWidget);
    });

    testWidgets('adds CreatePostSubmitted on confirming', (tester) async {
      await tester.pumpsubject(createPostBloc: bloc);

      await tester.enterText(find.byType(TextFormField), 'TEST');
      await tester.tap(find.text('Confirm'));

      verify(() => bloc.add(CreatePostSubmitted('TEST'))).called(1);
    });

    testWidgets('navigates back when cancelling', (tester) async {
      final navigator = MockNavigator();
      await tester.pumpsubject(
        createPostBloc: bloc,
        mockNavigator: navigator,
      );

      await tester.tap(find.text('Cancel'));

      verify(navigator.pop).called(1);
    });

    testWidgets('shows snackbar when the creation works', (tester) async {
      whenListen(
        bloc,
        Stream.fromIterable(
          [
            const CreatePostState(),
            const CreatePostState(
              status: CreatePostStatus.success,
              post: Post(
                id: '1',
                message: '',
                userId: '',
              ),
            ),
          ],
        ),
        initialState: const CreatePostState(),
      );
      await tester.pumpsubject(createPostBloc: bloc);
      await tester.pump();

      expect(find.text('Post created'), findsOneWidget);
    });

    testWidgets('shows is empty message', (tester) async {
      mockState(
        const CreatePostState(
          status: CreatePostStatus.failure,
          failure: CreatePostFailure.empty,
        ),
      );
      await tester.pumpsubject(createPostBloc: bloc);

      expect(find.text('Message is empty'), findsOneWidget);
    });

    testWidgets('shows too long message', (tester) async {
      mockState(
        const CreatePostState(
          status: CreatePostStatus.failure,
          failure: CreatePostFailure.tooLong,
        ),
      );
      await tester.pumpsubject(createPostBloc: bloc);

      expect(find.text('Message is too long'), findsOneWidget);
    });

    testWidgets('shows no profane words message', (tester) async {
      mockState(
        const CreatePostState(
          status: CreatePostStatus.failure,
          failure: CreatePostFailure.isProfane,
        ),
      );
      await tester.pumpsubject(createPostBloc: bloc);

      expect(find.text("Please, don't include profane words"), findsOneWidget);
    });

    testWidgets('shows generic message', (tester) async {
      mockState(
        const CreatePostState(
          status: CreatePostStatus.failure,
          failure: CreatePostFailure.unexpected,
        ),
      );
      await tester.pumpsubject(createPostBloc: bloc);

      expect(find.text('Something went wrong.'), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpsubject({
    required CreatePostBloc createPostBloc,
    MockNavigator? mockNavigator,
  }) {
    final child = BlocProvider<CreatePostBloc>.value(
      value: createPostBloc,
      child: CreatePostView(),
    );

    return pumpApp(
      Scaffold(
        body: mockNavigator != null
            ? MockNavigatorProvider(navigator: mockNavigator, child: child)
            : child,
      ),
    );
  }
}
