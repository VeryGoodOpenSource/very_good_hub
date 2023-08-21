import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/profile/profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<ProfileBloc>(
        create: (context) {
          return ProfileBloc(
            userRepository: context.read<UserRepository>(),
          )..add(const ProfileRequested());
        },
        child: const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}
