import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Schedule Page'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/progress'),
              child: const Text('Go to Progress'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/social'),
              child: const Text('Go to Social'),
            ),
          ],
        ),
      ),
    );
  }
} 