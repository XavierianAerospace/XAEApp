import 'package:equatable/equatable.dart';

abstract class PendingState extends Equatable {
  const PendingState();

  @override
  List<Object?> get props => [];
}

class PendingInitial extends PendingState {
  const PendingInitial();
}

class PendingLoading extends PendingState {
  const PendingLoading();
}

class PendingLoaded extends PendingState {
  final Map<String, List<Map<String, dynamic>>> tasksBySubsistema;

  const PendingLoaded({required this.tasksBySubsistema});

  @override
  List<Object?> get props => [tasksBySubsistema];
}

class PendingError extends PendingState {
  final String message;

  const PendingError({required this.message});

  @override
  List<Object?> get props => [message];
}
