// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/home/home.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends Mock implements AppBloc {}

class _MockHomeBloc extends Mock implements HomeBloc {}

class _MockRoutePost extends Mock implements Route<Post?> {}

void main() {
  group('HomeView', () {
    late AppBloc appBloc;
    late HomeBloc homeBloc;

    void mockAppState(AppState state) {
      whenListen(
        appBloc,
        Stream.value(state),
        initialState: state,
      );
    }

    void mockHomeState(HomeState state) {
      whenListen(
        homeBloc,
        Stream.value(state),
        initialState: state,
      );
    }

    setUpAll(() {
      registerFallbackValue(_MockRoutePost());
    });

    setUp(() {
      appBloc = _MockAppBloc();
      homeBloc = _MockHomeBloc();
      mockAppState(const AppInitial());
      mockHomeState(const HomeState());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSuject(
        appBloc: appBloc,
        homeBloc: homeBloc,
      );
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets(
      'renders the profile button when there is a session',
      (tester) async {
        mockAppState(
          AppAuthenticated(sessionToken: 'TOKEN_1'),
        );
        await tester.pumpSuject(
          appBloc: appBloc,
          homeBloc: homeBloc,
        );
        expect(find.text('Profile.'), findsOneWidget);
      },
    );

    testWidgets(
      'renders the posts',
      (tester) async {
        mockAppState(
          AppAuthenticated(sessionToken: 'TOKEN_1'),
        );
        mockHomeState(
          HomeState(
            posts: const [
              Post(
                id: 'POST_1',
                userId: 'userId',
                message: 'BODY_1',
              ),
              Post(
                id: 'POST_2',
                userId: 'userId',
                message: 'BODY_2',
              ),
            ],
          ),
        );
        await tester.pumpSuject(
          appBloc: appBloc,
          homeBloc: homeBloc,
        );
        expect(find.text('BODY_1'), findsOneWidget);
        expect(find.text('BODY_2'), findsOneWidget);
      },
    );

    testWidgets(
      'renders the error snack bar when there is an error',
      (tester) async {
        mockAppState(
          AppAuthenticated(sessionToken: 'TOKEN_1'),
        );
        mockHomeState(HomeState(status: HomeStateStatus.error));
        await tester.pumpSuject(
          appBloc: appBloc,
          homeBloc: homeBloc,
        );
        await tester.pump();
        expect(find.text('Something went wrong.'), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to the profile page when the profile button is tapped',
      (tester) async {
        mockAppState(
          AppAuthenticated(sessionToken: 'TOKEN_1'),
        );

        final mockNavigator = MockNavigator();
        when(() => mockNavigator.push<void>(any())).thenAnswer(
          (_) async {},
        );

        await tester.pumpSuject(
          appBloc: appBloc,
          homeBloc: homeBloc,
          mockNavigator: mockNavigator,
        );
        await tester.tap(find.text('Profile.'));

        await tester.pump();

        verify(
          () => mockNavigator.push<void>(any()),
        ).called(1);
      },
    );

    testWidgets(
      'shows the create post dialog when FAB is pressed',
      (tester) async {
        mockAppState(
          AppAuthenticated(sessionToken: 'TOKEN_1'),
        );

        final mockNavigator = MockNavigator();
        const post = Post(
          id: 'POST_1',
          userId: 'USER_1',
          message: 'MESSAGE_1',
        );
        when(() => mockNavigator.push<Post?>(any())).thenAnswer(
          (_) async => post,
        );

        await tester.pumpSuject(
          appBloc: appBloc,
          homeBloc: homeBloc,
          mockNavigator: mockNavigator,
        );
        await tester.tap(find.byType(FloatingActionButton));

        await tester.pump();

        verify(
          () => mockNavigator.push<Post?>(any()),
        ).called(1);
        verify(
          () => homeBloc.add(HomeEventInserted(post)),
        ).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSuject({
    required AppBloc appBloc,
    required HomeBloc homeBloc,
    MockNavigator? mockNavigator,
  }) async {
    final child = MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>.value(value: appBloc),
        BlocProvider<HomeBloc>.value(value: homeBloc),
      ],
      child: const HomeView(),
    );

    return pumpApp(
      mockNavigator != null
          ? MockNavigatorProvider(navigator: mockNavigator, child: child)
          : child,
    );
  }
}
