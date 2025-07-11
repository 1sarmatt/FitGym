import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutHistoryPage extends StatelessWidget {
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Workout History Page'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/workout-log'),
              child: const Text('Go to Workout Log'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/progress'),
              child: const Text('Go to Progress'),
            ),
          ],
        ),
      ),
    );
  }
} 