class Game {
  String title;
  String platform;
  String genre;
  String cover;
  bool isFavorite;
  bool isRecentlyPlayed;
  bool isNotPlayed;
  List<String> todoList;

  Game({
    required this.title,
    required this.platform,
    required this.genre,
    required this.cover,
    this.isFavorite = false,
    this.isRecentlyPlayed = false,
    this.isNotPlayed = false,
    List<String>? todoList,
  }) : todoList = todoList ?? const [];
}

// Temporary in-memory sample library. Replace with persistent storage later.
List<Game> gameLibrary = [];
