import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final int id;
  final String nombre;
  final bool activo;

  const Member({
    required this.id,
    required this.nombre,
    required this.activo,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] as String? ?? '',
      activo: json['activo'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'activo': activo,
    };
  }

  @override
  List<Object?> get props => [id, nombre, activo];
}
