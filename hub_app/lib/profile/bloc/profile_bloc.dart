import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onProfileRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(const ProfileLoadInProgress());
      final user = await _userRepository.getUserProfile();
      emit(ProfileLoaded(user));
    } catch (e, s) {
      addError(e, s);
      emit(const ProfileLoadFailure());
    }
  }
}
