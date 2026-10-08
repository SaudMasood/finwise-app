
import '../../../domain/entities/saving/saving.dart';
import '../../../domain/repositories/saving/saving_repo.dart';
import '../../datasources/saving.dart';
import '../../models/saving/saving.dart';

class SavingsRepositoryImpl
    implements SavingsRepository {
  final SavingsDataSource dataSource;

  SavingsRepositoryImpl({
    required this.dataSource,
  });

  @override
  Stream<List<String>> watchSavingCategories() {
    return dataSource.watchSavingCategories();
  }

  @override
  Future<void> addSavingCategory({
    required String name,
    double goal = 0,
  }) {
    return dataSource.addSavingCategory(
      name: name,
      goal: goal,
    );
  }

  @override
  Stream<List<SavingEntity>> watchSavings(
      String category,
      ) {
    return dataSource.watchSavings(category);
  }

  @override
  Future<double> getGoal(
      String category,
      ) {
    return dataSource.getGoal(category);
  }

  @override
  Future<void> addSaving(
      SavingEntity saving,
      ) {
    final model = SavingModel(
      id: saving.id,
      category: saving.category,
      title: saving.title,
      amount: saving.amount,
      message: saving.message,
      date: saving.date,
      createdAt: saving.createdAt,
    );

    return dataSource.addSaving(model);
  }
}