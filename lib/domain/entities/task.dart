import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String titulo;
  final String urgencia;
  final String fecha;
  final String subsistema;
  final String descripcion;
  final String nombreCreador;

  const Task({
    required this.id,
    required this.titulo,
    required this.urgencia,
    required this.fecha,
    required this.subsistema,
    required this.descripcion,
    required this.nombreCreador,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      titulo: json['titulo'] as String? ?? '',
      urgencia: json['urgencia'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '',
      subsistema: json['subsistema'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      nombreCreador: json['nombreCreador'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'urgencia': urgencia,
      'fecha': fecha,
      'subsistema': subsistema,
      'descripcion': descripcion,
      'nombreCreador': nombreCreador,
    };
  }

  @override
  List<Object?> get props => [id, titulo, subsistema];
}
