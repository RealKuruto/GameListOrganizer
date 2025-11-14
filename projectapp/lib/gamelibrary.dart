import 'package:flutter/material.dart';
import 'addgamescreen.dart';
import 'game.dart';
import 'diary.dart';
import 'weather.dart';
import 'login.dart' show LoginScreen;

class GameLibraryPage extends StatefulWidget {
  const GameLibraryPage({super.key});

  @override
  State<GameLibraryPage> createState() => _GameLibraryPageState();
}

class _GameLibraryPageState extends State<GameLibraryPage> {
  String searchQuery = '';
  // Scroll controllers for each category to allow left/right scrolling via buttons
  final Map<String, ScrollController> _scrollControllers = {};
  final double _scrollAmount = 200.0;

  void _scrollLeft(String title) {
    final controller = _scrollControllers[title];
    if (controller == null || !controller.hasClients) return;
    final max = controller.position.maxScrollExtent;
    final newOffset = (controller.offset - _scrollAmount).clamp(0.0, max);
    controller.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight(String title) {
    final controller = _scrollControllers[title];
    if (controller == null || !controller.hasClients) return;
    final max = controller.position.maxScrollExtent;
    final newOffset = (controller.offset + _scrollAmount).clamp(0.0, max);
    controller.animateTo(
      newOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _openAddGameScreen(String category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddGamePage()),
    );

    if (result != null && result is Map) {
      final String name = (result['name'] ?? '').toString();
      final bool favorite = result['favorite'] == true;
      final bool recent = result['recent'] == true;
      final bool notPlayed = result['notPlayed'] == true;
      final String genre = (result['genre'] ?? '').toString();
      final String platform = (result['platform'] ?? 'Unknown').toString();
      final String coverUrl = (result['coverUrl'] ?? '').toString();

      setState(() {
        final g = Game(
          title: name,
          platform: platform.isNotEmpty ? platform : 'Unknown',
          genre: genre.isNotEmpty ? genre : 'Unknown',
          cover: coverUrl.isNotEmpty ? coverUrl : 'assets/images/noimage.PNG',
          isFavorite: favorite,
          isRecentlyPlayed: recent,
          isNotPlayed: notPlayed,
          todoList: List<String>.from(result['todoList'] ?? []),
        );

        // If editing (index provided) update, otherwise add
        if (result.containsKey('index') && result['index'] is int) {
          final idx = result['index'] as int;
          if (idx >= 0 && idx < gameLibrary.length) {
            gameLibrary[idx] = g;
          } else {
            gameLibrary.add(g);
          }
        } else {
          gameLibrary.add(g);
        }
      });
    }
  }

  Future<void> _openEditGame(Game existingGame, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddGamePage(initialGame: existingGame, index: index),
      ),
    );

