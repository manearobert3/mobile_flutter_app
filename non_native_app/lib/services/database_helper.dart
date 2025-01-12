import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/meal.dart';

class DatabaseHelper {
  static const int _version = 4;
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
          await db.execute("CREATE TABLE IF NOT EXISTS SyncQueue (id INTEGER PRIMARY KEY AUTOINCREMENT, operation TEXT NOT NULL, data TEXT NOT NULL, timestamp TEXT NOT NULL);"
          );
        }
      },
    );
  }

  static Future<void> addToSyncQueue(String operation, Map<String, dynamic> data) async {
    try {
      final db = await _getDB();
      await db.insert(
        "SyncQueue",
        {
          "operation": operation,
          "data": jsonEncode(data),  // Convert meal data to JSON string
          "timestamp": DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to add operation to SyncQueue. Error: $e');
    }
  }

  static Future<int> addMeal(Meal meal) async {
    try {
      final db = await _getDB();

      // Insert into Meal table
      int generatedId = await db.insert(
        "Meal",
        meal.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return generatedId;
    } catch (e) {
      throw Exception('Failed to add meal. Error: $e');
    }
  }

  static Future<int> updateMeal(Meal meal, int id) async {
    try {
      final db = await _getDB();

      // Update in Meal table
      return await db.update(
        "Meal",
        meal.toJson(),
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to update meal. Error: $e');
    }
  }

  static Future<int> deleteMeal(int id) async {
    try {
      final db = await _getDB();

      // Delete from Meal table
      return await db.delete(
        "Meal",
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete meal. Error: $e');
    }
  }

  static Future<List<Map<String,dynamic>>> getSyncQueue() async{
    final db = await _getDB();
    final List<Map<String,dynamic>> syncQueue = await db.query("SyncQueue");
    return syncQueue;
}

  static Future<void> printSyncQueue() async {
    final db = await _getDB();

    try {
      // Query all rows from the SyncQueue table
      final List<Map<String, dynamic>> syncQueueData = await db.query('SyncQueue');

      if (syncQueueData.isNotEmpty) {
        print('Contents of SyncQueue:');
        for (var entry in syncQueueData) {
          print(entry); // Prints each row as a Map<String, dynamic>
        }
      } else {
        print('SyncQueue is empty.');
      }
    } catch (e) {
      throw Exception('Error fetching SyncQueue: $e');
    }
  }

  static Future<List<Meal>?> getAllMeal() async {
    try {
      final db = await _getDB();
      final meals = await db.query("Meal");
      if (meals.isEmpty) return null;
      return List.generate(meals.length, (index) => Meal.fromJson(meals[index]));
    } catch (e) {
      throw Exception('Failed to retrieve meals. Error: $e');
    }
  }

  static Future<void> clearSyncQueue() async {
    try {
      final db = await _getDB();
      await db.delete("SyncQueue");
    } catch (e) {
      throw Exception('Failed to clear SyncQueue. Error: $e');
    }
  }

  static Future<void> clearMeals() async {
    final db = await _getDB();
    await db.delete("Meal");
  }

}
