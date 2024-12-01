import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';

class EditMealScreen extends StatefulWidget {
  final Meal meal;

  EditMealScreen({required this.meal});

  @override
  _EditMealScreenState createState() => _EditMealScreenState();
}

class _EditMealScreenState extends State<EditMealScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  late TextEditingController _typeController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.meal.name);
    _caloriesController = TextEditingController(text: widget.meal.calories.toString());
    _typeController = TextEditingController(text:widget.meal.type.toString());
    _selectedDate = widget.meal.time;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedMeal = Meal(
        name: _nameController.text,
        type: _typeController.text,
        calories: int.parse(_caloriesController.text),
        time: _selectedDate ?? DateTime.now(),
      );
      Provider.of<MealProvider>(context, listen: false).updateMeal(widget.meal.id, updatedMeal);
      Navigator.pop(context);
    }
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Meal'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity, // Ensure full width
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            children: [
              SizedBox(height: 40), // Add space at the top
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center inputs
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Meal Name',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none, // Remove border
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the meal name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Type Field
                    TextFormField(
                      controller: _typeController,
                      decoration: InputDecoration(
                        labelText: 'Meal Type',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none, // Remove border
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the meal type';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Calories Field
                    TextFormField(
                      controller: _caloriesController,
                      decoration: InputDecoration(
                        labelText: 'Calories',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the calories';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    // Date Field
                    GestureDetector(
                      onTap: _pickDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Date',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: _selectedDate == null
                                ? 'No Date Chosen!'
                                : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    // Submit Button
                    SizedBox(
                      width: screenWidth * 0.8, // Button width relative to screen
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: _submit,
                        child: Text(
                          'Update',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 40), // Add space at the bottom
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}