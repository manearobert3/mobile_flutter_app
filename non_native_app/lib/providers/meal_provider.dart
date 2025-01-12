import 'dart:async';
import 'dart:convert';

import "package:non_native_app/globals.dart";
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:non_native_app/services/database_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../AppLogger.dart';
import '../models/meal.dart';
import '../repositories/meal_repository.dart';
import 'package:http/http.dart' as http;

class MealProvider extends ChangeNotifier {
  final MealRepository _mealRepository = MealRepository();
  static const String websocketUrl = 'ws://$pcIpAddress:3001';

  Timer? _connectivityTimer;
  bool isOnline = false;
  bool isAppStart = true;
  List<Meal> _meals = [];
  String? errorMessage;
  WebSocketChannel? _channel;
  ValueNotifier<bool> isOnlineNotifier = ValueNotifier<bool>(true);

  // MealProvider() {
  //   handleConnectivityChanges();  // Check immediately on creation
  //   _startConnectivityTimer();     // Then continue checking periodically
  // }

  Future<List<Meal>?> get meals async {
    if (_meals.isEmpty) {
      _meals = await _mealRepository.getMeals();
    }
    return _meals;
  }

  void setErrorMessage(String? message) {
    errorMessage = message;
    notifyListeners();  // Notify the UI
  }
  // Check connectivity
  Future<bool> isConnected() async {
    List<ConnectivityResult> connectivityResult =
    await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.ethernet) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.other)) {
      try {
          final response = await http.get(Uri.parse('http://$pcIpAddress:3002/meals')).timeout(Duration(seconds: 1));
        if (response.statusCode == 200) {
          isOnlineNotifier.value = true;
          AppLogger.i("Connected to the backend server.");
          return true;
        }
      } catch (e) {
        isOnlineNotifier.value = false;
        AppLogger.w("Server is not reachable.");

        return false;
      }
    }

    isOnlineNotifier.value = false;
    String currentWarning = "No internet connection.";
    setErrorMessage(currentWarning);
    AppLogger.w(currentWarning);
    return false;
  }

  void _startConnectivityTimer() {
    // Cancel any existing timer before starting a new one
    _connectivityTimer?.cancel();
    _connectivityTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      handleConnectivityChanges();
    });
  }
  void setAndLogError(String message) {
    setErrorMessage(message);  // Update the UI with the error message
    AppLogger.e(message);  // Log the error
  }


  Future<void> handleConnectivityChanges({bool isAppStart = false}) async {
    final connected = await isConnected();
    if (connected != isOnline || isAppStart) {
      isOnline = connected;
      if (isOnline) {
        // Just went online: sync local changes -> server
        await syncWithTheServer();

        // Fetch the latest data from the server
        await fetchMeals();

        // Restart or start WebSocket
        startWebSocketListener();
        notifyListeners();
      } else {

        // Just went offline: close WebSocket
        _channel?.sink.close();
        setErrorMessage("Went offline, closed WebSocket connection.");
        AppLogger.i("WebSocket connection lost.");
        await fetchMeals();
      }
    }
  }

  Future<void> syncWithTheServer() async {

    final List<Map<String, dynamic>> syncQueue =
        await DatabaseHelper.getSyncQueue();
    for (var entry in syncQueue) {
      final operation = entry['operation'];
      final data = json.decode(entry['data']);
      try {
        if (operation == "create") {
          await _mealRepository.addMeal(Meal.fromJson(data));
        } else if (operation == "update") {
          final bool exists = await _mealRepository.checkMealExists(data['id']);
          if (exists) {
            await _mealRepository.updateMeal(data['id'], Meal.fromJson(data));  // Update if exists
          } else {
            setErrorMessage("Meal with ID ${data['id']} does not exist. Skipping update.");
          }
        } else if (operation == "delete") {
          final bool exists = await _mealRepository.checkMealExists(data['id']);
          AppLogger.w("does it exist and also the id: $exists, ${data['id']}");
          if (exists) {
            await _mealRepository.deleteMeal(data['id']);  // Delete if exists
          } else {
            setErrorMessage("Meal with ID ${data['id']} does not exist. Skipping delete.");
          }
        }
      } catch (e) {
        setErrorMessage("Failed to sync operation to server.");
      }
    }
    await DatabaseHelper.clearSyncQueue();
    fetchMeals();
    notifyListeners();
  }

  Future<void> fetchMeals() async {
    AppLogger.w("FETCH MEALS CALLED");
    try {
      final online = await isConnected();
      if (online) {
        _meals = await _mealRepository.getMeals();
        setErrorMessage(null);
      } else {
        _meals = await _mealRepository.getLocalMeals();
        setErrorMessage('Offline mode, using local data.');
        AppLogger.i("Offline mode active, using the local database date.");
      }
      notifyListeners();
    } catch (e) {
      setAndLogError("Error fetching meals. Offline mode now active.");
      notifyListeners();
    }
  }

  void _addMealToList(int id, Meal meal){
    _meals.add(meal.copyWith(id: id));
    notifyListeners();
  }

  Future<void> addMeal(Meal meal) async {
    int id;
    try {
      if (await isConnected()) {
        id = await _mealRepository.addMeal(meal);
        //_addMealToList(id, meal);
        await DatabaseHelper.addMeal(meal.copyWith(id: meal.id));
        AppLogger.i("Added meal to the server and local db.");
      } else {
        id = await DatabaseHelper.addMeal(meal.copyWith(id: meal.id));
        await DatabaseHelper.addToSyncQueue("create", meal.copyWith(id: meal.id).toJson());
        _addMealToList(id, meal);
        AppLogger.i("Added meal to local db only.");
      }
    } catch (e) {
      setAndLogError('Failed to add meal.');
      notifyListeners();
    }
  }

  void _updateMealFromList(int id, Meal meal){
    final index = _meals.indexWhere((m) => m.id == id);
    if (index != -1) {
      _meals[index] = meal;
    }
    notifyListeners();
  }

  Future<void> updateMeal(int id, Meal meal) async {
    try {
      if (await isConnected()) {
        await _mealRepository.updateMeal(id, meal);
        _updateMealFromList(id,meal);
        await DatabaseHelper.updateMeal(meal, id);
        AppLogger.i("Updated meal on the server and local db.");
      } else {
        await DatabaseHelper.updateMeal(meal, id);
        _updateMealFromList(id,meal);
        await DatabaseHelper.addToSyncQueue("update", meal.copyWith(id: id).toJson());
        AppLogger.i("Updated meal on local db only.");
      }
    } catch (e) {
      setAndLogError('Failed to update meal.');
      notifyListeners();
    }
  }

  void _removeMealFromList(int id) {
    _meals.removeWhere((m) => m.id == id);  // Remove meal with the specified ID
    notifyListeners();  // Notify UI about the change
  }

  Future<void> deleteMeal(int id) async {
    try {
      if (await isConnected()) {
        await _mealRepository.deleteMeal(id);
        _removeMealFromList(id);
        await DatabaseHelper.deleteMeal(id);
        AppLogger.i("Deleted meal on the server and local db.");
      } else {
        await DatabaseHelper.deleteMeal(id);
        _removeMealFromList(id);
        await DatabaseHelper.addToSyncQueue("delete", {"id": id});
        AppLogger.i("Deleted meal on local db only.");
      }
    } catch (e) {
      AppLogger.e("$e");
      setAndLogError('Failed to delete meal. Please try again later.');
      notifyListeners();
    }
  }

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void startWebSocketListener() {
    if (_channel != null) return;
    _channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

    _channel!.stream.listen(
          (message) async {
            AppLogger.i('Received WebSocket message: $message');
        final decodedMessage = json.decode(message as String);
        final operation = decodedMessage['operation'];
        final data = decodedMessage['data'];
        data['id'] = data['id'] is String ? int.parse(data['id']) : data['id'];

        if (operation == 'create') {
              Meal newMeal = Meal.fromJson(data);
              final index = _meals.indexWhere((meal) => meal.id == newMeal.id);
              AppLogger.w("the create websocket thingy with index: $index");
              if (index == -1) {
                _meals.add(newMeal);  // Add to the list only if the ID is not already present
                await DatabaseHelper.addMeal(newMeal);
              }
        } else if (operation == 'update') {
          Meal newMeal = Meal.fromJson(data);
          final index = _meals.indexWhere((meal) => meal.id == newMeal.id);
          if (index != -1) {
            _meals[index] = newMeal;
            await DatabaseHelper.updateMeal(Meal.fromJson(data),newMeal.id!);// Update local meal
          }
        } else if (operation == 'delete') {
          final index = _meals.indexWhere((meal) => meal.id == data['id']);
          if(index != -1){
            _removeMealFromList(data['id']);
            await DatabaseHelper.deleteMeal(index);
          }
        }
        notifyListeners();  // Update UI after each operation
      },
      onError: (error) {
        setAndLogError('WebSocket error: $error');
      },
      onDone: () {
        setAndLogError('WebSocket connection closed');
        handleConnectivityChanges();
      },
    );
  }

  @override
  void dispose() {
    _channel?.sink.close();  // Close WebSocket connection when provider is disposed
    super.dispose();
  }
}
