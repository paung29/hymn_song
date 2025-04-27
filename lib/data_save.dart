import 'package:shared_preferences/shared_preferences.dart';

class SongStorage {
  // --- Bookmarks ---
  static Future<List<int>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('bookmarks') ?? [];
    return ids.map(int.parse).toList();
  }

  static Future<void> toggleBookmark(int songId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('bookmarks') ?? [];
    if (ids.contains(songId.toString())) {
      ids.remove(songId.toString());
    } else {
      ids.add(songId.toString());
    }
    await prefs.setStringList('bookmarks', ids);
  }

  // --- History (Stack for Last 3 Songs) ---
  static Future<List<int>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('history') ?? [];
    return ids.map(int.parse).toList();
  }

  static Future<void> addSongToHistory(int songId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];
    history.remove(songId.toString());
    history.insert(0, songId.toString()); // Most recent on top
    if (history.length > 3) history = history.sublist(0, 3);
    await prefs.setStringList('history', history);
  }
}