import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 1;
  String _name = 'John Doe';
  String _email = 'johndoe@email.com';

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
        context.go('/'); // Welcome
        break;
      case 1:
        context.go('/profile');
        break;
      case 2:
        context.go('/workout-log');
        break;
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
                            color: Colors.white70,
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
                            ),
                            onPressed: () async {
                              final result = await showDialog<Map<String, String>>(
                                context: context,
                                builder: (context) {
                                  final nameController = TextEditingController(text: _name);
                                  final emailController = TextEditingController(text: _email);
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[900],
                                    title: const Text('Edit Profile', style: TextStyle(color: Colors.orangeAccent)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Name',
                                            labelStyle: TextStyle(color: Colors.orangeAccent),
                                          ),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: emailController,
                                          decoration: const InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(color: Colors.orangeAccent),
                                          ),
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text('Cancel', style: TextStyle(color: Colors.orangeAccent)),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop({
                                            'name': nameController.text,
                                            'email': emailController.text,
                                          });
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (result != null) {
                                setState(() {
                                  _name = result['name'] ?? _name;
                                  _email = result['email'] ?? _email;
                                });
                              }
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.orangeAccent,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              setState(() {
                                _name = 'John Doe';
                                _email = 'johndoe@email.com';
                              });
                              context.go('/login');
                            },
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Divider(color: Colors.orangeAccent.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: Icon(Icons.fitness_center, color: Colors.orangeAccent),
                        title: Text('Workout Log', style: TextStyle(color: Colors.white)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        onTap: () => context.go('/workout-log'),
                      ),
                      ListTile(
                        leading: Icon(Icons.history, color: Colors.orangeAccent),
                        title: Text('Workout History', style: TextStyle(color: Colors.white)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        onTap: () => context.go('/workout-history'),
                      ),
                      ListTile(
                        leading: Icon(Icons.show_chart, color: Colors.orangeAccent),
                        title: Text('Progress', style: TextStyle(color: Colors.white)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        onTap: () => context.go('/progress'),
                      ),
                      ListTile(
                        leading: Icon(Icons.schedule, color: Colors.orangeAccent),
                        title: Text('Schedule', style: TextStyle(color: Colors.white)),
                        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orangeAccent, size: 18),
                        onTap: () => context.go('/schedule'),
                      ),
                      ListTile(
                        leading: Icon(Icons.people, color: Colors.orangeAccent),
                        title: Text('Social', style: TextStyle(color: Colors.white)),
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workout Log',
          ),
        ],
      ),
    );
  }
} 