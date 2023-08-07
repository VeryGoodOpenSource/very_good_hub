part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object> get props => [];
}

class ProfileLoadInProgress extends ProfileState {
  const ProfileLoadInProgress();
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class ProfileLoadFailure extends ProfileState {
  const ProfileLoadFailure();

  @override
  List<Object> get props => [];
}
