class Meal {

  static int global_meal_id = 0;

  int id;
  String name;
  String type;
  int calories;
  DateTime time;

  Meal({
    required this.name,
    required this.type,
    required this.calories,
    required this.time,
  }): id = _generateId() ;

  static int _generateId(){
    global_meal_id += 1;
    return global_meal_id;
  }
}
