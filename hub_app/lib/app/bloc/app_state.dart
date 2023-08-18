part of 'app_bloc.dart';

abstract class AppState extends Equatable {
  const AppState();
}

class AppInitial extends AppState {
  const AppInitial();

  @override
  List<Object> get props => [];
}

class AppAuthenticated extends AppState {
  const AppAuthenticated({required this.session});

  final Session session;

  @override
  List<Object> get props => [session];
}
