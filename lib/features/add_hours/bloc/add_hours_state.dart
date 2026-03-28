import 'package:equatable/equatable.dart';

abstract class AddHoursState extends Equatable {
  const AddHoursState();

  @override
  List<Object?> get props => [];
}

class AddHoursInitial extends AddHoursState {
  const AddHoursInitial();
}

class AddHoursLoading extends AddHoursState {
  const AddHoursLoading();
}

class AddHoursSuccess extends AddHoursState {
  const AddHoursSuccess();
}

class AddHoursError extends AddHoursState {
  final String message;

  const AddHoursError({required this.message});

  @override
  List<Object?> get props => [message];
}
