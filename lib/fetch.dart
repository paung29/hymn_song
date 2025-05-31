import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hymn_song/model/responsive.dart';
import 'package:hymn_song/model/song.dart';

Future<List<Song>> loadSongs() async {
  final jsonStr = await rootBundle.loadString('assets/songs.json');
  final List<dynamic> jsonData = json.decode(jsonStr);
  return jsonData.map((e) => Song.fromJson(e)).toList();
}

Future<List<ResponsiveReading>> loadReadings() async {
  final jsonStr = await rootBundle.loadString('assets/responsive.json');
  final List<dynamic> jsonData = json.decode(jsonStr);
  return jsonData.map((e) => ResponsiveReading.fromJson(e)).toList();
}