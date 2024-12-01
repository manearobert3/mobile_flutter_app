import 'package:flutter/material.dart';
import '../widgets/meal_list.dart';
import './create_meal_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(), // Optional: Add a drawer if needed
      appBar: AppBar(
        title: Text('Meals'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateMealScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: MealList(),
    );
  }
}
