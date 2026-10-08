import 'package:equatable/equatable.dart';

abstract class CalendarEvent
    extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

class SelectCalendarDate
    extends CalendarEvent {
  final DateTime date;

  const SelectCalendarDate({
    required this.date,
  });

  @override
  List<Object?> get props => [date];
}