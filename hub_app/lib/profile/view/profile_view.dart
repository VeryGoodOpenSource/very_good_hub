import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_hub/l10n/l10n.dart';
import 'package:very_good_hub/profile/profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<ProfileBloc>().state;

    if (state is ProfileLoadInProgress) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is ProfileLoaded) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Text('Name: ${state.user.name}'),
              Text('Username: ${state.user.username}'),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text(l10n.somethingWentWrong),
        ),
      );
    }
  }
}
