import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:very_good_hub/create_post/create_post.dart';
import 'package:very_good_hub/l10n/l10n.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({super.key});

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  late final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Dialog(
      child: SizedBox(
        width: 400,
        height: 200,
        child: BlocConsumer<CreatePostBloc, CreatePostState>(
          listener: (context, state) {
            if (state.status == CreatePostStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.postCreated),
                ),
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: l10n.message,
                      errorText: state.failure?.toMessage(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(l10n.cancel),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CreatePostBloc>().add(
                                CreatePostSubmitted(_messageController.text),
                              );
                        },
                        child: Text(l10n.confirm),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension on CreatePostFailure {
  String toMessage(BuildContext context) {
    final l10n = context.l10n;

    return switch (this) {
      CreatePostFailure.empty => l10n.messageIsEmpty,
      CreatePostFailure.tooLong => l10n.messageIsTooLong,
      CreatePostFailure.isProfane => l10n.noProfaneWords,
      CreatePostFailure.unexpected => l10n.somethingWentWrong,
    };
  }
}
