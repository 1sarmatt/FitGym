import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  int _selectedIndex = 2;

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _mockUsers = [
    {'email': 'alice@email.com', 'name': 'Alice'},
    {'email': 'bob@email.com', 'name': 'Bob'},
    
  ];
  List<Map<String, String>> _searchResults = [];
  List<Map<String, String>> _friends = [];
  String _searchError = '';

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

  void _searchFriend() {
    setState(() {
      _searchError = '';
      _searchResults.clear();
      final query = _searchController.text.trim().toLowerCase();
      if (query.isEmpty) {
        _searchError = 'Enter email to search.';
        return;
      }
      _searchResults = _mockUsers
          .where((user) => user['email']!.toLowerCase().contains(query))
          .toList();
      if (_searchResults.isEmpty) {
        _searchError = 'No users found.';
      }
    });
  }

  void _addFriend(Map<String, String> user) {
    setState(() {
      if (!_friends.any((f) => f['email'] == user['email'])) {
        _friends.add(user);
      }
    });
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
                      Text('Find Friends', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Enter email',
                                hintStyle: const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.grey[800],
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Colors.orangeAccent, width: 2),
                                ),
                              ),
                              onSubmitted: (_) => _searchFriend(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _searchFriend,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Icon(Icons.search),
                          ),
                        ],
                      ),
                      if (_searchError.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(_searchError, style: const TextStyle(color: Colors.redAccent)),
                        ),
                      if (_searchResults.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Search Results:', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                              ..._searchResults.map((user) => ListTile(
                                    leading: const Icon(Icons.person, color: Colors.orangeAccent),
                                    title: Text(user['name'] ?? '', style: const TextStyle(color: Colors.white)),
                                    subtitle: Text(user['email'] ?? '', style: const TextStyle(color: Colors.white70)),
                                    trailing: ElevatedButton(
                                      onPressed: () => _addFriend(user),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.greenAccent,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: const Text('Add'),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),
                      Text('Friends', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 12),
                      _friends.isEmpty
                          ? Center(child: Text('No friends yet. Add some!', style: TextStyle(color: Colors.white70)))
                          : Column(
                              children: _friends.map((friend) => ListTile(
                                    leading: const Icon(Icons.person, color: Colors.orangeAccent),
                                    title: Text(friend['name'] ?? '', style: const TextStyle(color: Colors.white)),
                                    subtitle: Text(friend['email'] ?? '', style: const TextStyle(color: Colors.white70)),
                                  )).toList(),
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
} 