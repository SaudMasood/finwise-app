import '../../entities/saving/saving.dart';

abstract class SavingsRepository {
  Stream<List<String>> watchSavingCategories();

  Future<void> addSavingCategory({
    required String name,
    double goal = 0,
  });

  Future<double> getGoal(String category);

  Stream<List<SavingEntity>> watchSavings(String category);

  Future<void> addSaving(SavingEntity saving);
}