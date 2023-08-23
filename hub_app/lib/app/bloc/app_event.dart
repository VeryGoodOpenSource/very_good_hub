part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class SessionLoaded extends AppEvent {
  const SessionLoaded({required this.sessionToken});

  final String sessionToken;

  @override
  List<Object> get props => [sessionToken];
}

class SessionLoggedOff extends AppEvent {
  const SessionLoggedOff();

  @override
  List<Object> get props => [];
}
