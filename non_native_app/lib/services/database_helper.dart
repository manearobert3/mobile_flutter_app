import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/meal.dart';

class DatabaseHelper {
  static const int _version = 3;
  static const String _dbName = "Meals.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      version: _version,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE Meal(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, type TEXT NOT NULL, calories INTEGER, time TEXT NOT NULL)");

        await db.insert("Meal", {
          'name': 'Pasta',
          'type': 'Lunch',
          'calories': 600,
          'time': DateTime.now().toIso8601String(),
        });
        await db.insert("Meal", {
          'name': 'Salad',
          'type': 'Dinner',
          'calories': 300,
          'time': DateTime.now().toIso8601String(),
        });
        await db.insert("Meal", {
          'name': 'Smoothie',
          'type': 'Breakfast',
          'calories': 200,
          'time': DateTime.now().toIso8601String(),
        });
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // Add mock data during an upgrade
          await db.insert("Meal", {
            'name': 'Pasta',
            'type': 'Lunch',
            'calories': 600,
            'time': DateTime.now().toIso8601String(),
          });
          await db.insert("Meal", {
            'name': 'Salad',
            'type': 'Dinner',
            'calories': 300,
            'time': DateTime.now().toIso8601String(),
          });
        }
      },
    );
  }

  static Future<int> addMeal(Meal meal) async {
    try {
      final db = await _getDB();
      return await db.insert(
        "Meal",
        meal.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Database Error (addMeal): $e');
      throw Exception('Failed to add meal.');
    }
  }

  static Future<int> updateMeal(Meal meal, int id) async {
    final db = await _getDB();
    return await db.update("Meal", meal.toJson(),
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteMeal(int id) async {
    final db = await _getDB();
    return await db.delete(
      "Meal",
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Meal>?> getAllMeal() async {
    try {
      final db = await _getDB();
      final meals = await db.query("Meal");
      if (meals.isEmpty) return null;
      return List.generate(meals.length, (index) => Meal.fromJson(meals[index]));
    } catch (e) {
      print('Database Error (getAllMeal): $e');
      throw Exception('Failed to retrieve meals.');
    }
  }
}
