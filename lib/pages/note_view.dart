import 'package:flutter/material.dart';
import 'package:hymn_song/model/song.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class MusicView extends StatefulWidget {
  final List<Song> songs;
  final int currentSongIndex;

  const MusicView({
    Key? key,
    required this.songs,
    required this.currentSongIndex,
  }) : super(key: key);

  @override
  State<MusicView> createState() => _MusicViewState();
}

class _MusicViewState extends State<MusicView> {
  double _fontScale = 1.0;
  double _baseFontScale = 1.0;
  static const double _minScale = 0.6;
  static const double _maxScale = 2.2;
  bool _scaling = false;

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

    return GestureDetector(
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
      onScaleEnd: (_) => _scaling = false,
      child: NotificationListener<ScrollNotification>(
        onNotification: (_) => _scaling,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.fontSize(20),
            vertical: SizeConfig.fontSize(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
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
              for (final verse in song.verses) ...[
                Text("V${verse.number}", style: verseNumStyle),
                SizedBox(height: SizeConfig.fontSize(8)),
                for (final block in verse.blocks)
                  _buildAlignedBlock(block, verseTextStyle, noteStyle),
                SizedBox(height: SizeConfig.fontSize(30)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlignedBlock(
    dynamic block,
    TextStyle verseTextStyle,
    TextStyle noteStyle,
  ) {
    final lyricsLines = block.lyricsLines;
    final noteLines = block.noteLines;
    final barGroups = block.barGroups;

    if (noteLines.length != 4) {
      return const Text("⚠️ Invalid noteLines count.");
    }

    final int columnCount = [
      noteLines[0].length,
      noteLines[1].length,
      noteLines[2].length,
      noteLines[3].length,
      ...lyricsLines.map((line) => line.length),
    ].reduce((a, b) => a < b ? a : b); // shortest shared length

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: List.generate(columnCount, (i) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Note line 0
            if (barGroups[0]?.any((g) => i >= g.from && i <= g.to) ?? false)
              Container(
                width: 20,
                height: 2,
                color: Colors.black,
                margin: const EdgeInsets.only(bottom: 4),
              )
            else
              const SizedBox(height: 6),
            Text(noteLines[0][i], style: noteStyle),

            // Note line 1
            if (barGroups[1]?.any((g) => i >= g.from && i <= g.to) ?? false)
              Container(
                width: 20,
                height: 2,
                color: Colors.black,
                margin: const EdgeInsets.only(bottom: 4),
              )
            else
              const SizedBox(height: 6),
            Text(noteLines[1][i], style: noteStyle),

            // Lyrics line(s)
            for (final line in lyricsLines)
              Text(line[i], style: verseTextStyle, textAlign: TextAlign.center),

            // Note line 2
            if (barGroups[2]?.any((g) => i >= g.from && i <= g.to) ?? false)
              Container(
                width: 20,
                height: 2,
                color: Colors.black,
                margin: const EdgeInsets.only(bottom: 4),
              )
            else
              const SizedBox(height: 6),
            Text(noteLines[2][i], style: noteStyle),

            // Note line 3
            if (barGroups[3]?.any((g) => i >= g.from && i <= g.to) ?? false)
              Container(
                width: 20,
                height: 2,
                color: Colors.black,
                margin: const EdgeInsets.only(bottom: 4),
              )
            else
              const SizedBox(height: 6),
            Text(noteLines[3][i], style: noteStyle),
          ],
        );
      }),
    );
  }
}
