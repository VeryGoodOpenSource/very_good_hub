import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_hub/auth/auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) {
        return AuthBloc(
          authenticationRepository: context.read<AuthenticationRepository>(),
        );
      },
      child: const AuthViewView(),
    );
  }
}
