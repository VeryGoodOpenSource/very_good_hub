import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:user_repository/user_repository.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc({
    required PostRepository postRepository,
    required UserRepository userRepository,
  })  : _postRepository = postRepository,
        _userRepository = userRepository,
        super(const CreatePostState()) {
    on<CreatePostSubmitted>(_onCreatePostSubmitted);
  }

  final PostRepository _postRepository;
  final UserRepository _userRepository;

  Future<void> _onCreatePostSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    try {
      final user = await _userRepository.getUserProfile();
      final post = await _postRepository.createPost(
        userId: user.id,
        message: event.message,
      );

      emit(
        state.copyWith(
          status: CreatePostStatus.success,
          post: post,
        ),
      );
    } on PostCreationFailure catch (e) {
      emit(
        state.copyWith(
          status: CreatePostStatus.failure,
          failure: e.reason,
        ),
      );
    } catch (e, s) {
      emit(
        state.copyWith(
          status: CreatePostStatus.failure,
          failure: CreatePostFailure.unexpected,
        ),
      );

      addError(e, s);
    }
  }
}
