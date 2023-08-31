part of 'home_bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.posts = const [],
    this.loading = false,
  });

  final List<Post> posts;
  final bool loading;

  HomeState copyWith({
    List<Post>? posts,
    bool? loading,
  }) {
    return HomeState(
      posts: posts ?? this.posts,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [posts, loading];
}
