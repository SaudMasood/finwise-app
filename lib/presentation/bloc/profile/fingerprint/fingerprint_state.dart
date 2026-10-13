
abstract class FingerprintState {}

class FingerprintInitial extends FingerprintState {}

class FingerprintLoading extends FingerprintState {}

class FingerprintLoaded extends FingerprintState {
  final bool enabled;
  final bool available;
  final String? label;

  FingerprintLoaded({
    required this.enabled,
    required this.available,
    this.label,
  });
}

class FingerprintSuccess extends FingerprintState {}

class FingerprintFailure extends FingerprintState {
  final String message;

  FingerprintFailure(this.message);
}
