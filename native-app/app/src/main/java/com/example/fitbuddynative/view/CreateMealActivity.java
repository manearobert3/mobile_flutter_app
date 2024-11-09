package com.example.fitbuddynative.view;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.lifecycle.ViewModelProvider;

import com.example.fitbuddynative.R;
import com.example.fitbuddynative.model.Meal;
import com.example.fitbuddynative.viewmodel.MealViewModel;

import java.time.LocalDate;
import java.util.Calendar;
import java.util.Objects;

public class CreateMealActivity extends AppCompatActivity {

    private EditText createMealName;
    private EditText createMealCalories;
    private EditText createMealType;
    private EditText createMealDate;
    private LocalDate dateTimeLogged;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_meal);

        createMealName = findViewById(R.id.create_meal_name);
        createMealCalories = findViewById(R.id.create_meal_calories);
        createMealType = findViewById(R.id.create_meal_type);
        createMealDate = findViewById(R.id.create_meal_date);
        createMealDate.setOnClickListener(view -> showDateTimePicker());

        findViewById(R.id.button_save).setOnClickListener(v -> saveMeal());
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        // Enable the back button
        Objects.requireNonNull(getSupportActionBar()).setDisplayHomeAsUpEnabled(true);
    }

    private void showDateTimePicker() {
        // Get current date
        final Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        // Create DatePickerDialog
        DatePickerDialog datePickerDialog = new DatePickerDialog(this,
                (view, selectedYear, selectedMonth, selectedDay) -> {
                    dateTimeLogged = LocalDate.of(selectedYear, selectedMonth + 1, selectedDay);

                    createMealDate.setText(dateTimeLogged.toString());
                }, year, month, day);
        datePickerDialog.show();
    }

    private void saveMeal() {
        String name = createMealName.getText().toString().trim();
        String type = createMealType.getText().toString().trim();
        String calories = createMealCalories.getText().toString().trim();

        // Validation
        if (name.isEmpty() || type.isEmpty() || calories.isEmpty() || dateTimeLogged == null) {
            Toast.makeText(this, "Please enter values for all fields", Toast.LENGTH_SHORT).show();
            return;
        }
        int caloriesNum;
        try {
            caloriesNum = Integer.parseInt(calories);
            if (caloriesNum < 0) {
                Toast.makeText(this, "Please enter a number greater than 0 for calories", Toast.LENGTH_SHORT).show();
                return;
            }
        } catch (NumberFormatException e) {
            Toast.makeText(this, "Please enter a number for calories", Toast.LENGTH_SHORT).show();
            return;
        }

        caloriesNum = Integer.parseInt(calories);
        Meal newMeal = new Meal(name, type, caloriesNum, dateTimeLogged);

        Intent resultIntent = new Intent();
        resultIntent.putExtra("newMeal", newMeal);
        setResult(RESULT_OK, resultIntent);


        finish();
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

}
