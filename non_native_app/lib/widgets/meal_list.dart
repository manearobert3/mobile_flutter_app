import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import 'meal_list_item.dart';

class MealList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meal>?>(
      future: Provider.of<MealProvider>(context).meals,
      builder:(context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError){
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No meals added yet!'));
        }

        final meals = snapshot.data!;
        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index){
            final meal = meals[index];
            return MealListItem(meal: meal);
        },
        );
      },
    );
  }
}