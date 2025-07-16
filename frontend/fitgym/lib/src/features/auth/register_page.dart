import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/api.dart';
import 'dart:convert';
import 'package:fitgym/l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _selectedIndex = 2;
  String message = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/'); // Welcome
        break;
      case 1:
        context.go('/login');
        break;
      case 2:
        context.go('/register');
        break;
    }
  }

  void register() async {
    final response = await ApiService.register(
      _emailController.text,
      _passwordController.text,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await ApiService.saveTokens(data['access_token'], data['refresh_token']);
      await ApiService.saveEmail(_emailController.text);
      setState(() => message = 'Registration successful!');
      context.go('/profile');
    } else {
      setState(() => message = 'Error: \n${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                color: theme.cardColor,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_add, size: 48, color: colorScheme.primary),
                        const SizedBox(height: 16),
                        Text(localizations.createAccount,
                            style: textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
                        const SizedBox(height: 24),
                        TextFormField(
                          key: const Key('emailField'),
                          controller: _emailController,
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: localizations.email,
                            labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                            prefixIcon: Icon(Icons.email, color: colorScheme.primary),
                            filled: true,
                            fillColor: theme.cardColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.enterEmail;
                            }
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(value)) {
                              return localizations.enterValidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('passwordField'),
                          controller: _passwordController,
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: localizations.password,
                            labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                            prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
                            filled: true,
                            fillColor: theme.cardColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: colorScheme.primary),
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.enterPassword;
                            }
                            if (value.length < 6) {
                              return localizations.passwordMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          key: const Key('confirmPasswordField'),
                          controller: _confirmPasswordController,
                          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                          decoration: InputDecoration(
                            labelText: localizations.confirmPassword,
                            labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
                            prefixIcon: Icon(Icons.lock_outline, color: colorScheme.primary),
                            filled: true,
                            fillColor: theme.cardColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colorScheme.primary, width: 2),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: colorScheme.primary),
                              onPressed: () {
                                setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.confirmPasswordPrompt;
                            }
                            if (value != _passwordController.text) {
                              return localizations.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                register();
                              }
                            },
                            child: Text(localizations.register),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(localizations.alreadyHaveAccountLogin, style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary)),
                        ),
                        Text(message, style: textTheme.bodyMedium?.copyWith(color: colorScheme.error)),
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
        backgroundColor: theme.bottomAppBarTheme.color ?? colorScheme.surface,
        indicatorColor: colorScheme.primary.withOpacity(0.1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: localizations.welcome,
          ),
          NavigationDestination(
            icon: Icon(Icons.login),
            label: localizations.login,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add),
            label: localizations.register,
          ),
        ],
      ),
    );
  }
} 