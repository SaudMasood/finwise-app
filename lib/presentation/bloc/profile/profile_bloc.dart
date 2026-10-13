
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/profile/profile.dart';
import '../../../domain/usecases/profile/profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfile getProfile;
  final SaveProfile saveProfile;
  final PickProfileImage pickProfileImage;

  ProfileBloc({
    required this.getProfile,
    required this.saveProfile,
    required this.pickProfileImage,
  }) : super(const ProfileState(isLoading: true)) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangeProfileImage>(_onChangeProfileImage);
  }

  Future<void> _onLoadProfile(
      LoadProfile event,
      Emitter<ProfileState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      final profile = await getProfile();
      emit(state.copyWith(
        isLoading: false,
        profile: profile,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event,
      Emitter<ProfileState> emit,
      ) async {
    final currentProfile = state.profile;

    if (currentProfile == null) {
      emit(state.copyWith(error: 'Profile is not loaded.'));
      return;
    }

    final updatedProfile = UserProfile(
      uid: currentProfile.uid,
      name: event.name.trim(),
      email: event.email.trim(),
      phone: event.phone.trim(),
      imagePath: currentProfile.imagePath,
    );

    emit(state.copyWith(
      isSaving: true,
      clearError: true,
      clearMessage: true,
    ));

    try {
      await saveProfile(updatedProfile);

      emit(state.copyWith(
        isSaving: false,
        profile: updatedProfile,
        message: 'Profile updated successfully.',
      ));
    } catch (error) {
      emit(state.copyWith(
        isSaving: false,
        error: error.toString(),
      ));
    }
  }

  Future<void> _onChangeProfileImage(
      ChangeProfileImage event,
      Emitter<ProfileState> emit,
      ) async {
    try {
      final imagePath = await pickProfileImage();

      if (imagePath == null) return;

      final currentProfile = state.profile;
      if (currentProfile == null) return;

      emit(state.copyWith(
        profile: currentProfile.copyWith(imagePath: imagePath),
        message: 'Profile picture updated.',
        clearError: true,
      ));
    } catch (error) {
      emit(state.copyWith(error: error.toString()));
    }
  }
}
