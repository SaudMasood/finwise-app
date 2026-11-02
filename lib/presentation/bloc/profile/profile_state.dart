
import 'package:flutter/foundation.dart';

import '../../../domain/entities/profile/profile.dart';

@immutable
class ProfileState {
  final bool isLoading;
  final bool isSaving;
  final bool isImageUploading;
  final UserProfile? profile;
  final String? error;
  final String? message;

  const ProfileState({
    this.isLoading = false,
    this.isSaving = false,
    this.isImageUploading = false,
    this.profile,
    this.error,
    this.message,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSaving,
    bool? isImageUploading,
    UserProfile? profile,
    String? error,
    String? message,
    bool clearError = false,
    bool clearMessage = false,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isImageUploading: isImageUploading ?? this.isImageUploading,
      profile: profile ?? this.profile,
      error: clearError ? null : error ?? this.error,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
