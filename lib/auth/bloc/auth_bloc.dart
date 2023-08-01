import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const AuthInitial()) {
    on<AuthenticationRequested>(_onAuthenticationRequested);
    on<SignUpRequested>(_onSignUpRequested);
  }

  final AuthenticationRepository _authenticationRepository;

  Future<void> _onAuthenticationRequested(
    AuthenticationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(const AuthLoading());
      await _authenticationRepository.login(
        username: event.username,
        password: event.password,
      );
    } catch (e, s) {
      addError(e, s);
      emit(const AuthAuthenticationFailed());
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      if (event.password != event.passwordConfirm) {
        emit(const AuthSignUpFailed(error: SignUpError.passwordMismatch));
        return;
      }
      emit(const AuthLoading());
      await _authenticationRepository.signUp(
        username: event.username,
        name: event.name,
        password: event.password,
      );
      emit(const AuthSignUpSuccess());
    } catch (e, s) {
      addError(e, s);
      emit(const AuthSignUpFailed(error: SignUpError.signUpFailed));
    }
  }
}
