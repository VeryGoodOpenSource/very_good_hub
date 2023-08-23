// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/auth/auth.dart';

import '../../helpers/helpers.dart';

class _MockAppBloc extends Mock implements AppBloc {}

class _MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  group('SignInView', () {
    late AppBloc appBloc;
    late AuthBloc authBloc;

    void mockAppState(AppState state) {
      whenListen(
        appBloc,
        Stream.value(state),
        initialState: state,
      );

      when(() => appBloc.add(any())).thenAnswer((_) {});
    }

    void mockAuthState(AuthState state) {
      whenListen(
        authBloc,
        Stream.value(state),
        initialState: state,
      );

      when(() => authBloc.add(any())).thenAnswer((_) {});
    }

    setUpAll(() {
      registerFallbackValue(
        SessionLoaded(
          sessionToken: '',
        ),
      );
      registerFallbackValue(
        AuthenticationRequested(
          username: '',
          password: '',
        ),
      );
    });

    setUp(() {
      appBloc = _MockAppBloc();
      mockAppState(const AppInitial());

      authBloc = _MockAuthBloc();
      mockAuthState(const AuthInitial());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);
      expect(find.byType(AuthViewView), findsOneWidget);
    });

    testWidgets(
      'adds [AuthenticationRequested] and clicking at sign in',
      (tester) async {
        await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);

        await tester.enterText(find.byType(TextField).first, 'username');
        await tester.enterText(find.byType(TextField).last, 'pass123');

        await tester.pump();

        await tester.tap(find.byType(ElevatedButton));

        verify(
          () => authBloc.add(
            AuthenticationRequested(username: 'username', password: 'pass123'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'shows authentication error when state is AppAuthenticationFailure',
      (tester) async {
        mockAuthState(const AuthAuthenticationFailed());
        await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);
        await tester.pump();

        expect(
          find.text('Authentication failed.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows sign panel when clicking on sign up',
      (tester) async {
        await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);
        await tester.pump();

        expect(
          find.text('Sign In'),
          findsOneWidget,
        );

        await tester.tap(find.text('Sign Up'));
        await tester.pump();

        expect(
          find.text('Sign In'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'adds [SignUpRequest] and clicking at sign up',
      (tester) async {
        await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);

        await tester.tap(find.text('Sign Up'));
        await tester.pump();

        await tester.enterText(find.byType(TextField).at(0), 'name');
        await tester.enterText(find.byType(TextField).at(1), 'username');
        await tester.enterText(find.byType(TextField).at(2), 'pass123');
        await tester.enterText(find.byType(TextField).at(3), 'pass123');

        await tester.pump();

        await tester.tap(find.byType(ElevatedButton));

        verify(
          () => authBloc.add(
            SignUpRequested(
              username: 'username',
              name: 'name',
              password: 'pass123',
              passwordConfirm: 'pass123',
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'shows sign up success when state is AuthSignUpSuccess',
      (tester) async {
        mockAuthState(
          const AuthSignUpSuccess(),
        );
        await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);
        await tester.pump();

        expect(
          find.text('Sign Up Success.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows password match error when state is AuthSignUpFailed',
      (tester) async {
        mockAuthState(
          const AuthSignUpFailed(error: SignUpError.passwordMismatch),
        );
        await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);
        await tester.pump();

        expect(
          find.text("Passwords don't match."),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'shows sign up error when state is AuthSignUpFailed',
      (tester) async {
        mockAuthState(const AuthSignUpFailed(error: SignUpError.signUpFailed));
        await tester.pumpSuject(appBloc: appBloc, authBloc: authBloc);
        await tester.pump();

        expect(
          find.text('Sign Up failed.'),
          findsOneWidget,
        );
      },
    );
  });
}

extension on WidgetTester {
  Future<void> pumpSuject({
    required AppBloc appBloc,
    required AuthBloc authBloc,
  }) async {
    return pumpApp(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>.value(value: appBloc),
          BlocProvider<AuthBloc>.value(value: authBloc),
        ],
        child: AuthViewView(),
      ),
    );
  }
}
