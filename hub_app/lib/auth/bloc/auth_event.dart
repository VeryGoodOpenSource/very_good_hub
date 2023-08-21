part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class AuthenticationRequested extends AuthEvent {
  const AuthenticationRequested({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object> get props => [username, password];
}

class SignUpRequested extends AuthEvent {
  const SignUpRequested({
    required this.username,
    required this.name,
    required this.password,
    required this.passwordConfirm,
  });

  final String username;
  final String name;
  final String password;
  final String passwordConfirm;

  @override
  List<Object> get props => [
        username,
        name,
        password,
        passwordConfirm,
      ];
}
