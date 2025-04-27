import 'package:flutter/material.dart';
import 'package:hymn_song/model/song.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class MusicView extends StatelessWidget {
  final List<Song> songs;
  final int currentSongIndex;

  const MusicView({
    Key? key,
    required this.songs,
    required this.currentSongIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final idx = currentSongIndex.clamp(0, songs.length - 1);
    final song = songs[idx];

    final verseNumStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: SizeConfig.fontSize(SizeConfig.isTabletDevice ? 24 : 18),
      fontFamily: 'GasoekOne',
    );
    final verseTextStyle = TextStyle(
      fontSize: SizeConfig.fontSize(SizeConfig.isTabletDevice ? 20 : 15),
      height: 1.5,
      fontFamily: 'GasoekOne',
    );
    final noteStyle = TextStyle(
      fontSize: SizeConfig.fontSize(12),
      color: Colors.blueGrey,
      fontFamily: 'monospace',
    );

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.fontSize(20),
          vertical: SizeConfig.fontSize(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and subtitle (optional)
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    song.title,
                    style: verseNumStyle.copyWith(fontSize: verseNumStyle.fontSize! + 2),
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
            // Each verse
            for (final verse in song.verses) ...[
              Text("V${verse.number}", style: verseNumStyle),
              SizedBox(height: SizeConfig.fontSize(8)),
              for (final line in verse.lines)
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    for (final wordNote in line) ...[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Show the note ABOVE the word
                          if (wordNote.notes != null && wordNote.notes!.isNotEmpty)
                            Text(wordNote.notes!.join('   '), style: noteStyle, textAlign: TextAlign.center),
                          Text(wordNote.word, style: verseTextStyle, textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(width: 6),
                    ]
                  ],
                ),
              SizedBox(height: SizeConfig.fontSize(30)),
            ],
          ],
        ),
      ),
    );
  }
}