part of 'create_post_bloc.dart';

enum CreatePostStatus {
  initial,
  submitting,
  success,
  failure,
}

class CreatePostState extends Equatable {
  const CreatePostState({
    this.status = CreatePostStatus.initial,
    this.failure,
    this.post,
  });

  final CreatePostStatus status;
  final CreatePostFailure? failure;
  final Post? post;

  CreatePostState copyWith({
    CreatePostStatus? status,
    CreatePostFailure? failure,
    Post? post,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      post: post ?? this.post,
    );
  }

  @override
  List<Object?> get props => [status, failure, post];
}
