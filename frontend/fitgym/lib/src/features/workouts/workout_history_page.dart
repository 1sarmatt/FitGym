import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'workout_model.dart';
import 'dart:convert';
import '../../common/api.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  List workouts = [];
  String message = '';

  void fetchHistory() async {
    final response = await ApiService.getWorkoutHistory();
    if (response.statusCode == 200) {
      setState(() => workouts = jsonDecode(response.body));
    } else {
      setState(() => message = 'Error: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout History')),
      body: message.isNotEmpty
          ? Text(message)
          : ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return ListTile(
                  title: Text(workout['name'] ?? 'No name'),
                  subtitle: Text(workout['date'] ?? ''),
                );
              },
            ),
    );
  }
} 