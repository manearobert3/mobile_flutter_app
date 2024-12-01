import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../repositories/meal_repository.dart';

class MealProvider extends ChangeNotifier {
  final MealRepository _mealRepository = MealRepository();

  List<Meal> get meals => _mealRepository.getMeals();

  void addMeal(Meal meal) {
    _mealRepository.addMeal(meal);
    notifyListeners();
  }

  void updateMeal(int id, Meal meal) {

    _mealRepository.updateMeal(id, meal);
    notifyListeners();
  }

  void deleteMeal(int id) {
    _mealRepository.deleteMeal(id);
    notifyListeners();
  }
}
