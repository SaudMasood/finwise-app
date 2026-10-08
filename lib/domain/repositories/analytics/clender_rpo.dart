
import '../../entities/analytics/clender.dart';

abstract class CalendarRepository {
  Future<List<CalendarTransactionEntity>>
  getTransactionsByDate(
      DateTime date,
      );
}