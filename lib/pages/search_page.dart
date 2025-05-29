import 'package:flutter/material.dart';
import 'package:hymn_song/model/song.dart';

class SearchPage extends StatefulWidget {
  final List<Song> songs;

  const SearchPage({super.key, required this.songs});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Song> _filteredSongs = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    _filteredSongs = []; // no results initially
  }

  void _onSearchChanged() {
    final query = _controller.text.toLowerCase();
    setState(() {
      _filteredSongs =
          widget.songs.where((song) {
            return song.title.toLowerCase().contains(query) ||
                song.id.toString().contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectSong(int index) {
    Navigator.pop(context, index); // Return the selected index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF624E5B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF624E5B),
        foregroundColor: Colors.white,
        elevation: 0.8,
        title: TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search by ID or Title',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          final hasInput = _controller.text.isNotEmpty;

          if (!hasInput) {
            return const Center(
              child: Text(
                "Search songs by ID or title",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          if (_filteredSongs.isEmpty) {
            return const Center(
              child: Text(
                "No matching songs found",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            itemCount: _filteredSongs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final song = _filteredSongs[i];
              final indexInOriginal = widget.songs.indexWhere(
                (s) => s.id == song.id,
              );

              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _selectSong(indexInOriginal),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B6471),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Text(
                        "${song.id}",
                        style: const TextStyle(
                          fontFamily: 'GasoekOne',
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 1,
                              color: Colors.black26,
                              offset: Offset(0.5, 1.2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 28),
                      Expanded(
                        child: Text(
                          song.title,
                          style: const TextStyle(
                            fontFamily: 'GasoekOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 1.05,
                            shadows: [
                              Shadow(
                                blurRadius: 0.5,
                                color: Colors.black26,
                                offset: Offset(0.2, 0.8),
                              ),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
