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

## CRUD Operations

The app supports the following operations for each entity:

- **Create**: Users can log new meals.
- **Read**: Users can view their past meals.
- **Update**: Users can modify existing entries if they made a mistake or need to adjust details.
- **Delete**: Users can remove entries if they are no longer relevant or were added by mistake.

## Persistence

- **Local Database**: All CRUD operations for meals are persisted locally on the device for offline access.
- **Server**: When connected to the internet, data is synced with the server to ensure it is backed up and accessible from other devices.

## Offline Functionality

The app has full offline support. Users can log and view data even when they are not connected to the internet. Once the device is back online, all data is synced with the server. Here’s how it works:

Local Storage: Utilizes SQLite for storing data locally on the device.

Data Access: Users can access and interact with their data without an internet connection.

Deferred Sync: Actions performed offline are queued and synchronized automatically when connectivity is restored.

## Data Synchronization

WebSockets: Enables real-time, bidirectional communication between the app and server for instant data updates.

Sync Queue: Offline actions are queued and automatically synchronized once the device is online.

## Real-Time Synchronization

WebSocket Integration: Ensures immediate data updates across devices.

Automatic Sync: Detects network availability and synchronizes queued actions seamlessly.

Data Integrity: Maintains consistent data states across sessions and devices.

## Backend Implementation

Built with Express.js, exposing RESTful routes for meals, ingredients, users, and workouts.

Integrated WebSockets for real-time synchronization when online.

Used logging libraries to output clear, meaningful messages for operations and sync events.

Organized code into specific route handlers for maintainability and clarity.

## App Mockup

Below are screen captures of the app interface:

![App Mockup 1](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss1.png)

![App Mockup 2](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss2.png)

![App Mockup 3](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss3.png)

![App Mockup 4](https://github.com/manearobert3/mobile_flutter_app/blob/master/Screenshots/ss4.png)
