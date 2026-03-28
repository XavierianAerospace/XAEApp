import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileRequested extends ProfileEvent {
  final int userId;

  const LoadProfileRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileRequested extends ProfileEvent {
  final int userId;
  final Map<String, dynamic> userData;

  const UpdateProfileRequested({
    required this.userId,
    required this.userData,
  });

  @override
  List<Object?> get props => [userId, userData];
}
