part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class HomeEventLoaded extends HomeEvent {
  const HomeEventLoaded();

  @override
  List<Object?> get props => [];
}

class HomeEventInserted extends HomeEvent {
  const HomeEventInserted(this.post);

  final Post post;

  @override
  List<Object?> get props => [post];
}
