import 'package:equatable/equatable.dart';

/// Registro de un envío de formulario dinámico (tabla `form_text_submissions`),
/// referenciado al usuario mediante `user_auth_id` (= auth.uid()).
class FormTextSubmission extends Equatable {
  final int id;
  final String userAuthId;
  final String formType;
  final Map<String, dynamic> answers;
  final DateTime? submittedAt;

  const FormTextSubmission({
    required this.id,
    required this.userAuthId,
    required this.formType,
    required this.answers,
    required this.submittedAt,
  });

  factory FormTextSubmission.fromJson(Map<String, dynamic> json) {
    return FormTextSubmission(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      userAuthId: json['user_auth_id'] as String? ?? '',
      formType: json['form_type'] as String? ?? '',
      answers: (json['answers'] as Map?)
              ?.map((k, v) => MapEntry(k.toString(), v)) ??
          <String, dynamic>{},
      submittedAt:
          DateTime.tryParse(json['submitted_at']?.toString() ?? '')?.toUtc(),
    );
  }

  @override
  List<Object?> get props => [id, userAuthId, formType, submittedAt];
}
