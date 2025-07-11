import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'workout_model.dart';

class WorkoutLogPage extends StatefulWidget {
  const WorkoutLogPage({Key? key}) : super(key: key);

  @override
  State<WorkoutLogPage> createState() => _WorkoutLogPageState();
}

class _WorkoutLogPageState extends State<WorkoutLogPage> {
  int _selectedIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouter.of(context).location;
    int idx = 1;
    if (location == '/profile') idx = 0;
    else if (location == '/workout-log') idx = 1;
    else if (location == '/workout-history') idx = 2;
    if (_selectedIndex != idx) {
      setState(() {
        _selectedIndex = idx;
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
        context.go('/workout-history');
        break;
    }
  }

  void _addWorkout() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        final dateController = TextEditingController();
        final typeController = TextEditingController();
        final notesController = TextEditingController();
        final formKey = GlobalKey<FormState>();
        List<Map<String, String>> exercises = [];
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void addExercise() {
              final nameController = TextEditingController();
              final setsController = TextEditingController();
              final repsController = TextEditingController();
              final weightController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text('Add Exercise', style: TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: const InputDecoration(labelText: 'Sets', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: const InputDecoration(labelText: 'Reps', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
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
                          if (nameController.text.isNotEmpty) {
                            setStateDialog(() {
                              exercises.add({
                                'name': nameController.text,
                                'sets': setsController.text,
                                'reps': repsController.text,
                                'weight': weightController.text,
                              });
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            }
            void editExercise(int idx) {
              final ex = exercises[idx];
              final nameController = TextEditingController(text: ex['name']);
              final setsController = TextEditingController(text: ex['sets']);
              final repsController = TextEditingController(text: ex['reps']);
              final weightController = TextEditingController(text: ex['weight']);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text('Edit Exercise', style: TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: const InputDecoration(labelText: 'Sets', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: const InputDecoration(labelText: 'Reps', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel', style: TextStyle(color: Colors.orangeAccent)),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateDialog(() {
                            exercises.removeAt(idx);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            setStateDialog(() {
                              exercises[idx] = {
                                'name': nameController.text,
                                'sets': setsController.text,
                                'reps': repsController.text,
                                'weight': weightController.text,
                              };
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            }
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text('Add Workout', style: TextStyle(color: Colors.orangeAccent)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
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
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Exercises', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: addExercise,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (exercises.isEmpty)
                        const Text('No exercises', style: TextStyle(color: Colors.white70)),
                      ...exercises.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ex = entry.value;
                        return Card(
                          color: Colors.grey[800],
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(ex['name'] ?? '', style: const TextStyle(color: Colors.orangeAccent)),
                            subtitle: Text(
                              'Sets: ${ex['sets'] ?? '-'}, Reps: ${ex['reps'] ?? '-'}, Weight: ${ex['weight'] ?? '-'}',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                              onPressed: () => editExercise(i),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
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
                        'exercises': exercises,
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && result['date']!.isNotEmpty && result['type']!.isNotEmpty) {
      context.read<WorkoutModel>().addWorkout(result);
    }
  }

  void _editWorkout(int index) async {
    final workout = context.read<WorkoutModel>().workouts[index];
    final dateController = TextEditingController(text: workout['date']);
    final typeController = TextEditingController(text: workout['type']);
    final notesController = TextEditingController(text: workout['notes']);
    final formKey = GlobalKey<FormState>();
    List<Map<String, String>> exercises = List<Map<String, String>>.from(workout['exercises'] ?? []);
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void addExercise() {
              final nameController = TextEditingController();
              final setsController = TextEditingController();
              final repsController = TextEditingController();
              final weightController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text('Add Exercise', style: TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: const InputDecoration(labelText: 'Sets', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: const InputDecoration(labelText: 'Reps', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
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
                          if (nameController.text.isNotEmpty) {
                            setStateDialog(() {
                              exercises.add({
                                'name': nameController.text,
                                'sets': setsController.text,
                                'reps': repsController.text,
                                'weight': weightController.text,
                              });
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
            }
            void editExercise(int idx) {
              final ex = exercises[idx];
              final nameController = TextEditingController(text: ex['name']);
              final setsController = TextEditingController(text: ex['sets']);
              final repsController = TextEditingController(text: ex['reps']);
              final weightController = TextEditingController(text: ex['weight']);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text('Edit Exercise', style: TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: const InputDecoration(labelText: 'Sets', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: const InputDecoration(labelText: 'Reps', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: const InputDecoration(labelText: 'Weight (kg)', labelStyle: TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel', style: TextStyle(color: Colors.orangeAccent)),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateDialog(() {
                            exercises.removeAt(idx);
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            setStateDialog(() {
                              exercises[idx] = {
                                'name': nameController.text,
                                'sets': setsController.text,
                                'reps': repsController.text,
                                'weight': weightController.text,
                              };
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            }
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: const Text('Edit Workout', style: TextStyle(color: Colors.orangeAccent)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
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
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Exercises', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: addExercise,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Add'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (exercises.isEmpty)
                        const Text('No exercises', style: TextStyle(color: Colors.white70)),
                      ...exercises.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ex = entry.value;
                        return Card(
                          color: Colors.grey[800],
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(ex['name'] ?? '', style: const TextStyle(color: Colors.orangeAccent)),
                            subtitle: Text(
                              'Sets: ${ex['sets'] ?? '-'}, Reps: ${ex['reps'] ?? '-'}, Weight: ${ex['weight'] ?? '-'}',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                              onPressed: () => editExercise(i),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
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
                        'exercises': exercises,
                      });
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      if (result['action'] == 'delete') {
        context.read<WorkoutModel>().deleteWorkout(index);
      } else if (result['action'] == 'update') {
        context.read<WorkoutModel>().updateWorkout(index, {
          'date': result['date'],
          'type': result['type'],
          'notes': result['notes'],
          'exercises': result['exercises'],
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final workouts = context.watch<WorkoutModel>().workouts;
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
                      workouts.isEmpty
                          ? Center(
                              child: Text('No workouts yet.', style: TextStyle(color: Colors.white70)),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: workouts.length,
                              separatorBuilder: (_, __) => Divider(color: Colors.orangeAccent.withOpacity(0.2)),
                              itemBuilder: (context, i) {
                                final w = workouts[i];
                                return ListTile(
                                  leading: Icon(Icons.fitness_center, color: Colors.orangeAccent),
                                  title: Text(w['type'] ?? '', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(w['date'] ?? '', style: TextStyle(color: Colors.orangeAccent, fontSize: 13)),
                                      if ((w['notes'] ?? '').isNotEmpty)
                                        Text(w['notes']!, style: TextStyle(color: Colors.white70, fontSize: 13)),
                                      if ((w['exercises'] ?? []).isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Exercises:', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                                              ...List<Widget>.from((w['exercises'] as List).map((ex) => Text(
                                                '${ex['name']} — ${ex['sets']}x${ex['reps']}${(ex['weight'] != null && ex['weight'] != '') ? ' @ ${ex['weight']}kg' : ''}',
                                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                              ))),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  onTap: () => _editWorkout(i),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () {
                                      context.read<WorkoutModel>().completeWorkout(i);
                                    },
                                    child: const Text('Done'),
                                  ),
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
            icon: Icon(Icons.person),
            label: 'Profile',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center),
            label: 'Workout Log',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
            tooltip: '',
          ),
        ],
      ),
    );
  }
} 