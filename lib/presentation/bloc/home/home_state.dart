import 'package:equatable/equatable.dart';

import '../../../domain/entities/home/home.dart';

abstract class HomeState
    extends Equatable {
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

class HomeSuccess extends HomeState {
  final HomeEntity home;
  final String selectedPeriod;

  const HomeSuccess({
    required this.home,
    required this.selectedPeriod,
  });

  HomeSuccess copyWith({
    HomeEntity? home,
    String? selectedPeriod,
  }) {
    return HomeSuccess(
      home: home ?? this.home,
      selectedPeriod:
      selectedPeriod ??
          this.selectedPeriod,
    );
  }

  @override
  List<Object?> get props => [
    home,
    selectedPeriod,
  ];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure({
    required this.message,
  });

  @override
  List<Object?> get props => [
    message,
  ];
}