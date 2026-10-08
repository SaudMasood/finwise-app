
import '../../entities/saving/saving.dart';

abstract class SavingsRepository {
  Stream<List<String>> watchSavingCategories();

  Future<void> addSavingCategory({
    required String name,
    double goal,
  });

  Stream<List<SavingEntity>> watchSavings(
      String category,
      );

  Future<double> getGoal(
      String category,
      );

  Future<void> addSaving(
      SavingEntity saving,
      );
}