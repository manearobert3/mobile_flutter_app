package com.example.fitbuddynative.view;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import com.example.fitbuddynative.R;
import com.example.fitbuddynative.model.Meal;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Objects;

public class UpdateMealActivity extends AppCompatActivity {

    private EditText editMealName;
    private EditText editMealCalories;
    private EditText editMealType;
    private EditText editMealDate;
    private LocalDate dateTimeLogged;
    private Meal mealToEdit;
    private int position;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_update_meal);

        editMealName = findViewById(R.id.edit_meal_name);
        editMealCalories = findViewById(R.id.edit_meal_calories);
        editMealType = findViewById(R.id.edit_meal_type);
        editMealDate = findViewById(R.id.edit_meal_date);

        // Get the meal and position from the Intent
        Intent intent = getIntent();
        mealToEdit = (Meal) intent.getSerializableExtra("mealToEdit");
        position = intent.getIntExtra("position", -1);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        Objects.requireNonNull(getSupportActionBar()).setDisplayHomeAsUpEnabled(true);

        if (mealToEdit != null) {
            populateFields(mealToEdit);
        } else {
            Toast.makeText(this, "Error loading meal data", Toast.LENGTH_SHORT).show();
            finish();
        }

        editMealDate.setOnClickListener(view -> showDatePicker());

        findViewById(R.id.button_save).setOnClickListener(v -> updateMeal());
    }

    private void populateFields(Meal meal) {
        editMealName.setText(meal.getName());
        editMealCalories.setText(String.valueOf(meal.getTotal_calories()));
        editMealType.setText(meal.getMeal_type());
        dateTimeLogged = meal.getDate_logged();

        // Format and display the date
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        editMealDate.setText(dateTimeLogged.format(formatter));
    }

    private void showDatePicker() {
        final Calendar calendar = Calendar.getInstance();
        calendar.set(dateTimeLogged.getYear(), dateTimeLogged.getMonthValue() - 1, dateTimeLogged.getDayOfMonth());

        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        DatePickerDialog datePickerDialog = new DatePickerDialog(this,
                (view, selectedYear, selectedMonth, selectedDay) -> {
                    // Store the selected date
                    dateTimeLogged = LocalDate.of(selectedYear, selectedMonth + 1, selectedDay);
                    // Display the selected date in the EditText
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    editMealDate.setText(dateTimeLogged.format(formatter));
                }, year, month, day);
        datePickerDialog.show();
    }

    private void updateMeal() {
        String name = editMealName.getText().toString().trim();
        String type = editMealType.getText().toString().trim();
        String calories = editMealCalories.getText().toString().trim();

        // Validation
        if (name.isEmpty() || type.isEmpty() || calories.isEmpty()) {
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
            Toast.makeText(this, "Please enter a valid number for calories", Toast.LENGTH_SHORT).show();
            return;
        }

        mealToEdit.setName(name);
        mealToEdit.setMeal_type(type);
        mealToEdit.setTotal_calories(caloriesNum);
        mealToEdit.setDate_logged(dateTimeLogged);

        // Prepare the result intent
        Intent resultIntent = new Intent();
        resultIntent.putExtra("updatedMeal", mealToEdit);
        resultIntent.putExtra("position", position);
        setResult(RESULT_OK, resultIntent);

        finish();
    }

    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            // Back button pressed
            finish(); // Close the current activity
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
