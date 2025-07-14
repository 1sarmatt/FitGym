import 'package:flutter/material.dart';

class WorkoutModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _workouts = [
    {
      'date': '01.06.2024',
      'type': 'Chest & Triceps',
      'notes': 'Bench press, dips',
      'exercises': [
        {'name': 'Bench Press', 'sets': '3', 'reps': '10', 'weight': '60'},
        {'name': 'Dips', 'sets': '3', 'reps': '12', 'weight': ''},
      ],
    },
    {
      'date': '02.06.2024',
      'type': 'Back & Biceps',
      'notes': 'Pull-ups, rows',
      'exercises': [
        {'name': 'Pull-ups', 'sets': '4', 'reps': '8', 'weight': ''},
        {'name': 'Rows', 'sets': '3', 'reps': '10', 'weight': '40'},
      ],
    },
    {
      'date': '03.06.2024',
      'type': 'Legs',
      'notes': 'Squats, lunges',
      'exercises': [
        {'name': 'Squats', 'sets': '4', 'reps': '8', 'weight': '80'},
        {'name': 'Lunges', 'sets': '3', 'reps': '12', 'weight': '20'},
      ],
    },
  ];
  final List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get workouts => List.unmodifiable(_workouts);
  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  void addWorkout(Map<String, dynamic> workout) {
    _workouts.insert(0, workout);
    notifyListeners();
  }

  void updateWorkout(int index, Map<String, dynamic> workout) {
    _workouts[index] = workout;
    notifyListeners();
  }

  void deleteWorkout(int index) {
    _workouts.removeAt(index);
    notifyListeners();
  }

  void completeWorkout(int index) {
    _history.insert(0, _workouts[index]);
    _workouts.removeAt(index);
    notifyListeners();
  }
} 