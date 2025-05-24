import 'package:hymn_song/model/verse.dart';
class Song {
  final int id;
  final String title;
  final String? subtitle;
  final String? photo;
  final String? keySignature;
  final String? meter;
  final List<Verse> verses;
  final List<String>? references;

  Song({
    required this.id,
    required this.title,
    this.subtitle,
    this.photo,
    this.keySignature,
    this.meter,
    required this.verses,
    this.references,
  });

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        id: json['id'],
        title: json['title'],
        subtitle: json['subtitle'],
        photo: json['photo'],
        keySignature: json['key'],
        meter: json['meter'],
        verses: (json['verses'] as List)
            .map((v) => Verse.fromJson(v))
            .toList(),
        references: json['references'] != null
            ? List<String>.from(json['references'])
            : null,
      );
}
