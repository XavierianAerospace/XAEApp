import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// AuthBloc - Gestor de Estado para Autenticación
///
/// Este BLoC maneja toda la lógica de autenticación de la aplicación.
/// Separa completamente la UI de la lógica de negocio.
///
/// Patrón BLoC:
/// - Recibe eventos (LoginRequested, LogoutRequested, etc.)
/// - Procesa la lógica de negocio
/// - Emite nuevos estados (AuthAuthenticated, AuthError, etc.)
/// - La UI reacciona a través de BlocBuilder y BlocListener
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc({required this.apiService}) : super(const AuthInitial()) {
    /// Registrar manejador de eventos para LoginRequested
    on<LoginRequested>(_onLoginRequested);

    /// Registrar manejador de eventos para LogoutRequested
    on<LogoutRequested>(_onLogoutRequested);

    /// Registrar manejador de eventos para AuthCheckRequested
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }

  /// Manejador: Solicitud de Login
  ///
  /// Este método es llamado cuando se emite el evento LoginRequested
  /// Maneja:
  /// 1. Carga de datos (emit AuthLoading)
  /// 2. Llamada al API
  /// 3. Resultado exitoso o error
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Emitir estado de carga
    emit(const AuthLoading());

    try {
      // Llamar al API para login
      final user = await apiService.login(event.email, event.password);

      if (user != null) {
        // Login exitoso
        emit(AuthAuthenticated(user: user));
      } else {
        // Credenciales inválidas
        emit(const AuthError(message: 'Correo o contraseña incorrectos'));
      }
    } catch (e) {
      // Error en la llamada al API
      emit(AuthError(message: 'Error en login: ${e.toString()}'));
    }
  }

  /// Manejador: Solicitud de Logout
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Simplemente volver a estado no autenticado
    emit(const AuthUnauthenticated());
  }

  /// Manejador: Verificación de Autenticación
  ///
  /// Este método se llama para verificar si hay una sesión activa
  /// (útil cuando la app se abre nuevamente)
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Por ahora, simplemente no autenticado
    // En el futuro, aquí se verificaría si hay token guardado
    emit(const AuthUnauthenticated());
  }
}
