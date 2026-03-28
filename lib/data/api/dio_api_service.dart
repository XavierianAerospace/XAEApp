import 'package:dio/dio.dart';
import '../api_service.dart';
import '../config.dart';

/// Implementación del ApiService usando Dio para conectar al json-server.
/// Cuando tengan el backend real, pueden:
/// 1. Cambiar solo la URL en config.dart, o
/// 2. Crear otra clase que implemente ApiService con la lógica del servidor real.
class DioApiService implements ApiService {
  final Dio _dio;

  DioApiService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        );

  @override
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      // Filtramos solo por email porque json-server v1 no soporta
      // filtrado por múltiples campos simultáneamente.
      // El password se valida en el cliente (solo para el mock server).
      final response = await _dio.get(
        '/users',
        queryParameters: {'email': email},
      );
      final List<dynamic> users = response.data;
      if (users.isNotEmpty) {
        final user = Map<String, dynamic>.from(users.first);
        if (user['password'] == password) {
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getTasks({String? subsistema}) async {
    try {
      final Map<String, dynamic> params = {};
      if (subsistema != null) {
        params['subsistema'] = subsistema;
      }
      final response = await _dio.get('/tasks', queryParameters: params);
      final List<dynamic> data = response.data;
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error al obtener tareas: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> task) async {
    try {
      final response = await _dio.post('/tasks', data: task);
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('Error al crear tarea: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('/tasks/$id');
    } catch (e) {
      print('Error al eliminar tarea: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMembers() async {
    try {
      final response = await _dio.get('/members');
      final List<dynamic> data = response.data;
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error al obtener miembros: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getUser(int id) async {
    try {
      final response = await _dio.get('/users/$id');
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('Error al obtener usuario: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateUser(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put('/users/$id', data: data);
      return Map<String, dynamic>.from(response.data);
    } catch (e) {
      print('Error al actualizar usuario: $e');
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final response = await _dio.get('/items');
      final List<dynamic> data = response.data;
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error al obtener items: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRegisteredItems() async {
    try {
      final response = await _dio.get('/registeredItems');
      final List<dynamic> data = response.data;
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error al obtener items registrados: $e');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSubsistemas() async {
    try {
      final response = await _dio.get('/subsistemas');
      final List<dynamic> data = response.data;
      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      print('Error al obtener subsistemas: $e');
      return [];
    }
  }
}
