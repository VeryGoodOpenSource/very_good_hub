import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_hub/app/app.dart';
import 'package:very_good_hub/create_post/create_post.dart';
import 'package:very_good_hub/home/home.dart';
import 'package:very_good_hub/l10n/l10n.dart';
import 'package:very_good_hub/profile/profile.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appBloc = context.watch<AppBloc>();
    final appState = appBloc.state;

    final homeBloc = context.watch<HomeBloc>();
    final homeState = homeBloc.state;

    if (appState is AppAuthenticated) {
      return BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state.status == HomeStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.somethingWentWrong),
              ),
            );
          }
        },
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        ProfilePage.route(),
                      );
                    },
                    child: Text(l10n.profile),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    for (final post in homeState.posts)
                      Card(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 80,
                            minWidth: 450,
                            maxWidth: 450,
                          ),
                          child: Center(child: Text(post.message)),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final bloc = context.read<HomeBloc>();
              final post = await Navigator.of(context).push(
                CreatePostPage.show(context),
              );

              if (post != null) {
                bloc.add(HomeEventInserted(post));
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