    if (result != null && result is Map) {
      final String name = (result['name'] ?? '').toString();
      final bool favorite = result['favorite'] == true;
      final bool recent = result['recent'] == true;
      final bool notPlayed = result['notPlayed'] == true;
      final String genre = (result['genre'] ?? '').toString();
      final String platform = (result['platform'] ?? 'Unknown').toString();
      final String coverUrl = (result['coverUrl'] ?? '').toString();

      setState(() {
        final g = Game(
          title: name,
          platform: platform.isNotEmpty ? platform : 'Unknown',
          genre: genre.isNotEmpty ? genre : 'Unknown',
          cover: coverUrl.isNotEmpty ? coverUrl : 'assets/images/noimage.PNG',
          isFavorite: favorite,
          isRecentlyPlayed: recent,
          isNotPlayed: notPlayed,
          todoList: List<String>.from(result['todoList'] ?? []),
        );

        if (result.containsKey('index') && result['index'] is int) {
          final idx = result['index'] as int;
          if (idx >= 0 && idx < gameLibrary.length) {
            gameLibrary[idx] = g;
          }
        }
      });
    }
  }

  List<Game> _getFilteredGames(bool Function(Game) filter) {
    final base = gameLibrary.where(filter).toList();
    if (searchQuery.isEmpty) return base;
    return base
        .where((g) => g.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _scrollControllers.values) {
      try {
        c.dispose();
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3BA6C4),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: const Color(0xFFF7B500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "MY GAME\nLIBRARY",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF015C6B),
                      height: 1.1,
                    ),
                  ),
                  // Search bar
                  Container(
                    width: 180,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "Search",
                        border: InputBorder.none,
                        icon: Icon(Icons.search, size: 22, color: Colors.grey),
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategorySection(
                      "RECENTLY PLAYED",
                      (g) => g.isRecentlyPlayed,
                    ),
                    _buildCategorySection(
                      "GAME YOU HAVENT PLAYED",
                      (g) => g.isNotPlayed,
                    ),
                    _buildCategorySection("ALL GAMES", (g) => true),
                    _buildCategorySection("FAVORITES", (g) => g.isFavorite),
                    const SizedBox(height: 20),
                    // SECTION BUTTONS: navigate to filtered pages
                    _buildMenuButton("RECENTLY PLAYED", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameListPage(
                            title: 'Recently Played',
                            filter: (g) => g.isRecentlyPlayed,
                          ),
                        ),
                      );
                    }),
                    _buildMenuButton("GAME YOU HAVENT PLAYED", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameListPage(
                            title: "Games You Haven't Played",
                            filter: (g) => g.isNotPlayed,
                          ),
                        ),
                      );
                    }),
                    _buildMenuButton("ALL GAMES", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameListPage(
                            title: 'All Games',
                            filter: (g) => true,
                          ),
                        ),
                      );
                    }),
                    _buildMenuButton("FAVORITES", () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameListPage(
                            title: 'Favorites',
                            filter: (g) => g.isFavorite,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            // ---------------- BOTTOM NAV ----------------
            Container(
              height: 60,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/loginicon.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      _showLogoutConfirmation();
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/diaryicon.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DiaryScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/weatericon.png',
                      width: 30,
                      height: 30,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WeatherScreen(),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/logo.png',
                        width: 30,
                        height: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORY SECTION WITH ADD BUTTON
  Widget _buildCategorySection(String title, bool Function(Game) filter) {
    List<Game> filteredGames = _getFilteredGames(filter);

    final controller = _scrollControllers.putIfAbsent(
      title,
      () => ScrollController(),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 28),
                    onPressed: () => _openAddGameScreen(title),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_left, color: Colors.white),
                    onPressed: () => _scrollLeft(title),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right, color: Colors.white),
                    onPressed: () => _scrollRight(title),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Game cards with filtering
          // Game cards with filtering
          if (filteredGames.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'No games found',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            )
          else
            SizedBox(
              height: 140,
              child: ListView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: filteredGames.length,
                itemBuilder: (_, i) {
                  final g = filteredGames[i];
                  final originalIndex = gameLibrary.indexOf(g);
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // open editor for this game
                          if (originalIndex != -1) {
                            _openEditGame(g, originalIndex);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.shade100,
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: g.cover.startsWith('http')
                                  ? NetworkImage(g.cover) as ImageProvider
                                  : AssetImage(g.cover),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              color: Colors.white70,
                              child: Text(
                                g.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // delete button
                      Positioned(
                        right: 8,
                        top: 6,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(4),
                            iconSize: 18,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              if (originalIndex != -1) {
                                setState(() {
                                  gameLibrary.removeAt(originalIndex);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Game deleted')),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // MENU BUTTONS
  Widget _buildMenuButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A788A),
            ),
          ),
        ),
      ),
    );
  }
}

// Reusable filtered list page
class GameListPage extends StatefulWidget {
  final String title;
  final bool Function(Game) filter;

  const GameListPage({super.key, required this.title, required this.filter});

  @override
  State<GameListPage> createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  @override
  Widget build(BuildContext context) {
    final filteredGames = gameLibrary.where(widget.filter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF3BA6C4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7B500),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xFF035C6B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: filteredGames.isEmpty
          ? const Center(
              child: Text(
                "No games found.",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredGames.length,
              itemBuilder: (context, i) {
                final g = filteredGames[i];
                final origIndex = gameLibrary.indexOf(g);
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: g.cover.startsWith('http')
                                ? NetworkImage(g.cover) as ImageProvider
                                : AssetImage(g.cover),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              g.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF035C6B),
                              ),
                            ),
                            Text(
                              "Platform: ${g.platform}",
                              style: const TextStyle(color: Color(0xFF035C6B)),
                            ),
                            Text(
                              "Genre: ${g.genre}",
                              style: const TextStyle(color: Color(0xFF035C6B)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              if (origIndex == -1) return;
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddGamePage(
                                    initialGame: g,
                                    index: origIndex,
                                  ),
                                ),
                              );
                              if (result != null && result is Map) {
                                final String name = (result['name'] ?? '')
                                    .toString();
                                final bool favorite =
                                    result['favorite'] == true;
                                final bool recent = result['recent'] == true;
                                final bool notPlayed =
                                    result['notPlayed'] == true;
                                final String genre = (result['genre'] ?? '')
                                    .toString();
                                final String platform =
                                    (result['platform'] ?? 'Unknown')
                                        .toString();
                                final String coverUrl =
                                    (result['coverUrl'] ?? '').toString();

                                setState(() {
                                  final updated = Game(
                                    title: name,
                                    platform: platform.isNotEmpty
                                        ? platform
                                        : 'Unknown',
                                    genre: genre.isNotEmpty ? genre : 'Unknown',
                                    cover: coverUrl.isNotEmpty
                                        ? coverUrl
                                        : 'assets/images/noimage.PNG',
                                    isFavorite: favorite,
                                    isRecentlyPlayed: recent,
                                    isNotPlayed: notPlayed,
                                    todoList: List<String>.from(
                                      result['todoList'] ?? [],
                                    ),
                                  );
                                  if (result.containsKey('index') &&
                                      result['index'] is int) {
                                    final idx = result['index'] as int;
                                    if (idx >= 0 && idx < gameLibrary.length) {
                                      gameLibrary[idx] = updated;
                                    }
                                  }
                                });
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              if (origIndex != -1) {
                                setState(() {
                                  gameLibrary.removeAt(origIndex);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Game deleted')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
