import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hymn_song/components/app_bar.dart';
import 'package:hymn_song/components/custom_bottom_nav_bar.dart';
import 'package:hymn_song/pages/menu_page.dart';
import 'package:hymn_song/pages/note_view.dart';
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
            onSearchTap: () {
              setState(() => _isSearching = true);
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

  void _searchBySongId(
    BuildContext context,
    List<Song> songs,
    void Function(int idx) onFound,
  ) async {
    final controller = TextEditingController();

    final result = await showGeneralDialog<int>(
      context: context,
      barrierLabel: "Search",
      barrierDismissible: true,
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.92,
                constraints: const BoxConstraints(maxWidth: 380),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black12)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Input box
                    TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        hintText: 'Enter song number',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF624E5B),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF624E5B),
                            width: 1.8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Buttons row
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "cancel",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF624E5B),
                              foregroundColor: Colors.white,
                              elevation: 1,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              final id = int.tryParse(controller.text.trim());
                              if (id != null) {
                                final idx = songs.indexWhere((s) => s.id == id);
                                if (idx != -1) {
                                  Navigator.of(context).pop(idx);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Song not found.'),
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              "search",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
    );

    if (result != null) {
      onFound(result); // use: setState(() { _currentSongIndex = result; ... });
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
