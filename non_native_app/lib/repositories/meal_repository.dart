import '../models/meal.dart';
import '../services/database_helper.dart';

class MealRepository {
  Future<List<Meal>> getMeals() async {
    try {
      return await DatabaseHelper.getAllMeal() ?? [];
    } catch (e) {
      print('Repository Error (getMeals): $e');
      throw Exception('Unable to load meals.');
    }
  }

  Future<int> addMeal(Meal meal) async {
    try {
      return await DatabaseHelper.addMeal(meal);
    } catch (e) {
      print('Repository Error (addMeal): $e');
      throw Exception('Failed to add meal.');
    }
  }

  Future<void> updateMeal(int id, Meal meal) async {
    try {
      await DatabaseHelper.updateMeal(meal, id);
    } catch (e) {
      print('Repository Error (updateMeal): $e');
      throw Exception('Failed to update meal.');
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      await DatabaseHelper.deleteMeal(id);
    } catch (e) {
      print('Repository Error (deleteMeal): $e');
      throw Exception('Failed to delete meal.');
    }
  }
}
