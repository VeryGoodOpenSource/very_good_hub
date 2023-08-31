import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:token_provider/token_provider.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/auth/auth.dart';
import 'package:very_good_hub/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    required this.postRepository,
    required this.userRepository,
    required this.tokenProvider,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;
  final TokenProvider tokenProvider;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: authenticationRepository,
        ),
        RepositoryProvider.value(
          value: postRepository,
        ),
        RepositoryProvider.value(
          value: userRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => AppBloc(
          authenticationRepository: authenticationRepository,
          tokenProvider: tokenProvider,
          userRepository: userRepository,
        ),
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
            colorScheme: ColorScheme.fromSwatch(
              accentColor: const Color(0xFF13B9FF),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              final appState = context.watch<AppBloc>().state;
              return (appState is AppAuthenticated)
                  ? const HomeView()
                  : const AuthPage();
            },
          ),
        ),
      ),
    );
  }
}
