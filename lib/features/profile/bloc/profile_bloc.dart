import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc({required this.userRepository}) : super(const ProfileInitial()) {
    on<LoadProfileRequested>(_onLoadProfileRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onLoadProfileRequested(
    LoadProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      final user = await userRepository.getUser(event.userId);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: 'Error cargando perfil: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      final user = await userRepository.updateUser(event.userId, event.userData);
      emit(ProfileLoaded(user: user));
    } catch (e) {
      emit(ProfileError(message: 'Error actualizando perfil: ${e.toString()}'));
    }
  }
}
