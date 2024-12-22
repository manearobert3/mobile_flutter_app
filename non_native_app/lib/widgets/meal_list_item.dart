import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../screens/edit_meal_screen.dart';

class MealListItem extends StatelessWidget {
  final Meal meal;

  MealListItem({required this.meal});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(meal.time);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 5,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.black,
          child: Text(
            meal.calories.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          meal.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(formattedDate),

        // Updated trailing widget
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit Button
            IconButton(
              icon: Text(
                '✏️',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditMealScreen(meal: meal),
                  ),
                );
              },
            ),
            // Delete Button
            IconButton(
              icon: Text(
                '🗑️',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                  _confirmDelete(context, meal.id!);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Meal'),
        content: Text('Are you sure you want to delete this meal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Provider.of<MealProvider>(context, listen: false).deleteMeal(
                    id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Meal deleted successfully!')),
                );
              }catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
              Navigator.pop(context);
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
