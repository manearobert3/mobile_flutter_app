import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import "package:non_native_app/globals.dart";
import '../models/meal.dart';
import '../services/database_helper.dart';
import 'package:http/http.dart' as http;

class MealRepository {
  static const String serverUrl = "http://$pcIpAddress:3002/meals";


  Future<List<Meal>> getLocalMeals() async{
    try {
      return await DatabaseHelper.getAllMeal() ?? [];
    } catch(e){
      throw Exception("Failed to load meals from local database.");
    }
  }

  Future<List<Meal>> getMeals() async {
    try {
      final response = await http.get(Uri.parse(serverUrl)).timeout(const Duration(seconds: 2));
      if (response.statusCode == 200) {
        await DatabaseHelper.clearMeals();
        List<dynamic> data = json.decode(response.body);
        List<Meal> meals = data.map((json) => Meal.fromJson(json)).toList();
        for (var meal in meals) {
          await DatabaseHelper.addMeal(meal);
        }
        return meals;
      } else {
        throw Exception("Failed to load meals from server.");
      }
    } catch (e) {
      throw Exception('Server error: $e');
      // return await DatabaseHelper.getAllMeal() ?? [];
    }
  }

  Future<int> addMeal(Meal meal) async {
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(meal.toJson()),
      );
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final id = responseData['id'];
        await DatabaseHelper.addMeal(meal.copyWith(id: id));
        return id;
      } else {
        throw Exception('Failed to add meal to server.');
      }
    } catch (e) {
      throw Exception('Error adding meal: $e');
    }
  }

  Future<void> updateMeal(int id, Meal meal) async {
    try {
      final response = await http.put(
        Uri.parse('$serverUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(meal.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update meal on the server. Server is not reachable.');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteMeal(int id) async {
    try {
      final response = await http.delete(Uri.parse('$serverUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception("Failed to delete meal on the server.");
      }
    } catch (e) {
      throw Exception('Error deleting meal: $e.');
    }
  }

  Future<bool> checkMealExists(int id) async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/$id')).timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;  // Meal exists
      } else if (response.statusCode == 404) {
        return false;  // Meal not found
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      return false;  // Return false if server cannot be reached
    }
  }

}
