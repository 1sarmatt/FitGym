import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'workout_model.dart';
import '../../common/api.dart';
import 'dart:convert'; // Added for jsonDecode
import 'package:fitgym/l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutModel>().fetchWorkouts();
    });
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
                    title: Text(AppLocalizations.of(context)!.addExercise, style: const TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.sets, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.reps, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.weightKg, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.orangeAccent)),
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
                        child: Text(AppLocalizations.of(context)!.add),
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
                    title: Text(AppLocalizations.of(context)!.editExercise, style: const TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.sets, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.reps, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.weightKg, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.orangeAccent)),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateDialog(() {
                            exercises.removeAt(idx);
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.redAccent)),
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
                        child: Text(AppLocalizations.of(context)!.save),
                      ),
                    ],
                  );
                },
              );
            }
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(AppLocalizations.of(context)!.addWorkout, style: const TextStyle(color: Colors.orangeAccent)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.date,
                          labelStyle: const TextStyle(color: Colors.orangeAccent),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) return AppLocalizations.of(context)!.enterDate;
                          if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(value)) {
                            return AppLocalizations.of(context)!.formatDateError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: typeController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.workoutType,
                          labelStyle: const TextStyle(color: Colors.orangeAccent),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => (value == null || value.isEmpty) ? AppLocalizations.of(context)!.enterType : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.notes,
                          labelStyle: const TextStyle(color: Colors.orangeAccent),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.exercises, style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
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
                            label: Text(AppLocalizations.of(context)!.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (exercises.isEmpty)
                        Text(AppLocalizations.of(context)!.noExercises, style: const TextStyle(color: Colors.white70)),
                      ...exercises.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ex = entry.value;
                        return Card(
                          color: Colors.grey[800],
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(ex['name'] ?? '', style: const TextStyle(color: Colors.orangeAccent)),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.sets}: ${ex['sets'] ?? '-'}, ${AppLocalizations.of(context)!.reps}: ${ex['reps'] ?? '-'}, ${AppLocalizations.of(context)!.weight}: ${ex['weight'] ?? '-'}',
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
                  child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.orangeAccent)),
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
                  child: Text(AppLocalizations.of(context)!.add),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null && result['date']!.isNotEmpty && result['type']!.isNotEmpty) {
      try {
        final userId = await ApiService.getUserId();
        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.userNotFound)),
          );
          return;
        }
        // Prepare workout data for backend
        final exercises = (result['exercises'] is Iterable) ? result['exercises'] as Iterable : const [];
        final workoutData = {
          'user_id': userId,
          'workout_type': result['type'],
          'date': _convertDateToBackendFormat(result['date']),
          'duration': 60, // TODO: replace with actual duration if available
          'notes': result['notes'] ?? '',
          'exercises': exercises.map((ex) => {
                  'name': ex['name'],
                  'sets': int.tryParse(ex['sets'] ?? '') ?? 0,
                  'reps': int.tryParse(ex['reps'] ?? '') ?? 0,
                  'weight': int.tryParse(ex['weight'] ?? '') ?? 0,
                }).toList(),
        };
        final response = await ApiService.addWorkout(workoutData);
        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          final workoutWithId = {
            ...result,
            'id': responseData['workout_id'],
          };
          await context.read<WorkoutModel>().fetchWorkouts();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)!.failedToAddWorkout}: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}')),
        );
      }
    }
  }

  void _editWorkout(int index) async {
    final workout = context.read<WorkoutModel>().workouts[index];
    final dateController = TextEditingController(text: formatDate(workout['date'] ?? ''));
    final typeController = TextEditingController(text: workout['type']);
    final notesController = TextEditingController(text: workout['notes']);
    final formKey = GlobalKey<FormState>();
    List<Map<String, String>> exercises = (workout['exercises'] is Iterable)
        ? List<Map<String, String>>.from(workout['exercises'])
        : <Map<String, String>>[];
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
                    title: Text(AppLocalizations.of(context)!.addExercise, style: const TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.sets, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.reps, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.weightKg, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.orangeAccent)),
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
                        child: Text(AppLocalizations.of(context)!.add),
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
                    title: Text(AppLocalizations.of(context)!.editExercise, style: const TextStyle(color: Colors.orangeAccent)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.name, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: setsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.sets, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: repsController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.reps, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: weightController,
                          decoration: InputDecoration(labelText: AppLocalizations.of(context)!.weightKg, labelStyle: const TextStyle(color: Colors.orangeAccent)),
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.orangeAccent)),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateDialog(() {
                            exercises.removeAt(idx);
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.redAccent)),
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
                        child: Text(AppLocalizations.of(context)!.save),
                      ),
                    ],
                  );
                },
              );
            }
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(AppLocalizations.of(context)!.editWorkout, style: const TextStyle(color: Colors.orangeAccent)),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.date,
                          labelStyle: const TextStyle(color: Colors.orangeAccent),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) return AppLocalizations.of(context)!.enterDate;
                          if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(value)) {
                            return AppLocalizations.of(context)!.formatDateError;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: typeController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.workoutType,
                          labelStyle: const TextStyle(color: Colors.orangeAccent),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) => (value == null || value.isEmpty) ? AppLocalizations.of(context)!.enterType : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: notesController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.notes,
                          labelStyle: const TextStyle(color: Colors.orangeAccent),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.exercises, style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
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
                            label: Text(AppLocalizations.of(context)!.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (exercises.isEmpty)
                        Text(AppLocalizations.of(context)!.noExercises, style: const TextStyle(color: Colors.white70)),
                      ...exercises.asMap().entries.map((entry) {
                        final i = entry.key;
                        final ex = entry.value;
                        return Card(
                          color: Colors.grey[800],
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(ex['name'] ?? '', style: const TextStyle(color: Colors.orangeAccent)),
                            subtitle: Text(
                              '${AppLocalizations.of(context)!.sets}: ${ex['sets'] ?? '-'}, ${AppLocalizations.of(context)!.reps}: ${ex['reps'] ?? '-'}, ${AppLocalizations.of(context)!.weight}: ${ex['weight'] ?? '-'}',
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
                  child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.redAccent)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.orangeAccent)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final id = workout['id'];
                      if (id == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppLocalizations.of(context)!.workoutIdNotFound)),
                        );
                        return;
                      }
                      // Convert date to backend format
                      final backendDate = _convertDateToBackendFormat(dateController.text);
                      final exercisesForUpdate = exercises
                          .map((ex) => {
                                'name': ex['name'],
                                'sets': int.tryParse(ex['sets'] ?? '') ?? 0,
                                'reps': int.tryParse(ex['reps'] ?? '') ?? 0,
                                'weight': int.tryParse(ex['weight'] ?? '') ?? 0,
                              })
                          .toList();
                      final response = await ApiService.updateWorkout(
                        id: id,
                        notes: notesController.text,
                        date: backendDate,
                        type: typeController.text,
                        exercises: exercisesForUpdate,
                      );
                      if (response.statusCode == 200) {
                        await context.read<WorkoutModel>().fetchWorkouts();
                        Navigator.of(context).pop({
                          'action': 'update',
                          'date': dateController.text,
                          'type': typeController.text,
                          'notes': notesController.text,
                          'exercises': exercises,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${AppLocalizations.of(context)!.failedToUpdateWorkout}: ${response.body}')),
                        );
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      if (result['action'] == 'delete' || result['action'] == 'update') {
        await context.read<WorkoutModel>().fetchWorkouts();
      }
    }
  }

  void _completeWorkout(int i) async {
    final w = context.read<WorkoutModel>().workouts[i];
    final workoutId = w['id'];
    if (workoutId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.workoutIdNotFound)),
      );
      return;
    }
    try {
      final response = await ApiService.completeWorkout(workoutId);
      if (response.statusCode == 200) {
        await context.read<WorkoutModel>().fetchWorkouts();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.workoutMarkedAsCompleted)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.failedToCompleteWorkout}: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}')),
      );
    }
  }

  void _deleteWorkout(int i) async {
    final w = context.read<WorkoutModel>().workouts[i];
    final workoutId = w['id'];
    if (workoutId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.workoutIdNotFound)),
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteWorkout),
        content: Text(AppLocalizations.of(context)!.confirmDeleteWorkout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        final response = await ApiService.deleteWorkout(workoutId);
        if (response.statusCode == 200) {
          await context.read<WorkoutModel>().fetchWorkouts();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.workoutDeleted)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)!.failedToDeleteWorkout}: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final localizations = AppLocalizations.of(context)!;
    final workouts = context.watch<WorkoutModel>().workouts;
    final history = context.watch<WorkoutModel>().history;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                color: theme.cardColor,
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
                          Text(localizations.workoutLog,
                              style: textTheme.titleLarge),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _addWorkout,
                            icon: const Icon(Icons.add),
                            label: Text(localizations.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      workouts.isEmpty && history.isEmpty
                          ? Center(
                              child: Text(localizations.noWorkoutsYet, style: textTheme.bodyMedium),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (workouts.isNotEmpty)
                                  ...[
                                    Text(localizations.activeWorkouts, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: workouts.length,
                                      separatorBuilder: (_, __) => Divider(color: colorScheme.primary.withOpacity(0.2)),
                                      itemBuilder: (context, i) {
                                        final w = workouts[i];
                                        return ListTile(
                                          leading: Icon(Icons.fitness_center, color: colorScheme.primary),
                                          title: Text(w['type'] ?? '', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(formatDate(w['date'] ?? ''), style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontSize: 13)),
                                              if ((w['notes'] ?? '').isNotEmpty)
                                                Text(w['notes']!, style: textTheme.bodyMedium?.copyWith(fontSize: 13)),
                                              if ((w['exercises'] is Iterable) && (w['exercises'] as Iterable).isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(localizations.exercises, style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                                      ...List<Widget>.from((w['exercises'] as Iterable).map((ex) => Text(
                                                        '${ex['name']} — ${ex['sets']}x${ex['reps']}${(ex['weight'] != null && ex['weight'] != '') ? ' @ ${ex['weight']}kg' : ''}',
                                                        style: textTheme.bodyMedium?.copyWith(fontSize: 13),
                                                      ))),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          onTap: () => _editWorkout(i),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green, // Optional: you can theme this too
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                onPressed: () => _completeWorkout(i),
                                                child: Text(localizations.complete),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.redAccent, // Optional: you can theme this too
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                  textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                onPressed: () => _deleteWorkout(i),
                                                child: Text(localizations.delete),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                if (history.isNotEmpty)
                                  ...[
                                    Text(localizations.workoutHistory, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: history.length,
                                      separatorBuilder: (_, __) => Divider(color: colorScheme.primary.withOpacity(0.2)),
                                      itemBuilder: (context, i) {
                                        final w = history[i];
                                        return ListTile(
                                          leading: Icon(Icons.history, color: colorScheme.primary),
                                          title: Text(w['type'] ?? '', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(formatDate(w['date'] ?? ''), style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontSize: 13)),
                                              if ((w['notes'] ?? '').isNotEmpty)
                                                Text(w['notes']!, style: textTheme.bodyMedium?.copyWith(fontSize: 13)),
                                              if ((w['exercises'] is Iterable) && (w['exercises'] as Iterable).isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 6.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(localizations.exercises, style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                                      ...List<Widget>.from((w['exercises'] as Iterable).map((ex) => Text(
                                                        '${ex['name']} — ${ex['sets']}x${ex['reps']}${(ex['weight'] != null && ex['weight'] != '') ? ' @ ${ex['weight']}kg' : ''}',
                                                        style: textTheme.bodyMedium?.copyWith(fontSize: 13),
                                                      ))),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                              ],
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
        backgroundColor: theme.bottomAppBarTheme.color ?? colorScheme.surface,
        indicatorColor: colorScheme.primary.withOpacity(0.1),
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.person, color: _selectedIndex == 0 ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)),
            label: localizations.profile,
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center, color: _selectedIndex == 1 ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)),
            label: localizations.workoutLog,
          ),
          NavigationDestination(
            icon: Icon(Icons.show_chart, color: _selectedIndex == 2 ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)),
            label: localizations.progress,
          ),
        ],
      ),
    );
  }
}

// Helper to convert DD.MM.YYYY to YYYY-MM-DD
String _convertDateToBackendFormat(String date) {
  final parts = date.split('.');
  if (parts.length == 3) {
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }
  return date;
}

// Helper to convert ISO date to DD.MM.YYYY
String formatDate(String isoDate) {
  try {
    final date = DateTime.parse(isoDate);
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  } catch (_) {
    return isoDate;
  }
} 