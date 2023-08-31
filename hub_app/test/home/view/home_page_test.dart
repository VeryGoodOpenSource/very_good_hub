// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/home/home.dart';

import '../../helpers/helpers.dart';

class _MockPostRepository extends Mock implements PostRepository {}

class _MockAppBloc extends Mock implements AppBloc {}

void main() {
  group('HomePage', () {
    late PostRepository postRepository;
    late AppBloc appBloc;

    void mockAppState(AppState state) {
      whenListen(
        appBloc,
        Stream.value(state),
        initialState: state,
      );
    }

    setUp(() {
      postRepository = _MockPostRepository();
      when(postRepository.listHomePosts).thenAnswer((_) async => []);
      appBloc = _MockAppBloc();
      mockAppState(const AppInitial());
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSuject(
        postRepository: postRepository,
        appBloc: appBloc,
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpSuject({
    required PostRepository postRepository,
    required AppBloc appBloc,
  }) async {
    return pumpApp(
      BlocProvider<AppBloc>.value(
        value: appBloc,
        child: RepositoryProvider<PostRepository>.value(
          value: postRepository,
          child: HomePage(),
        ),
      ),
    );
  }
}
