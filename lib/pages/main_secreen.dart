import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hymn_song/components/app_bar.dart';
import 'package:hymn_song/components/custom_bottom_nav_bar.dart';
import 'package:hymn_song/pages/menu_page.dart';
import 'package:hymn_song/pages/note_view.dart';
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

    return FutureBuilder<List<Song>>(
      future: loadSongs(),
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
        final songs = snapshot.data ?? [];
        if (songs.isEmpty) {
          return const Scaffold(body: Center(child: Text("No songs found")));
        }

        // 1. Make a list of song titles for the picker
        final songTitles = songs.map((s) => "${s.id} ${s.title}").toList();

        // 2. Show ID + title in the AppBar
        final currentSong = songs[_currentSongIndex];
        final currentSongTitle = "${currentSong.id} ${currentSong.title}";

        List<Widget> pages = [
          Contents(songs: songs, currentSongIndex: _currentSongIndex),
          MusicView(songs: songs, currentSongIndex: _currentSongIndex),
          Center(child: Text("Images")),
        ];

        return Scaffold(
          backgroundColor: ColorsData.secondary_white,
          appBar: CustomAppBar(
            songTitle: currentSongTitle,
            onTitleTap: () => _openSongListScreen(context, songs),
            onMenuTap: () => _openMenuPage(context, songs),
            onSearchTap: () async {
              final songs = snapshot.data ?? [];
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
        builder:
            (context) => SongListScreen(
              songs: songs,
              selectedId: songs[_currentSongIndex].id,
              onSongSelected: (idx) {
                Navigator.pop(context, idx); // Return the index
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
      // Find the index in the list
      final idx = songs.indexWhere((s) => s.id == songId);
      if (idx != -1) {
        setState(() {
          _currentSongIndex = idx;
          _selectedIndex = 0; // go to main Content
        });
      }
    }
  }
}
