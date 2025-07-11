import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkoutLogPage extends StatefulWidget {
  const WorkoutLogPage({Key? key}) : super(key: key);

  @override
  State<WorkoutLogPage> createState() => _WorkoutLogPageState();
}

class _WorkoutLogPageState extends State<WorkoutLogPage> {
  int _selectedIndex = 2;
  List<Map<String, String>> _workouts = [
    {'date': '01.06.2024', 'type': 'Chest & Triceps', 'notes': 'Bench press, dips'},
    {'date': '02.06.2024', 'type': 'Back & Biceps', 'notes': 'Pull-ups, rows'},
    {'date': '03.06.2024', 'type': 'Legs', 'notes': 'Squats, lunges'},
  ];

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

  void _addWorkout() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        final dateController = TextEditingController();
        final typeController = TextEditingController();
        final notesController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Add Workout', style: TextStyle(color: Colors.orangeAccent)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date (DD.MM.YYYY)',
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter date';
                    if (!RegExp(r'^\d{2}\.\d{2}\.\d{4} 0$').hasMatch(value)) {
                      return 'Format: DD.MM.YYYY';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(
                    labelText: 'Workout Type',
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter type' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.orangeAccent)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'date': dateController.text,
                    'type': typeController.text,
                    'notes': notesController.text,
                  });
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (result != null && result['date']!.isNotEmpty && result['type']!.isNotEmpty) {
      setState(() {
        _workouts.insert(0, result);
      });
    }
  }

  void _editWorkout(int index) async {
    final workout = _workouts[index];
    final dateController = TextEditingController(text: workout['date']);
    final typeController = TextEditingController(text: workout['type']);
    final notesController = TextEditingController(text: workout['notes']);
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Edit Workout', style: TextStyle(color: Colors.orangeAccent)),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date (DD.MM.YYYY)',
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter date';
                    if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(value)) {
                      return 'Format: DD.MM.YYYY';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(
                    labelText: 'Workout Type',
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => (value == null || value.isEmpty) ? 'Enter type' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop({'action': 'delete'}),
              child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.orangeAccent)),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'action': 'update',
                    'date': dateController.text,
                    'type': typeController.text,
                    'notes': notesController.text,
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    if (result != null) {
      if (result['action'] == 'delete') {
        setState(() {
          _workouts.removeAt(index);
        });
      } else if (result['action'] == 'update') {
        setState(() {
          _workouts[index] = {
            'date': result['date'],
            'type': result['type'],
            'notes': result['notes'],
          };
        });
      }
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
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                color: Colors.grey[850],
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Workout Log',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _addWorkout,
                            icon: const Icon(Icons.add),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _workouts.isEmpty
                          ? Center(
                              child: Text('No workouts yet.', style: TextStyle(color: Colors.white70)),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _workouts.length,
                              separatorBuilder: (_, __) => Divider(color: Colors.orangeAccent.withOpacity(0.2)),
                              itemBuilder: (context, i) {
                                final w = _workouts[i];
                                return ListTile(
                                  leading: Icon(Icons.fitness_center, color: Colors.orangeAccent),
                                  title: Text(w['type'] ?? '', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(w['date'] ?? '', style: TextStyle(color: Colors.orangeAccent, fontSize: 13)),
                                      if ((w['notes'] ?? '').isNotEmpty)
                                        Text(w['notes']!, style: TextStyle(color: Colors.white70, fontSize: 13)),
                                    ],
                                  ),
                                  onTap: () => _editWorkout(i),
                                );
                              },
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