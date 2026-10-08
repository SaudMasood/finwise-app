import '../../entities/analytics/clender.dart';
import '../../repositories/analytics/clender_rpo.dart';

class GetCalendarTransactionsUseCase {
  final CalendarRepository repository;

  GetCalendarTransactionsUseCase({
    required this.repository,
  });

  Future<List<CalendarTransactionEntity>> call(
      DateTime date,
      ) {
    return repository.getTransactionsByDate(
      date,
    );
  }
}