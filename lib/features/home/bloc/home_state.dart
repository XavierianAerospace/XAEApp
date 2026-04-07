import 'package:equatable/equatable.dart';
import '../../../domain/entities/member.dart';
import '../../../domain/entities/task.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Task> tasks;
  final List<Member> activeMembers;

  const HomeLoaded({
    required this.tasks,
    required this.activeMembers,
  });

  @override
  List<Object?> get props => [tasks, activeMembers];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
