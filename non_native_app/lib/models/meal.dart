class Meal {

  int? id;
  String name;
  String type;
  int calories;
  DateTime time;

  Meal({
    this.id,
    required this.name,
    required this.type,
    required this.calories,
    required this.time,
  });

  factory Meal.fromJson(Map<String,dynamic> json) => Meal(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    calories: json['calories'],
    time: DateTime.parse(json['time']),
  );

  Map<String,dynamic> toJson() =>{
    if (id != null) 'id': id,
    'name': name,
    'type' : type,
    'calories': calories,
    'time': time.toIso8601String(),
  };
  Meal copyWith({
    int? id,
    String? name,
    String? type,
    int? calories,
    DateTime? time,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      calories: calories ?? this.calories,
      time: time ?? this.time,
    );
  }
}
