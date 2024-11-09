package com.example.fitbuddynative.viewmodel;

import android.annotation.SuppressLint;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

import com.example.fitbuddynative.model.Meal;

import java.time.LocalDate;
import java.time.chrono.ChronoLocalDate;
import java.util.ArrayList;
import java.util.List;

public class MealViewModel extends ViewModel {
    private final MutableLiveData<List<Meal>> meals;

    public MealViewModel() {
        this.meals = new MutableLiveData<>();

        loadMeals();
    }

    private void loadMeals() {
        List<Meal> mealList = new ArrayList<>();
        mealList.add(new Meal("Chicken Breast", "Protein", 165, LocalDate.now()));
        mealList.add(new Meal("Steamed Broccoli", "Vegetable", 55, LocalDate.now().minusDays(1)));
        mealList.add(new Meal("Banana", "Fruit", 105, LocalDate.now().minusDays(2)));
        mealList.add(new Meal("Salmon Fillet", "Fish", 233, LocalDate.now().minusDays(3)));
        mealList.add(new Meal("Brown Rice", "Grain", 216, LocalDate.now().minusDays(4)));
        mealList.add(new Meal("Greek Yogurt", "Dairy", 59, LocalDate.now().minusDays(5)));
        mealList.add(new Meal("Almonds", "Nuts", 164, LocalDate.now().minusDays(6)));
        mealList.add(new Meal("Avocado Toast", "Breakfast", 250, LocalDate.now().minusDays(7)));
        mealList.add(new Meal("Grilled Steak", "Protein", 679, LocalDate.now().minusDays(8)));
        mealList.add(new Meal("Oatmeal", "Breakfast", 158, LocalDate.now().minusDays(9)));

        meals.setValue(mealList);
    }

    public LiveData<List<Meal>> getMeals(){
        return meals;
    }

    public void addMeal(Meal meal){
        List<Meal> currentMeals = meals.getValue();
        if(currentMeals != null){
            currentMeals.add(meal);
            meals.setValue(currentMeals);
        }
    }

    public void updateMeal(int position, Meal meal){
        List<Meal> currentMeals = meals.getValue();
        if (currentMeals != null){
            currentMeals.set(position,meal);
            meals.setValue(currentMeals);
        }
    }

    public void deleteMeal(int position){
        List<Meal> currentMeals = meals.getValue();
        if (currentMeals != null){
            currentMeals.remove(position);
            meals.setValue(currentMeals);
        }
    }

}
