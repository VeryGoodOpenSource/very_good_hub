part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();
}

class SessionLoaded extends AppEvent {
  const SessionLoaded({required this.session});

  final Session session;

  @override
  List<Object> get props => [session];
}
