# Calorie and Workout Tracking App (Name: FitBuddy)

## Overview

This app is designed to help users easily track their daily calorie intake. Whether users are focused on maintaining their current fitness level or reaching new goals, the app provides a simple interface for logging meals, and monitoring progress. The app also offers insights into daily activity and allows users to set fitness goals based on their personal health objectives.

## Features

- Log meals and track calorie consumption.
- Log workouts.
- View progress through past entries of meals.
- Sync data across devices when online.
- Offline functionality to log and view data without an internet connection.

## Entities and Data Persistence

### User

The **User** entity stores basic user information, which is used to personalize the app's recommendations and track goals.

Fields:

- `name`: Full name of the user.
- `email`: User’s email address for login and communication.
- `age`: The user's age, which helps in calculating personalized calorie recommendations.
- `weight`: Current weight, tracked as part of fitness progress.
- `height`: The user’s height, used to calculate BMI and other health metrics.

### Meal

The **Meal** entity represents the meals logged by the user to track calorie consumption.

Fields:

- `meal_id`: Unique identifier for the meal entry.
- `meal_type`: Type of meal (e.g., breakfast, lunch, dinner, snack).
- `total_calories`: Total calories for the meal, calculated based on the ingredients.
- `date_logged`: The date and time the meal was logged.

### Ingredient

The **Ingredient** entity represents individual food items that make up a meal.

Fields:

- `ingredient_id`: Unique identifier for the ingredient.
- `ingredient_name`: Name of the ingredient (e.g., chicken, rice).
- `calories`: Calories for the specific quantity of the ingredient.
- `quantity`: Quantity of the ingredient used in the meal (e.g., 100 grams).

## CRUD Operations

The app supports the following operations for each entity:

- **Create**: Users can log new meals, and fitness ingredients.
- **Read**: Users can view their past meals, and progress toward ingredients.
- **Update**: Users can modify existing entries if they made a mistake or need to adjust details.
- **Delete**: Users can remove entries if they are no longer relevant or were added by mistake.

## Persistence

- **Local Database**: All CRUD operations for meals, and ingredients are persisted locally on the device for offline access.
- **Server**: When connected to the internet, data is synced with the server to ensure it is backed up and accessible from other devices.

## Offline Functionality

The app has full offline support. Users can log and view data even when they are not connected to the internet. Once the device is back online, all data is synced with the server. Here’s how it works:

- **Create**: Entries are stored locally when offline and synced to the server when back online.
- **Read**: All past logs are available from the local database when offline.
- **Update**: Modifications to meals, or ingredients made offline will be synced when the app reconnects to the server.
- **Delete**: Deleted entries are reflected locally first and synced once online.

## App Mockup

Below are screen captures of the app interface:

![App Mockup 1](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss1.png)

![App Mockup 2](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss2.png)

![App Mockup 3](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss3.png)

![App Mockup 4](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss4.png)
