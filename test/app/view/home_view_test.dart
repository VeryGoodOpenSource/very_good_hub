// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
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

    testWidgets('renders a welcome message when there is a session',
        (tester) async {
      mockState(
        AppAuthenticated(
          session: Session(
            id: '1',
            userId: '1',
            token: 'token',
            expiryDate: DateTime.now().add(const Duration(days: 1)),
            createdAt: DateTime.now(),
          ),
        ),
      );
      await tester.pumpSuject(appBloc: appBloc);
      expect(find.text('Welcome 1'), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSuject({
    required AppBloc appBloc,
  }) async {
    return pumpApp(
      BlocProvider<AppBloc>.value(
        value: appBloc,
        child: HomeView(),
      ),
    );
  }
}
