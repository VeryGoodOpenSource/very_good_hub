part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class AuthenticationRequested extends AppEvent {
  const AuthenticationRequested({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class SessionLoaded extends AppEvent {
  const SessionLoaded({required this.session});

  final Session session;

  @override
  List<Object> get props => [session];
}
