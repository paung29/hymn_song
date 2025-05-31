import 'package:flutter/material.dart';
import 'package:hymn_song/data_save.dart';
import 'package:hymn_song/model/song.dart';
import 'package:hymn_song/pages/about_this_app.dart';
import 'package:hymn_song/utils/colors_data.dart';

class MenuPage extends StatefulWidget {
  final List<Song> songs;
  const MenuPage({Key? key, required this.songs}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<int> _lastReadIds = [];
  List<int> _bookmarkIds = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await SongStorage.loadHistory();
    final bookmarks = await SongStorage.loadBookmarks();
    setState(() {
      _lastReadIds = history;
      _bookmarkIds = bookmarks;
    });
  }

  // Helper to get Song title by id
  String _songTitle(int id) {
    final song = widget.songs.firstWhere((s) => s.id == id, orElse: () => Song(id: id, title: "Song $id", verses: []));
    return "${song.id}. ${song.title}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Menu', style: TextStyle(color: ColorsData.secondary_white)),
        centerTitle: true,
        backgroundColor: ColorsData.primary,
        foregroundColor: ColorsData.secondary_white,
        elevation: 0.7,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
        children: [
          _sectionHeader("Last Read"),
          if (_lastReadIds.isEmpty)
            _simpleTile(icon: Icons.history, title: "No history yet.", onTap: () {}),
          ..._lastReadIds.map((id) => _simpleTile(
                icon: Icons.history,
                title: _songTitle(id),
                onTap: () {
                  // Go to song page or something
                  Navigator.pop(context, id); // Pass songId back if you want
                },
              )),
          const SizedBox(height: 18),
          _sectionHeader("Bookmarks"),
          if (_bookmarkIds.isEmpty)
            _simpleTile(icon: Icons.bookmark_border, title: "No bookmarks yet.", onTap: () {}),
          ..._bookmarkIds.map((id) => _simpleTile(
                icon: Icons.bookmark_border,
                title: _songTitle(id),
                onTap: () {
                  // Go to song page or something
                  Navigator.pop(context, id); // Pass songId back if you want
                },
              )),
          const SizedBox(height: 18),
          _sectionHeader("Theme"),
          _simpleTile(
            icon: Icons.dark_mode_outlined,
            title: "Change Theme",
            onTap: () {
              // ...
            },
          ),
          const SizedBox(height: 18),
          _sectionHeader("Why I built this app"),
          _simpleTile(
            icon: Icons.mail,
            title: "From a promise to a purpose",
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutThisApp()));
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 0, 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
      );

  Widget _simpleTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      leading: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.deepPurple, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.black26),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      hoverColor: Colors.grey[200],
    );
  }
}