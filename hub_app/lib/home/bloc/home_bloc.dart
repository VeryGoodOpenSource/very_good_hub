import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required PostRepository postRepository,
  })  : _postRepository = postRepository,
        super(const HomeState()) {
    on<HomeEventLoaded>(_onLoaded);
    on<HomeEventInserted>(_onInserted);
  }

  final PostRepository _postRepository;

  Future<void> _onLoaded(
    HomeEventLoaded event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HomeStateStatus.loading));
      final posts = await _postRepository.listHomePosts();
      emit(state.copyWith(posts: posts, status: HomeStateStatus.loaded));
    } catch (e, s) {
      addError(e, s);
      emit(state.copyWith(status: HomeStateStatus.error));
    }
  }

  Future<void> _onInserted(
    HomeEventInserted event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        posts: [
          event.post,
          ...state.posts,
        ],
      ),
    );
  }
}
