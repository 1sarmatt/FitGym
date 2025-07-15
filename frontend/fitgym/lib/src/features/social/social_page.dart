import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../../common/api.dart';
import 'package:fitgym/l10n/app_localizations.dart';

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
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List ? decoded : [];
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
          _expandedFriendHistory = (data ?? []) as List<dynamic>;
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
                          Text(localizations.socialTitle,
                              style: textTheme.titleLarge?.copyWith(color: colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(localizations.addFriend, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                              decoration: InputDecoration(
                                hintText: localizations.enterFriendEmail,
                                hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.5)),
                                filled: true,
                                fillColor: theme.cardColor,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                ),
                              ),
                              onSubmitted: (_) => _addFriend(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _loading ? null : _addFriend,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _loading ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: colorScheme.onPrimary)) : const Icon(Icons.person_add),
                          ),
                        ],
                      ),
                      if (_addError.isNotEmpty && !_addError.contains("type 'Null' is not a subtype of type 'Iterable'"))
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_addError, style: TextStyle(color: colorScheme.error)),
                        ),
                      if (_addSuccess.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_addSuccess, style: TextStyle(color: Colors.green)),
                        ),
                      const SizedBox(height: 24),
                      Text(localizations.friends, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      _loading
                          ? Center(child: CircularProgressIndicator())
                          : _friends.isEmpty
                              ? Center(child: Text(localizations.noFriendsYet, style: textTheme.bodyMedium))
                              : Column(
                                  children: _friends.map((email) {
                                    final isExpanded = _expandedFriendEmail == email;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.person, color: colorScheme.primary),
                                          title: Text(email, style: textTheme.bodyLarge),
                                          onTap: isExpanded ? null : () => _expandFriend(email),
                                          trailing: isExpanded
                                              ? IconButton(
                                                  icon: Icon(Icons.close, color: colorScheme.primary),
                                                  onPressed: _collapseFriend,
                                                )
                                              : null,
                                        ),
                                        if (isExpanded)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 16.0),
                                            child: _loadingFriendStats
                                                ? const Center(child: CircularProgressIndicator())
                                                : _friendError.isNotEmpty && !_friendError.contains("type 'Null' is not a subtype of type 'Iterable'")
                                                    ? Text(_friendError, style: TextStyle(color: colorScheme.error))
                                                    : _expandedFriendHistory.isEmpty
                                                        ? Text(localizations.noCompletedWorkoutsYet, style: textTheme.bodyMedium)
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
            icon: Icon(Icons.show_chart, color: _selectedIndex == 1 ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)),
            label: localizations.progress,
          ),
          NavigationDestination(
            icon: Icon(Icons.people, color: _selectedIndex == 2 ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.7)),
            label: localizations.socialTitle,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(height: 16),
        Text(localizations.recentWorkouts, style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length > 5 ? 5 : history.length,
          separatorBuilder: (_, __) => Divider(color: colorScheme.primary.withOpacity(0.2)),
          itemBuilder: (context, i) {
            final w = history[i];
            final exercises = (w != null && w['exercises'] is Iterable) ? w['exercises'] as Iterable : const [];
            return ListTile(
              leading: Icon(Icons.check_circle, color: Colors.greenAccent),
              title: Text(w['type'] ?? '', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(w['date'] ?? '', style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontSize: 13)),
                  if ((w['notes'] ?? '').isNotEmpty)
                    Text(w['notes']!, style: textTheme.bodyMedium?.copyWith(fontSize: 13)),
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
    );
  }
} 