import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Progress Page'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/workout-history'),
              child: const Text('Go to Workout History'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/schedule'),
              child: const Text('Go to Schedule'),
            ),
          ],
        ),
      ),
    );
  }
} 