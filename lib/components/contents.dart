import 'package:flutter/material.dart';
import 'package:hymn_song/data_save.dart';
import 'package:hymn_song/model/song.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class Contents extends StatefulWidget {
  final List<Song> songs;
  final int currentSongIndex;

  const Contents({
    super.key,
    required this.songs,
    required this.currentSongIndex,
  });

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  double _fontScale = 1.0;
  double _baseFontScale = 1.0;
  static const double _minScale = 0.6;
  static const double _maxScale = 2.2;
  bool _scaling = false;

  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarkState();
    _saveToHistory();
  }

  void _loadBookmarkState() async {
    final bookmarks = await SongStorage.loadBookmarks();
    final idx = widget.currentSongIndex.clamp(0, widget.songs.length - 1);
    final songId = widget.songs[idx].id;
    setState(() {
      _isBookmarked = bookmarks.contains(songId);
    });
  }

  void _toggleBookmark() async {
    final idx = widget.currentSongIndex.clamp(0, widget.songs.length - 1);
    final songId = widget.songs[idx].id;
    await SongStorage.toggleBookmark(songId);
    _loadBookmarkState(); // Refresh icon
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? "Bookmark removed" : "Bookmarked!"),
      ),
    );
  }

  void _saveToHistory() async {
    final idx = widget.currentSongIndex.clamp(0, widget.songs.length - 1);
    final songId = widget.songs[idx].id;
    await SongStorage.addSongToHistory(songId);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final idx = widget.currentSongIndex.clamp(0, widget.songs.length - 1);
    final song = widget.songs[idx];

    final verseNumStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize:
          SizeConfig.fontSize(SizeConfig.isTabletDevice ? 24 : 18) * _fontScale,
      fontFamily: 'GasoekOne',
    );
    final verseTextStyle = TextStyle(
      fontSize:
          SizeConfig.fontSize(SizeConfig.isTabletDevice ? 20 : 15) * _fontScale,
      height: 1.5,
      fontFamily: 'GasoekOne',
    );
    final noteStyle = TextStyle(
      fontSize: SizeConfig.fontSize(12) * _fontScale,
      color: Colors.blueGrey,
      fontFamily: 'monospace',
    );

    const bottomNavHeight = 60.0;

    return SizedBox.expand(
      child: Stack(
        children: [
          Listener(
            onPointerSignal: (_) {},
            child: GestureDetector(
              onScaleStart: (details) {
                _scaling = true;
                _baseFontScale = _fontScale;
              },
              onScaleUpdate: (details) {
                if (details.pointerCount > 1) {
                  setState(() {
                    _fontScale = (_baseFontScale * details.scale).clamp(
                      _minScale,
                      _maxScale,
                    );
                  });
                }
              },
              onScaleEnd: (_) {
                _scaling = false;
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (_) => _scaling,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.fontSize(20),
                      vertical: SizeConfig.fontSize(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                song.title,
                                style: verseNumStyle.copyWith(
                                  fontSize: verseNumStyle.fontSize! + 2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (song.subtitle != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Text(
                                    song.subtitle!,
                                    style: verseTextStyle.copyWith(
                                      fontSize: verseTextStyle.fontSize! - 2,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Render verses and lyric blocks
                        for (final verse in song.verses) ...[
                          Text("V${verse.number}", style: verseNumStyle),
                          SizedBox(height: SizeConfig.fontSize(8) * _fontScale),

                          for (final block in verse.blocks)
                            for (final line in block.lyricsLines)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        line.join(' '),
                                        style: verseTextStyle,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "⏎",
                                      style: verseTextStyle.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                          SizedBox(
                            height: SizeConfig.fontSize(30) * _fontScale,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 24,
            bottom: bottomNavHeight + 20,
            child: FloatingActionButton(
              heroTag: "bookmarkBtn",
              mini: true,
              onPressed: _toggleBookmark,
              backgroundColor: Colors.white,
              child: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.deepPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
