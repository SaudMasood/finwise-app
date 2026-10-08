import '../../../domain/entities/analytics/clender.dart';
import '../../../domain/repositories/analytics/clender_rpo.dart';
import '../../datasources/clenderdatasorce.dart';

class CalendarRepositoryImpl
    implements CalendarRepository {
  final CalendarDataSource dataSource;

  CalendarRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<CalendarTransactionEntity>>
  getTransactionsByDate(
      DateTime date,
      ) {
    return dataSource.getTransactionsByDate(
      date,
    );
  }
}