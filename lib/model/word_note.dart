class LyricBlock {
  final List<List<String>> noteLines;     // 4 lines of notes
  final List<List<String>> lyricsLines;   // 1-N lines of lyrics (each line = list of words)

  LyricBlock({
    required this.noteLines,
    required this.lyricsLines,
  });

  factory LyricBlock.fromJson(Map<String, dynamic> json) => LyricBlock(
        noteLines: (json['noteLines'] as List)
            .map((line) => List<String>.from(line))
            .toList(),
        lyricsLines: (json['lyricsLines'] as List)
            .map((line) => List<String>.from(line))
            .toList(),
      );
}