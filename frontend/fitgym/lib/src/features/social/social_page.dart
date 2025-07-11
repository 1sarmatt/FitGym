import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SocialPage extends StatelessWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Social Page'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/schedule'),
              child: const Text('Go to Schedule'),
            ),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
} 