part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class EmailLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const EmailLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class EmailRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;

  const EmailRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  List<Object> get props => [email, password, username];
}

class GoogleLoginRequested extends AuthEvent {
  @override
  List<Object> get props => [];
}

class FacebookLoginRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}