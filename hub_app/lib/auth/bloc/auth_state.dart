part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  List<Object> get props => [];
}

class AuthAuthenticationFailed extends AuthState {
  const AuthAuthenticationFailed();

  @override
  List<Object> get props => [];
}

enum SignUpError {
  passwordMismatch,
  signUpFailed,
}

class AuthSignUpFailed extends AuthState {
  const AuthSignUpFailed({
    required this.error,
  });

  final SignUpError error;

  @override
  List<Object> get props => [error];
}

class AuthSignUpSuccess extends AuthState {
  const AuthSignUpSuccess();

  @override
  List<Object> get props => [];
}
