import 'package:hymn_song/model/word_note.dart';

class Verse {
  final int number;
  final List<LyricBlock> blocks;

  Verse({required this.number, required this.blocks});

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        number: json['number'],
        blocks: (json['blocks'] as List)
            .map((b) => LyricBlock.fromJson(b))
            .toList(),
      );
}

