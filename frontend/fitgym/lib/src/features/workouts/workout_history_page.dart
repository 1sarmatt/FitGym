import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'workout_model.dart';

class WorkoutHistoryPage extends StatefulWidget {
  const WorkoutHistoryPage({Key? key}) : super(key: key);

  @override
  State<WorkoutHistoryPage> createState() => _WorkoutHistoryPageState();
}

class _WorkoutHistoryPageState extends State<WorkoutHistoryPage> {
  int _selectedIndex = 2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouter.of(context).location;
    int idx = 2;
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

  @override
  Widget build(BuildContext context) {
    final history = context.watch<WorkoutModel>().history;
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
                          Text('Workout History',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const SizedBox(height: 24),
                      history.isEmpty
                          ? Center(
                              child: Text('No completed workouts yet.', style: TextStyle(color: Colors.white70)),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: history.length,
                              separatorBuilder: (_, __) => Divider(color: Colors.orangeAccent.withOpacity(0.2)),
                              itemBuilder: (context, i) {
                                final w = history[i];
                                return ListTile(
                                  leading: Icon(Icons.check_circle, color: Colors.green),
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