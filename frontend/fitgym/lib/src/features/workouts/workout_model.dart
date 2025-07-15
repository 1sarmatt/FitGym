import 'package:flutter/material.dart';
import 'dart:convert';
import '../../common/api.dart';

class WorkoutModel extends ChangeNotifier {
  List<Map<String, dynamic>> _workouts = [];
  List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get workouts => List.unmodifiable(_workouts);
  List<Map<String, dynamic>> get history => List.unmodifiable(_history);

  Future<void> fetchWorkouts() async {
    final response = await ApiService.getWorkouts();
    if (response.statusCode == 200) {
      final all = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      _workouts = all.where((w) => w['completed'] == false).toList();
      _history = all.where((w) => w['completed'] == true).toList();
      notifyListeners();
    }
  }

  void clear() {
    _workouts = [];
    _history = [];
    notifyListeners();
  }
} 