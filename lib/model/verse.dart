import 'package:hymn_song/model/word_note.dart';

class Verse {
  final int number;
  final List<List<WordNote>> lines;

  Verse({required this.number, required this.lines});

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
    number: json['number'],
    lines: (json['lines'] as List).map((line) =>
      (line as List).map((w) => WordNote.fromJson(w)).toList()
    ).toList(),
  );
}