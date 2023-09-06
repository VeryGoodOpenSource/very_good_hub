import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:user_repository/user_repository.dart';
import 'package:very_good_hub/create_post/create_post.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  static Route<Post?> show(
    BuildContext context,
  ) {
    return DialogRoute<Post?>(
      context: context,
      builder: (_) => BlocProvider<CreatePostBloc>(
        create: (_) => CreatePostBloc(
          postRepository: context.read<PostRepository>(),
          userRepository: context.read<UserRepository>(),
        ),
        child: const CreatePostPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CreatePostView();
  }
}
