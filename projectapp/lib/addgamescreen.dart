import 'package:flutter/material.dart';
import 'game.dart';

class AddGamePage extends StatefulWidget {
  final Game? initialGame;
  final int? index;

  const AddGamePage({super.key, this.initialGame, this.index});

  @override
  State<AddGamePage> createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  bool addFavorite = true;
  bool addRecently = true;
  bool addNotPlayed = false;

  List<String> todoList = ["Finish the game by this month", "Build a Base"];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _coverUrlController = TextEditingController();
  final List<TextEditingController> _todoControllers = [];

  String selectedGenre = 'SURVIVAL';
  final List<String> genres = [
    'SURVIVAL',
    'RPG',
    'ACTION',
    'ADVENTURE',
    'STRATEGY',
    'SIMULATION',
  ];

  String selectedPlatform = 'STEAM';
  final List<String> platforms = [
    'STEAM',
    'EPIC',
    'EA',
    'UBISOFT',
    'PLAYSTATION',
    'XBOX',
    'NINTENDO',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _coverUrlController.dispose();
    for (final c in _todoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialGame != null) {
      final g = widget.initialGame!;
      _titleController.text = g.title;
      _coverUrlController.text = g.cover;
      addFavorite = g.isFavorite;
      addRecently = g.isRecentlyPlayed;
      addNotPlayed = g.isNotPlayed;
      selectedGenre = g.genre;
      selectedPlatform = g.platform;
      todoList = List<String>.from(g.todoList);
    }

    // initialize controllers for existing todos (either defaults or from initialGame)
    _todoControllers.clear();
    for (final t in todoList) {
      _todoControllers.add(TextEditingController(text: t));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3BA6C4),
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBCEFFF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        // Title field
                        TextField(
                          controller: _titleController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Game title',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        buildCover(),

                        const SizedBox(height: 15),

                        buildToggles(),

                        const SizedBox(height: 20),

                        buildToDo(),

                        const SizedBox(height: 20),

                        buildDetails(),

                        const SizedBox(height: 25),

                        buildButtons(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget buildHeader() {
    return Container(
      color: const Color(0xFFF7B500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "MY GAME\nLIBRARY",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF035C6B),
            ),
          ),
          Container(
            width: 170,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 6),
                Text("Search", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- COVER IMAGE ----------------
  Widget buildCover() {
    final coverUrl = _coverUrlController.text.trim();
    return Column(
      children: [
        Container(
          height: 220,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            image: coverUrl.isEmpty
                ? const DecorationImage(
                    image: AssetImage("assets/images/noimage.PNG"),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: coverUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    coverUrl,
                    fit: BoxFit.cover,
                    width: 220,
                    height: 220,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _coverUrlController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Cover image URL (optional)',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- TOGGLE BOXES ----------------
  Widget buildToggles() {
    return Column(
      children: [
        toggleItem("ADD TO FAVORITES", addFavorite, (value) {
          setState(() => addFavorite = value);
        }),
        toggleItem("ADD TO RECENTLY PLAYED", addRecently, (value) {
          setState(() => addRecently = value);
        }),
        toggleItem("GAME YOU HAVENT PLAYED", addNotPlayed, (value) {
          setState(() => addNotPlayed = value);
        }),
      ],
    );
  }

  Widget toggleItem(String text, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 17,
                color: Color(0xFF136B7A),
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => onChanged(!value),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0073A1), width: 2),
                  borderRadius: BorderRadius.circular(6),
                  color: value ? const Color(0xFFF7B500) : Colors.transparent,
                ),
                child: value
                    ? const Icon(Icons.check, size: 18, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TODO LIST ----------------
  Widget buildToDo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "To Do List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A788A),
            ),
          ),
          const Divider(color: Color(0xFFF7B500), thickness: 2),

          // editable todo items
          ...List.generate(_todoControllers.length, (index) {
            final controller = _todoControllers[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'To-do item',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _todoControllers.removeAt(index).dispose();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7B500),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      final c = TextEditingController();
                      _todoControllers.add(c);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '+ Add To-do',
                      style: TextStyle(color: Color(0xFF0A788A)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- DETAILS ----------------
  Widget buildDetails() {
    final title = _titleController.text.trim().isEmpty
        ? 'GAME TITLE'
        : _titleController.text.trim();
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            color: Color(0xFF0A788A),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PLATFORM : ',
              style: TextStyle(fontSize: 17, color: Color(0xFF0A788A)),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedPlatform,
              dropdownColor: const Color(0xFFBCEFFF),
              items: platforms
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() {
                if (v != null) selectedPlatform = v;
              }),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GENRE : ',
              style: TextStyle(fontSize: 17, color: Color(0xFF0A788A)),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedGenre,
              dropdownColor: const Color(0xFFBCEFFF),
              items: genres
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() {
                if (v != null) selectedGenre = v;
              }),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- BUTTONS ----------------
  Widget buildButtons() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            final title = _titleController.text.trim();
            if (title.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter a game title')),
              );
              return;
            }

            // collect todos
            final todos = _todoControllers
                .map((c) => c.text.trim())
                .where((s) => s.isNotEmpty)
                .toList();

            // return data to previous screen
            final resultMap = {
              'name': title,
              'favorite': addFavorite,
              'recent': addRecently,
              'notPlayed': addNotPlayed,
              'genre': selectedGenre,
              'platform': selectedPlatform,
              'coverUrl': _coverUrlController.text.trim(),
              'todoList': todos,
            };
            if (widget.index != null) resultMap['index'] = widget.index!;

            Navigator.pop(context, resultMap);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFF7B500),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.initialGame != null ? "SAVE CHANGES" : "ADD THE GAME",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: const Text(
              "CANCEL",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF005B6E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- BOTTOM NAV ----------------
  Widget buildBottomNav() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.games),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.games),
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Diary'))),
          ),
          IconButton(
            icon: const Icon(Icons.games),
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Weather'))),
          ),
          IconButton(icon: const Icon(Icons.games), onPressed: () {}),
        ],
      ),
    );
  }
}
