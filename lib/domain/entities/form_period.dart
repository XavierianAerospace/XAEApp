import 'package:equatable/equatable.dart';

/// Periodo de un formulario (tabla `form_periods`). Para formularios dinámicos
/// `sectionKey` es vacío; para Gestión Documental hay una fila por sección.
/// Un envío pertenece al periodo actual si su fecha es `>= resetAt`.
class FormPeriod extends Equatable {
  final String formType;
  final String sectionKey;
  final String frecuencia; // 'semanal' | 'mensual' | 'semestral' | 'ninguna'
  final DateTime resetAt;

  const FormPeriod({
    required this.formType,
    required this.sectionKey,
    required this.frecuencia,
    required this.resetAt,
  });

  factory FormPeriod.fromJson(Map<String, dynamic> json) {
    return FormPeriod(
      formType: json['form_type'] as String? ?? '',
      sectionKey: json['section_key'] as String? ?? '',
      frecuencia: json['frecuencia'] as String? ?? 'ninguna',
      resetAt: DateTime.tryParse(json['reset_at']?.toString() ?? '')?.toUtc() ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    );
  }

  @override
  List<Object?> get props => [formType, sectionKey, frecuencia, resetAt];
}
