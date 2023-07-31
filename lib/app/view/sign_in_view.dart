import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/l10n/l10n.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late final _usernameController = TextEditingController();
  late final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: BlocListener<AppBloc, AppState>(
        listenWhen: (_, current) => current is AppAuthenticationFailed,
        listener: (context, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.authenticationFailed),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/pixel_unicorn.png',
                filterQuality: FilterQuality.none,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.veryGoodHub,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                l10n.appTagline,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Card(
                child: SizedBox(
                  width: 450,
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: l10n.username,
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.password,
                          ),
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<AppBloc, AppState>(
                          builder: (context, state) {
                            return state is AppLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      context.read<AppBloc>().add(
                                            AuthenticationRequested(
                                              username:
                                                  _usernameController.text,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                    },
                                    child: Text(l10n.signIn),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
