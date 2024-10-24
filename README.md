# Flutter-ToDoList

This Flutter app is a simple task manager where users can add, check off, and delete tasks. The app uses SharedPreferences to save tasks locally, so the user's list persists even when the app is closed and reopened.

# Features
- Add new tasks to the list.
- Mark tasks as completed or incomplete.
- Delete tasks from the list.
- Automatically saves tasks using SharedPreferences.

# How It Works
- The app loads saved tasks from SharedPreferences when it starts.
- Users can add new tasks by clicking the floating action button, which reveals a text field.
- The task list displays each task with a checkbox for completion and a delete button.
- When a task is added, deleted, or marked as complete, the list is saved again in SharedPreferences.

# Dependencies
flutter: The Flutter SDK.
shared_preferences: Used to store task data locally on the device.
