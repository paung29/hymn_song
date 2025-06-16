class BarGroup {
  final int from;
  final int to;

  BarGroup({required this.from, required this.to});

  factory BarGroup.fromJson(Map<String, dynamic> json) => BarGroup(
        from: json['from'],
        to: json['to'],
      );
}

class LyricBlock {
  final List<List<String>> noteLines;
  final List<List<String>> lyricsLines;
  final Map<int, List<BarGroup>> barGroups;

  LyricBlock({
    required this.noteLines,
    required this.lyricsLines,
    this.barGroups = const {},
  });

  factory LyricBlock.fromJson(Map<String, dynamic> json) => LyricBlock(
        noteLines: (json['noteLines'] as List)
            .map((line) => List<String>.from(line))
            .toList(),
        lyricsLines: (json['lyricsLines'] as List)
            .map((line) => List<String>.from(line))
            .toList(),
        barGroups: (json['barGroups'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(
                int.parse(key),
                (value as List)
                    .map((e) => BarGroup.fromJson(e))
                    .toList(),
              ),
            ) ??
            {},
      );
}