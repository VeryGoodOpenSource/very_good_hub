part of 'create_post_bloc.dart';

abstract class CreatePostEvent extends Equatable {
  const CreatePostEvent();
}

class CreatePostSubmitted extends CreatePostEvent {
  const CreatePostSubmitted(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
