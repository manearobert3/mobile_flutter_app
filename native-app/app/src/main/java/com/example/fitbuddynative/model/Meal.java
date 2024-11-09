package com.example.fitbuddynative.model;

import java.io.Serializable;
import java.time.LocalDate;

public class Meal implements Serializable {

    private static int idCounter = 0; // Static counter for IDs

    private int meal_id;
    private String name;
    private String meal_type;
    private int total_calories;
    private LocalDate date_logged;

    public Meal(String name, String meal_type, int total_calories, LocalDate date_logged) {
        this.meal_id = getNextId();
        this.name = name;
        this.meal_type = meal_type;
        this.total_calories = total_calories;
        this.date_logged = date_logged;
    }

    private static synchronized int getNextId() {
        return idCounter++;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
    public int getMeal_id() {
        return meal_id;
    }

    public void setMeal_id(int meal_id) {
        this.meal_id = meal_id;
    }

    public String getMeal_type() {
        return meal_type;
    }

    public void setMeal_type(String meal_type) {
        this.meal_type = meal_type;
    }

    public int getTotal_calories() {
        return total_calories;
    }

    public void setTotal_calories(int total_calories) {
        this.total_calories = total_calories;
    }

    public LocalDate getDate_logged() {
        return date_logged;
    }

    public void setDate_logged(LocalDate date_logged) {
        this.date_logged = date_logged;
    }
}
