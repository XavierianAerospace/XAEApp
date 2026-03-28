import 'package:equatable/equatable.dart';

/// Eventos del AuthBloc
///
/// Estos eventos representan las acciones que el usuario puede desencadenar
/// relacionadas con la autenticación
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento: Solicitar login
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Evento: Solicitar logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Evento: Verificar si hay sesión activa
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}
