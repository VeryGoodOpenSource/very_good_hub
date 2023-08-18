import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/l10n/l10n.dart';
import 'package:very_good_hub/profile/profile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appBloc = context.watch<AppBloc>();
    final state = appBloc.state;

    if (state is AppAuthenticated) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                ProfilePage.route(),
              );
            },
            child: Text(l10n.profile),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
