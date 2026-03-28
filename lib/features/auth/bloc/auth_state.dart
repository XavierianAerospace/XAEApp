import 'package:equatable/equatable.dart';

/// Estados del AuthBloc
///
/// Estos estados representan los diferentes estados que puede tener la autenticación
/// y son a los que reacciona la UI
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial: No hay sesión verificada aún
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado: Cargando (verificando sesión o haciendo login)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado: Autenticado correctamente
class AuthAuthenticated extends AuthState {
  final Map<String, dynamic> user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Estado: No autenticado (sin sesión)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado: Error en la autenticación
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
