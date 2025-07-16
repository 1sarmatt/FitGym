import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../workouts/workout_model.dart';
import 'package:fitgym/l10n/app_localizations.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({Key? key}) : super(key: key);

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int _selectedIndex = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouter.of(context).location;
    int idx = 0;
    if (location == '/profile') idx = 0;
    else if (location == '/workout-log') idx = 1;
    else if (location == '/progress') idx = 2;
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
        context.go('/progress');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<WorkoutModel>().history;
    // Calculate summary
    int totalWorkouts = history.length;
    Map<String, int> typeCount = {};
    for (var w in history) {
      final type = w['type'] ?? '';
      if (type.isNotEmpty) typeCount[type] = (typeCount[type] ?? 0) + 1;
    }
    String mostFrequentType = '';
    int maxCount = 0;
    typeCount.forEach((type, count) {
      if (count > maxCount) {
        mostFrequentType = type;
        maxCount = count;
      }
    });

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
                          Text(localizations.progress,
                              style: textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(localizations.totalWorkouts, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text('$totalWorkouts', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground, fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(localizations.mostFrequent, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(mostFrequentType.isNotEmpty ? mostFrequentType : '-', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground, fontSize: 20, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(localizations.recentWorkouts, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      history.isEmpty
                          ? Center(child: Text(localizations.noCompletedWorkoutsYet, style: textTheme.bodyMedium))
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: history.length > 5 ? 5 : history.length,
                              separatorBuilder: (_, __) => Divider(color: Colors.orangeAccent.withOpacity(0.2)),
                              itemBuilder: (context, i) {
                                final w = history[i];
                                final exercises = (w != null && w['exercises'] is Iterable) ? w['exercises'] as Iterable : const [];
                                return ListTile(
                                  leading: Icon(Icons.check_circle, color: Colors.greenAccent),
                                  title: Text(w['type'] ?? '', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(w['date'] ?? '', style: TextStyle(color: Colors.orangeAccent, fontSize: 13)),
                                      if ((w['notes'] ?? '').isNotEmpty)
                                        Text(w['notes']!, style: TextStyle(color: Colors.white70, fontSize: 13)),
                                      if (exercises.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(localizations.exercisesLabel, style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                                              ...List<Widget>.from(exercises.map((ex) => Text(
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