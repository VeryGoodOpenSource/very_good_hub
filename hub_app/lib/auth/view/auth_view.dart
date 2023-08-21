import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_hub/auth/auth.dart';
import 'package:very_good_hub/l10n/l10n.dart';

class AuthViewView extends StatefulWidget {
  const AuthViewView({super.key});

  @override
  State<AuthViewView> createState() => _AuthViewViewState();
}

class _AuthViewViewState extends State<AuthViewView> {
  late final _usernameController = TextEditingController();
  late final _nameController = TextEditingController();
  late final _passwordController = TextEditingController();
  late final _passwordConfirmController = TextEditingController();

  bool _signIn = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticationFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.authenticationFailed),
              ),
            );
          } else if (state is AuthSignUpFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error == SignUpError.passwordMismatch
                      ? l10n.passwordDontMatch
                      : l10n.signUpFailed,
                ),
              ),
            );
          } else if (state is AuthSignUpSuccess) {
            _usernameController.clear();
            _nameController.clear();
            _passwordController.clear();
            _passwordConfirmController.clear();
            setState(() {
              _signIn = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.signUpSuccess),
              ),
            );
          }
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
              if (_signIn)
                Card(
                  child: SizedBox(
                    width: 450,
                    height: 300,
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
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return state is AuthLoading
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            context.read<AuthBloc>().add(
                                                  AuthenticationRequested(
                                                    username:
                                                        _usernameController
                                                            .text,
                                                    password:
                                                        _passwordController
                                                            .text,
                                                  ),
                                                );
                                          },
                                          child: Text(l10n.signIn),
                                        ),
                                        const Divider(),
                                        Text(l10n.or),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _signIn = false;
                                            });
                                          },
                                          child: Text(l10n.signUp),
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Card(
                  child: SizedBox(
                    width: 450,
                    height: 320,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: l10n.name,
                            ),
                          ),
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
                          TextField(
                            controller: _passwordConfirmController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: l10n.confirmPassword,
                            ),
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return state is AuthLoading
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            final password =
                                                _passwordController.text;
                                            final passwordConfirm =
                                                _passwordConfirmController.text;

                                            context.read<AuthBloc>().add(
                                                  SignUpRequested(
                                                    username:
                                                        _usernameController
                                                            .text,
                                                    name: _nameController.text,
                                                    password: password,
                                                    passwordConfirm:
                                                        passwordConfirm,
                                                  ),
                                                );
                                          },
                                          child: Text(l10n.signUp),
                                        ),
                                      ],
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
