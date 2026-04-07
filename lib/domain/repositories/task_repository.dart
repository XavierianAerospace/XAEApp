import '../entities/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({String? subsistema});
  Future<Task> createTask(Map<String, dynamic> task);
  Future<void> deleteTask(int id);
}
