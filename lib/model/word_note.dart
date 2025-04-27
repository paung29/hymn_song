class WordNote {
  final String word;
  final List<String>? notes;

  WordNote({required this.word, this.notes});

  factory WordNote.fromJson(Map<String, dynamic> json) => WordNote(
    word: json['word'],
    notes: json['notes'] != null ? List<String>.from(json['notes']) : null,
  );
}
