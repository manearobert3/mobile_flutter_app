import '../models/meal.dart';

class MealRepository {
  final List<Meal> _meals = [
    Meal(
      name: 'Oatmeal with Berries',
      type: 'Meal',
      calories: 300,
      time: DateTime.now().subtract(Duration(hours: 5)),
    ),
    Meal(
      name: 'Greek Yogurt',
      type: 'Snack',
      calories: 150,
      time: DateTime.now().subtract(Duration(hours: 4)),
    ),
    Meal(
      name: 'Quinoa Salad',
      type: 'Meal',
      calories: 350,
      time: DateTime.now().subtract(Duration(hours: 2)),
    ),
    Meal(
      name: 'Almonds',
      type: 'Snack',
      calories: 170,
      time: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Meal(
      name: 'Grilled Chicken and Veggies',
      type: 'Meal',
      calories: 450,
      time: DateTime.now(),
    ),
    Meal(
      name: 'Protein Shake',
      type: 'Snack',
      calories: 200,
      time: DateTime.now().add(Duration(hours: 1)),
    ),
  ];

  List<Meal> getMeals() {
    return _meals;
  }

  void addMeal(Meal meal) {
    _meals.add(meal);
  }

  void updateMeal(int id, Meal updatedMeal) {
    final index = _meals.indexWhere((meal) => meal.id == id);
    if (index != -1) {
      _meals[index] = updatedMeal;
    }
  }

  void deleteMeal(int id) {
    _meals.removeWhere((meal) => meal.id == id);
  }
}
