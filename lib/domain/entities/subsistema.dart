import 'package:equatable/equatable.dart';

class Subsistema extends Equatable {
  final int id;
  final String nombre;

  const Subsistema({
    required this.id,
    required this.nombre,
  });

  factory Subsistema.fromJson(Map<String, dynamic> json) {
    return Subsistema(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }

  @override
  List<Object?> get props => [id, nombre];
}
