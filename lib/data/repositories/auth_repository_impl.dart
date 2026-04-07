import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../api_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<User?> login(String email, String password) async {
    final result = await _apiService.login(email, password);
    if (result == null) return null;
    return User.fromJson(result);
  }

  @override
  Future<void> logout() async {
    // No hay endpoint de logout en el mock server.
    // Aquí se limpiarían tokens almacenados localmente.
  }
}
