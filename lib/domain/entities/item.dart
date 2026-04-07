import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final int id;
  final String nombre;
  final int cantidad;

  const Item({
    required this.id,
    required this.nombre,
    required this.cantidad,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] as String? ?? '',
      cantidad: json['cantidad'] is int
              ? json['cantidad']
              : int.tryParse(json['cantidad']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'cantidad': cantidad,
    };
  }

  @override
  List<Object?> get props => [id, nombre, cantidad];
}

class RegisteredItem extends Equatable {
  final int id;
  final String nombre;
  final String codigo;
  final String apartadoPor;
  final String fecha;
  final int cantidad;

  const RegisteredItem({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.apartadoPor,
    required this.fecha,
    required this.cantidad,
  });

  factory RegisteredItem.fromJson(Map<String, dynamic> json) {
    return RegisteredItem(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nombre: json['nombre'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      apartadoPor: json['apartadoPor'] as String? ?? '',
      fecha: json['fecha'] as String? ?? '',
      cantidad: json['cantidad'] is int
              ? json['cantidad']
              : int.tryParse(json['cantidad']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'apartadoPor': apartadoPor,
      'fecha': fecha,
      'cantidad': cantidad,
    };
  }

  @override
  List<Object?> get props => [id, nombre, codigo];
}
