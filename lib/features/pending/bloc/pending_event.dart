import 'package:equatable/equatable.dart';

abstract class PendingEvent extends Equatable {
  const PendingEvent();

  @override
  List<Object?> get props => [];
}

class LoadPendingRequested extends PendingEvent {
  final int userId;

  const LoadPendingRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CreateTaskRequested extends PendingEvent {
  final Map<String, dynamic> task;

  const CreateTaskRequested({required this.task});

  @override
  List<Object?> get props => [task];
}

class DeleteTaskRequested extends PendingEvent {
  final int taskId;

  const DeleteTaskRequested({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}
