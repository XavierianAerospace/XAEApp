import 'package:equatable/equatable.dart';

abstract class AddHoursEvent extends Equatable {
  const AddHoursEvent();

  @override
  List<Object?> get props => [];
}

class AddHoursRequested extends AddHoursEvent {
  final int userId;
  final double hours;

  const AddHoursRequested({
    required this.userId,
    required this.hours,
  });

  @override
  List<Object?> get props => [userId, hours];
}
