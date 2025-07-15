import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../common/api.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  int _selectedIndex = 2;

  final TextEditingController _emailController = TextEditingController();
  List<String> _friends = [];
  String _addError = '';
  String _addSuccess = '';
  bool _loading = false;

  // For friend progress expansion
  String? _expandedFriendEmail;
  List<dynamic> _expandedFriendHistory = [];
  bool _loadingFriendStats = false;
  String _friendError = '';

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    setState(() { _loading = true; });
    try {
      final response = await ApiService.getFriends();
      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(jsonDecode(response.body));
        setState(() {
          _friends = data.map((e) => e.toString()).toList();
          _addError = '';
        });
      } else {
        setState(() { _addError = 'Failed to load friends.'; });
      }
    } catch (e) {
      setState(() { _addError = 'Error: $e'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _addFriend() async {
    setState(() { _addError = ''; _addSuccess = ''; });
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() { _addError = 'Enter email.'; });
      return;
    }
    setState(() { _loading = true; });
    try {
      final response = await ApiService.addFriend(email);
      if (response.statusCode == 200) {
        setState(() { _addSuccess = 'Friend added!'; });
        _emailController.clear();
        await _fetchFriends();
      } else {
        setState(() { _addError = 'Failed to add friend.'; });
      }
    } catch (e) {
      setState(() { _addError = 'Error: $e'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _expandFriend(String email) async {
    setState(() {
      _expandedFriendEmail = email;
      _loadingFriendStats = true;
      _friendError = '';
      _expandedFriendHistory = [];
    });
    try {
      final response = await ApiService.getFriendWorkoutHistoryByEmail(email);
      if (response.statusCode == 200) {
        final List<dynamic> data = List.from(jsonDecode(response.body));
        setState(() {
          _expandedFriendHistory = data;
        });
      } else {
        setState(() { _friendError = 'Failed to load friend\'s stats.'; });
      }
    } catch (e) {
      setState(() { _friendError = 'Error: $e'; });
    } finally {
      setState(() { _loadingFriendStats = false; });
    }
  }

  void _collapseFriend() {
    setState(() {
      _expandedFriendEmail = null;
      _expandedFriendHistory = [];
      _friendError = '';
    });
  }

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        context.go('/profile');
        break;
      case 1:
        context.go('/progress');
        break;
      case 2:
        context.go('/social');
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
                          Text('Social',
                              style: TextStyle(
                                color: Colors.orangeAccent,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Add Friend', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter friend\'s email',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
                                ),
                              ),
                              onSubmitted: (_) => _addFriend(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _loading ? null : _addFriend,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _loading ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black)) : const Icon(Icons.person_add),
                          ),
                        ],
                      ),
                      if (_addError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_addError, style: const TextStyle(color: Colors.redAccent)),
                        ),
                      if (_addSuccess.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_addSuccess, style: const TextStyle(color: Colors.greenAccent)),
                        ),
                      const SizedBox(height: 24),
                      Text('Friends', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      _loading
                          ? Center(child: CircularProgressIndicator())
                          : _friends.isEmpty
                              ? Center(child: Text('No friends yet. Add some!', style: TextStyle(color: Colors.white70)))
                              : Column(
                                  children: _friends.map((email) {
                                    final isExpanded = _expandedFriendEmail == email;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.person, color: Colors.orangeAccent),
                                          title: Text(email, style: const TextStyle(color: Colors.white)),
                                          onTap: isExpanded ? null : () => _expandFriend(email),
                                          trailing: isExpanded
                                              ? IconButton(
                                                  icon: const Icon(Icons.close, color: Colors.orangeAccent),
                                                  onPressed: _collapseFriend,
                                                )
                                              : null,
                                        ),
                                        if (isExpanded)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 16.0),
                                            child: _loadingFriendStats
                                                ? const Center(child: CircularProgressIndicator())
                                                : _friendError.isNotEmpty
                                                    ? Text(_friendError, style: const TextStyle(color: Colors.redAccent))
                                                    : _expandedFriendHistory.isEmpty
                                                        ? Text('No completed workouts yet.', style: TextStyle(color: Colors.white70))
                                                        : _buildFriendProgress(_expandedFriendHistory),
                                          ),
                                      ],
                                    );
                                  }).toList(),
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
            icon: Icon(Icons.show_chart),
            label: 'Progress',
            tooltip: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: 'Social',
            tooltip: '',
          ),
        ],
      ),
    );
  }

  Widget _buildFriendProgress(List<dynamic> history) {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Workouts', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                Text('$totalWorkouts', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Most Frequent', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(mostFrequentType.isNotEmpty ? mostFrequentType : '-', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('Recent Workouts', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length > 5 ? 5 : history.length,
          separatorBuilder: (_, __) => Divider(color: Colors.orangeAccent.withOpacity(0.2)),
          itemBuilder: (context, i) {
            final w = history[i];
            return ListTile(
              leading: Icon(Icons.check_circle, color: Colors.greenAccent),
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
    );
  }
} 