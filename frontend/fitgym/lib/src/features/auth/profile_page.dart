import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitgym/src/common/api.dart';
import 'package:provider/provider.dart';
import 'package:fitgym/l10n/app_localizations.dart';
import '../../app.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  String _name = 'John Doe';
  String _email = 'johndoe@email.com';
  int _age = 25;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final profile = await ApiService.getProfile();
    if (profile != null) {
      setState(() {
        _name = profile['name'] ?? _name;
        _email = profile['email'] ?? _email;
        _age = profile['age'] ?? _age;
      });
    }
  }

  void _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('user_email') ?? _email;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouter.of(context).routerDelegate.currentConfiguration.extra;
    if (extra is Map<String, String>) {
      setState(() {
        _name = extra['name'] ?? _name;
        _email = extra['email'] ?? _email;
      });
    }
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/profile');
        break;
      case 1:
        context.go('/workout-log');
        break;
      case 2:
        context.go('/progress');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final themeLocale = Provider.of<ThemeLocaleNotifier>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                color: Theme.of(context).cardColor,
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.orangeAccent,
                        child: Icon(Icons.person, size: 48, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Text(_name,
                          style: TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      Text(_email,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 16,
                          )),
                      Text('${localizations.profile}:  $_age',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            fontSize: 16,
                          )),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              overlayColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              final result = await showDialog<Map<String, dynamic>>(
                                context: context,
                                builder: (dialogContext) {
                                  final nameController = TextEditingController(text: _name);
                                  final ageController = TextEditingController(text: _age > 0 ? _age.toString() : '');
                                  bool isSaving = false;
                                  return StatefulBuilder(
                                    builder: (dialogContext, setDialogState) {
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context).dialogBackgroundColor,
                                        title: Text(localizations.profile, style: TextStyle(color: Colors.orangeAccent)),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                labelText: localizations.name,
                                                labelStyle: TextStyle(color: Colors.orangeAccent),
                                              ),
                                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                            ),
                                            const SizedBox(height: 12),
                                            TextField(
                                              controller: ageController,
                                              decoration: InputDecoration(
                                                labelText: localizations.age,
                                                labelStyle: TextStyle(color: Colors.orangeAccent),
                                              ),
                                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                                              keyboardType: TextInputType.number,
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(dialogContext).pop();
                                            },
                                            child: Text(localizations.close, style: TextStyle(color: Colors.orangeAccent)),
                                          ),
                                          ElevatedButton(
                                            onPressed: isSaving
                                                ? null
                                                : () async {
                                                    setDialogState(() => isSaving = true);
                                                    final newName = nameController.text;
                                                    final newAge = int.tryParse(ageController.text) ?? 0;
                                                    final response = await ApiService.updateProfile(newName, newAge);
                                                    setDialogState(() => isSaving = false);
                                                    if (response.statusCode == 200) {
                                                      if (dialogContext.mounted) {
                                                        setState(() {
                                                          _name = newName;
                                                          _age = newAge;
                                                        });
                                                        Navigator.of(dialogContext).pop({'name': newName, 'age': newAge});
                                                      }
                                                    } else {
                                                      if (dialogContext.mounted) {
                                                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                                                          SnackBar(content: Text('Failed to update profile')),
                                                        );
                                                        Navigator.of(dialogContext).pop();
                                                      }
                                                    }
                                                  },
                                            child: isSaving
                                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                                : Text(localizations.save),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                              if (result != null) {
                                setState(() {
                                  _name = result['name'] ?? _name;
                                  _age = int.tryParse(result['age'].toString()) ?? _age;
                                });
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: Text(localizations.profile),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              overlayColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.remove('access_token');
                              await prefs.remove('refresh_token');
                              context.go('/login');
                            },
                            icon: const Icon(Icons.logout),
                            label: Text(localizations.logout),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Theme switcher
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.brightness_6, color: Colors.orangeAccent),
                          const SizedBox(width: 8),
                          Flexible(
                            child: DropdownButton<ThemeMode>(
                              value: themeLocale.themeMode,
                              dropdownColor: Theme.of(context).cardColor,
                              isExpanded: true,
                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                              focusColor: Colors.transparent,
                              iconEnabledColor: Colors.orangeAccent,
                              iconDisabledColor: Colors.orangeAccent,
                              underline: Container(height: 0),
                              items: [
                                DropdownMenuItem(
                                  value: ThemeMode.system,
                                  child: Text(localizations.themeSwitch + ' (System)'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.light,
                                  child: Text(localizations.themeSwitch + ' (Light)'),
                                ),
                                DropdownMenuItem(
                                  value: ThemeMode.dark,
                                  child: Text(localizations.themeSwitch + ' (Dark)'),
                                ),
                              ],
                              onChanged: (mode) {
                                if (mode != null) themeLocale.setThemeMode(mode);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Language switcher
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.language, color: Colors.orangeAccent),
                          const SizedBox(width: 8),
                          Flexible(
                            child: DropdownButton<Locale>(
                              value: themeLocale.locale,
                              dropdownColor: Theme.of(context).cardColor,
                              isExpanded: true,
                              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                              focusColor: Colors.transparent,
                              iconEnabledColor: Colors.orangeAccent,
                              iconDisabledColor: Colors.orangeAccent,
                              underline: Container(height: 0),
                              items: [
                                DropdownMenuItem(
                                  value: const Locale('en'),
                                  child: Text('English'),
                                ),
                                DropdownMenuItem(
                                  value: const Locale('ru'),
                                  child: Text('Русский'),
                                ),
                              ],
                              onChanged: (locale) {
                                if (locale != null) themeLocale.setLocale(locale);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Divider(color: Colors.orangeAccent.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.fitness_center, color: Colors.orangeAccent),
                        title: Text(localizations.workoutLog, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        onTap: () => context.go('/workout-log'),
                      ),
                      ListTile(
                        leading: Icon(Icons.show_chart, color: Colors.orangeAccent),
                        title: Text(localizations.progress, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        onTap: () => context.go('/progress'),
                      ),
                      ListTile(
                        leading: Icon(Icons.people, color: Colors.orangeAccent),
                        title: Text(localizations.social, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        onTap: () => context.go('/social'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Theme.of(context).colorScheme.surface,
        indicatorColor: Colors.orangeAccent.withOpacity(0.1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.person),
            label: localizations.profile,
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: localizations.workoutLog,
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart),
            label: localizations.progress,
            tooltip: '',
          ),
        ],
      ),
    );
  }
} 