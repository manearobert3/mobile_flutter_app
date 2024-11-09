package com.example.fitbuddynative.view;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.Toolbar;

import android.content.Intent;
import android.os.Bundle;

import com.example.fitbuddynative.R;
import com.example.fitbuddynative.model.Meal;
import com.example.fitbuddynative.viewmodel.MealViewModel;

import androidx.appcompat.app.AppCompatActivity;


import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;


import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;


public class MainActivity extends AppCompatActivity implements MealAdapter.OnItemClickListener{

    private ActivityResultLauncher<Intent> createMealActivityResultLauncher;
    private ActivityResultLauncher<Intent> updateMealActivityResultLauncher;
    private MealViewModel mealViewModel;
    private MealAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        RecyclerView recyclerView = findViewById(R.id.recycler_view1);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));


        createMealActivityResultLauncher = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    if (result.getResultCode() == RESULT_OK) {
                        Intent data = result.getData();
                        if (data != null) {
                            Meal newMeal = (Meal) data.getSerializableExtra("newMeal");
                            mealViewModel.addMeal(newMeal);
                        }
                    }
                }
        );
        updateMealActivityResultLauncher = registerForActivityResult(
                new ActivityResultContracts.StartActivityForResult(),
                result -> {
                    if (result.getResultCode() == RESULT_OK) {
                        Intent data = result.getData();
                        if (data != null) {
                            Meal updatedMeal = (Meal) data.getSerializableExtra("updatedMeal");
                            int position = data.getIntExtra("position", -1);
                            if (position != -1) {
                                mealViewModel.updateMeal(position, updatedMeal);
                            }
                        }
                    }
                }
        );

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        adapter = new MealAdapter(null, this);
        recyclerView.setAdapter(adapter);

        mealViewModel = new ViewModelProvider(this).get(MealViewModel.class);

        mealViewModel.getMeals().observe(this, meals -> adapter.setMeals(meals));

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.navigation_menu, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        if (id == R.id.nav_create) {
            // Use the launcher to start CreateMealActivity
            Intent intentCreate = new Intent(this, CreateMealActivity.class);
            createMealActivityResultLauncher.launch(intentCreate);
            return true;
        } else {
            // Handle other menu items
            return super.onOptionsItemSelected(item);
        }
    }

    @Override
    public void onItemClick(int position) {
        // TODO: Implement something for clicking an item
        // Could be the edit but it is annoying when scrolling
    }

    @Override
    public void onEditClick(int position) {
        Meal mealToEdit = mealViewModel.getMeals().getValue().get(position);

        Intent intent = new Intent(this, UpdateMealActivity.class);
        intent.putExtra("mealToEdit", mealToEdit);
        intent.putExtra("position", position);
        updateMealActivityResultLauncher.launch(intent);
    }

    @Override
    public void onDeleteClick(int position) {
        new AlertDialog.Builder(this)
                .setTitle("Delete Meal")
                .setMessage("Are you sure you want to delete this meal?")
                .setPositiveButton("Yes", (dialog, which) -> {
                    mealViewModel.deleteMeal(position);
                    Toast.makeText(this, "Meal deleted", Toast.LENGTH_SHORT).show();
                })
                .setNegativeButton("No", null)
                .show();
    }
}