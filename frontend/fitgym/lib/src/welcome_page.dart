import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fitness_center, size: 100, color: Colors.orangeAccent),
              const SizedBox(height: 32),
              Text(
                'Welcome to FitGym!',
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Track your workouts, reach your goals, and become stronger every day! 💪',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 320,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  onPressed: () => context.go('/login'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 320,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orangeAccent,
                    side: const BorderSide(color: Colors.orangeAccent, width: 2),
                    textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Register'),
                  onPressed: () => context.go('/register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 