import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hymn_song/components/app_bar.dart';
import 'package:hymn_song/components/custom_bottom_nav_bar.dart';
import 'package:hymn_song/model/responsive.dart';
import 'package:hymn_song/pages/menu_page.dart';
import 'package:hymn_song/pages/note_view.dart';
import 'package:hymn_song/pages/responsive_reading.dart';
import 'package:hymn_song/pages/search_page.dart';
import 'package:hymn_song/pages/songs_list_page.dart';
import 'package:hymn_song/utils/colors_data.dart';
import 'package:hymn_song/utils/secreen_size.dart';
import 'package:hymn_song/model/song.dart';
import 'package:hymn_song/fetch.dart';
import 'package:hymn_song/components/contents.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _currentSongIndex = 0;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        loadSongs(),
        loadReadings(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        final songs = snapshot.data![0] as List<Song>;
        final readings = snapshot.data![1] as List<ResponsiveReading>;

        if (songs.isEmpty) {
          return const Scaffold(body: Center(child: Text("No songs found")));
        }

        final currentSong = songs[_currentSongIndex];
        final currentSongTitle = "${currentSong.id} ${currentSong.title}";

        List<Widget> pages = [
          Contents(songs: songs, currentSongIndex: _currentSongIndex),
          MusicView(songs: songs, currentSongIndex: _currentSongIndex),
          ResponsiveReadingList(readings: readings),
        ];

        return Scaffold(
          backgroundColor: ColorsData.secondary_white,
          appBar: _selectedIndex == 2
              ? null
              : CustomAppBar(
                  songTitle: currentSongTitle,
                  onTitleTap: () => _openSongListScreen(context, songs),
                  onMenuTap: () => _openMenuPage(context, songs),
                  onSearchTap: () async {
                    final selectedIdx = await Navigator.push<int>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(songs: songs),
                      ),
                    );

                    if (selectedIdx != null && selectedIdx != _currentSongIndex) {
                      setState(() {
                        _currentSongIndex = selectedIdx;
                        _selectedIndex = 0;
                      });
                    }
                  },
                  onCancelSearch: () {
                    setState(() {
                      _isSearching = false;
                      _searchController.clear();
                    });
                  },
                  searchController: _searchController,
                  onSearchChanged: (text) {
                    final id = int.tryParse(text.trim());
                    if (id != null) {
                      final idx = songs.indexWhere((s) => s.id == id);
                      if (idx != -1) {
                        setState(() {
                          _currentSongIndex = idx;
                          _selectedIndex = 0;
                        });
                      }
                    }
                  },
                  isSearching: _isSearching,
                ),
          body: pages[_selectedIndex],
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  void _openSongListScreen(BuildContext context, List<Song> songs) async {
    final picked = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (context) => SongListScreen(
          songs: songs,
          selectedId: songs[_currentSongIndex].id,
          onSongSelected: (idx) {
            Navigator.pop(context, idx);
          },
        ),
      ),
    );
    if (picked != null && picked != _currentSongIndex) {
      setState(() {
        _currentSongIndex = picked;
      });
    }
  }

  void _openMenuPage(BuildContext context, List<Song> songs) async {
    final songId = await Navigator.push<int>(
      context,
      MaterialPageRoute(builder: (context) => MenuPage(songs: songs)),
    );
    if (songId != null) {
      final idx = songs.indexWhere((s) => s.id == songId);
      if (idx != -1) {
        setState(() {
          _currentSongIndex = idx;
          _selectedIndex = 0;
        });
      }
    }
  }
}