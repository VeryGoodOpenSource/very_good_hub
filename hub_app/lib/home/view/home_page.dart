import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:very_good_hub/home/home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) {
        return HomeBloc(postRepository: context.read<PostRepository>())
          ..add(const HomeEventLoaded());
      },
      child: const HomeView(),
    );
  }
}
