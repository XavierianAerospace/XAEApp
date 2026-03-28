import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/api_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiService apiService;

  ProfileBloc({required this.apiService}) : super(const ProfileInitial()) {
    on<LoadProfileRequested>(_onLoadProfileRequested);
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onLoadProfileRequested(
    LoadProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());

    try {
      final user = await apiService.getUser(event.userId);
      emit(ProfileLoaded(userData: user));
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
      final result = await apiService.updateUser(event.userId, event.userData);
      emit(ProfileLoaded(userData: result));
    } catch (e) {
      emit(ProfileError(message: 'Error actualizando perfil: ${e.toString()}'));
    }
  }
}
