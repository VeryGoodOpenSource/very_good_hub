// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:very_good_hub/app/app.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends Mock implements AppBloc {}

void main() {
  group('HomeView', () {
    late AppBloc appBloc;

    void mockState(AppState state) {
      whenListen(
        appBloc,
        Stream.value(state),
        initialState: state,
      );
    }

    setUp(() {
      appBloc = _MockAppBloc();
      mockState(const AppInitial());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSuject(appBloc: appBloc);
      expect(find.byType(HomeView), findsOneWidget);
    });

    testWidgets(
      'renders the profile button when there is a session',
      (tester) async {
        mockState(
          AppAuthenticated(sessionToken: 'TOKEN_1'),
        );
        await tester.pumpSuject(appBloc: appBloc);
        expect(find.text('Profile.'), findsOneWidget);
      },
    );

    testWidgets(
      'navigates to the profile page when the profile button is tapped',
      (tester) async {
        mockState(
          AppAuthenticated(sessionToken: 'TOKEN_1'),
        );

        final mockNavigator = MockNavigator();
        when(() => mockNavigator.push<void>(any())).thenAnswer((_) async {});

        await tester.pumpSuject(appBloc: appBloc, mockNavigator: mockNavigator);
        await tester.tap(find.text('Profile.'));

        await tester.pump();

        verify(
          () => mockNavigator.push<void>(any()),
        ).called(1);
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSuject({
    required AppBloc appBloc,
    MockNavigator? mockNavigator,
  }) async {
    final child = BlocProvider<AppBloc>.value(
      value: appBloc,
      child: HomeView(),
    );

    return pumpApp(
      mockNavigator != null
          ? MockNavigatorProvider(navigator: mockNavigator, child: child)
          : child,
    );
  }
}
