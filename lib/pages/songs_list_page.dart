import 'package:flutter/material.dart';
import 'package:hymn_song/model/song.dart';

class SongListScreen extends StatelessWidget {
  final List<Song> songs;
  final int? selectedId;
  final ValueChanged<int> onSongSelected;

  const SongListScreen({
    Key? key,
    required this.songs,
    this.selectedId,
    required this.onSongSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No title text in AppBar
      appBar: AppBar(
        backgroundColor: const Color(0xFF624E5B),
        foregroundColor: Colors.white,
        elevation: 0.8,
        leading: BackButton(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF624E5B),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        itemCount: songs.length,
        separatorBuilder: (context, i) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final song = songs[i];
          final isSelected = selectedId == song.id;
          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              onSongSelected(i);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white24 : const Color(0xFF7B6471),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.black,
                  width: isSelected ? 2 : 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
      ),
    );
  }
}