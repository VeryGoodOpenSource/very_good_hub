// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_hub/app/app.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends Mock implements AppBloc {}

void main() {
  group('SignInView', () {
    late AppBloc appBloc;

    void mockState(AppState state) {
      whenListen(
        appBloc,
        Stream.value(state),
        initialState: state,
      );

      when(() => appBloc.add(any())).thenAnswer((_) {});
    }

    setUpAll(() {
      registerFallbackValue(
        AuthenticationRequested(
          username: '',
          password: '',
        ),
      );
    });

    setUp(() {
      appBloc = _MockAppBloc();
      mockState(const AppInitial());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSuject(appBloc: appBloc);
      expect(find.byType(SignInView), findsOneWidget);
    });

    testWidgets(
      'adds [AuthenticationRequested] and clicking at sign in',
      (tester) async {
        await tester.pumpSuject(appBloc: appBloc);

        await tester.enterText(find.byType(TextField).first, 'username');
        await tester.enterText(find.byType(TextField).last, 'pass123');

        await tester.pump();

        await tester.tap(find.byType(ElevatedButton));

        verify(
          () => appBloc.add(
            AuthenticationRequested(username: 'username', password: 'pass123'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'shows authentication error when state is AppAuthenticationFailure',
      (tester) async {
        mockState(const AppAuthenticationFailed());
        await tester.pumpSuject(appBloc: appBloc);
        await tester.pump();

        expect(
          find.text('Authentication failed.'),
          findsOneWidget,
        );
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSuject({
    required AppBloc appBloc,
  }) async {
    return pumpApp(
      BlocProvider<AppBloc>.value(
        value: appBloc,
        child: SignInView(),
      ),
    );
  }
}
