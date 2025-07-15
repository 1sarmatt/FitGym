import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../common/api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  int _selectedIndex = 1;
  String message = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/'); 
        break;
      case 1:
        context.go('/login');
        break;
      case 2:
        context.go('/register');
        break;
    }
  }

  void login() async {
    final response = await ApiService.login(
      _emailController.text,
      _passwordController.text,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await ApiService.saveTokens(data['access_token'], data['refresh_token']);
      await ApiService.saveEmail(_emailController.text);
      setState(() => message = 'Login successful!');
      context.go('/profile');
    } else {
      setState(() => message = 'Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                color: Colors.grey[850],
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.fitness_center, size: 48, color: Colors.orangeAccent),
                        const SizedBox(height: 16),
                        Text('Welcome Back!',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: Colors.orangeAccent),
                            prefixIcon: const Icon(Icons.email, color: Colors.orangeAccent),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            // Allow any text for testing/demo purposes
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.orangeAccent),
                            prefixIcon: const Icon(Icons.lock, color: Colors.orangeAccent),
                            filled: true,
                            fillColor: Colors.grey[800],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.orangeAccent),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                login();
                              }
                            },
                            
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.go('/register'),
                          child: const Text('Don\'t have an account? Register', style: TextStyle(color: Colors.orangeAccent)),
                        ),
                        Text(message),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.grey[900],
        indicatorColor: Colors.orangeAccent.withOpacity(0.1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Welcome',
          ),
          NavigationDestination(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add),
            label: 'Register',
          ),
        ],
      ),
    );
  }
} 