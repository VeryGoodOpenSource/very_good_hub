part of 'home_bloc.dart';

enum HomeStateStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  const HomeState({
    this.posts = const [],
    this.status = HomeStateStatus.initial,
  });

  final List<Post> posts;
  final HomeStateStatus status;

  HomeState copyWith({
    List<Post>? posts,
    HomeStateStatus? status,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [posts, status];
}
