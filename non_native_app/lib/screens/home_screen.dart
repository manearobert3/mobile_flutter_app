import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../widgets/meal_list.dart';
import './create_meal_screen.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState(){
    super.initState();
    // Start webSocket listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(context, listen: false).startWebSocketListener();
      Provider.of<MealProvider>(context, listen: false).handleConnectivityChanges(isAppStart: true);
    });
  }
  @override
  void dispose() {
    Provider.of<MealProvider>(context, listen: false).dispose();  // Close WebSocket connection
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context, listen: false);
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text('Meals'),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: mealProvider.isOnlineNotifier,
            builder: (context, isOnline, child) {
              return Icon(
                isOnline ? Icons.wifi : Icons.wifi_off,
                color: isOnline ? Colors.green : Colors.red,
              );
            },
          ),
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
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) {
          // Show error message if available
          if (mealProvider.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(mealProvider.errorMessage!),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
              // Clear the error message after showing the SnackBar
              mealProvider.setErrorMessage(null);
            });
          }

          return MealList();  // Show the meal list as usual
        },
      ),
    );
  }
}
