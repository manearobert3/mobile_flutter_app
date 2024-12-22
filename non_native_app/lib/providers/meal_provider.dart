import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../repositories/meal_repository.dart';

class MealProvider extends ChangeNotifier {
  final MealRepository _mealRepository = MealRepository();
  List<Meal> _meals = [];

  Future<List<Meal>?> get meals async {
    if (_meals.isEmpty) {
      _meals = await _mealRepository.getMeals();
    }
    return _meals;
  }

  Future<void> addMeal(Meal meal) async {
    try {
      final id = await _mealRepository.addMeal(meal);
      _meals.add(meal.copyWith(id: id));
      notifyListeners();
    }
    catch (e) {
      throw Exception('Failed to add meal. Please try again.');
    }
  }

  Future<void> updateMeal(int id, Meal meal) async {
    try {
      await _mealRepository.updateMeal(id, meal);
      final index = _meals.indexWhere((m) => m.id == id);
      if (index != -1) {
        _meals[index] = meal;
        notifyListeners();
      }
    }
    catch (e) {
      throw Exception('Failed to update meal. Please try again.');
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      await _mealRepository.deleteMeal(id);
      _meals.removeWhere((m) => m.id == id);
      notifyListeners();
    }
    catch (e) {
      throw Exception('Failed to delete meal. Please try again.');
    }
  }
}
