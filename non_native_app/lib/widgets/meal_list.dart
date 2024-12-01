import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import 'meal_list_item.dart';

class MealList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MealProvider>(
      builder: (context, mealProvider, child) {
        final meals = mealProvider.meals;
        if (meals.isEmpty) {
          return Center(
            child: Text('No meals added yet!'),
          );
        }
        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return MealListItem(meal: meal);
          },
        );
      },
    );
  }
}
