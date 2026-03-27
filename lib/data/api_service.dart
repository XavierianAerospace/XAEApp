/// Interface que define todos los métodos del API.
/// Cuando tengan el backend real, solo necesitan crear otra implementación
/// de esta misma interface apuntando al servidor real.
abstract class ApiService {
  /// Login: busca un usuario por email y password.
  /// Retorna el Map del usuario si las credenciales son correctas, null si no.
  Future<Map<String, dynamic>?> login(String email, String password);

  /// Obtiene todas las tareas. Opcionalmente filtra por subsistema.
  Future<List<Map<String, dynamic>>> getTasks({String? subsistema});

  /// Crea una nueva tarea.
  Future<Map<String, dynamic>> createTask(Map<String, dynamic> task);

  /// Elimina (completa) una tarea por su ID.
  Future<void> deleteTask(int id);

  /// Obtiene la lista de miembros activos.
  Future<List<Map<String, dynamic>>> getMembers();

  /// Obtiene un usuario por su ID.
  Future<Map<String, dynamic>> getUser(int id);

  /// Actualiza un usuario por su ID.
  Future<Map<String, dynamic>> updateUser(int id, Map<String, dynamic> data);

  /// Obtiene la lista de piezas disponibles en inventario.
  Future<List<Map<String, dynamic>>> getItems();

  /// Obtiene la lista de piezas registradas (apartadas).
  Future<List<Map<String, dynamic>>> getRegisteredItems();

  /// Obtiene la lista de subsistemas disponibles.
  Future<List<Map<String, dynamic>>> getSubsistemas();
}
