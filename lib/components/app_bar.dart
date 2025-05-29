import 'package:flutter/material.dart';
import 'package:hymn_song/utils/colors_data.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String songTitle;
  final VoidCallback onTitleTap;
  final VoidCallback onMenuTap;
  final VoidCallback onCancelSearch;
  final VoidCallback onSearchTap;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final bool isSearching;

  const CustomAppBar({
    required this.songTitle,
    required this.onTitleTap,
    required this.onMenuTap,
    required this.onSearchTap,
    required this.onCancelSearch,
    required this.searchController,
    required this.onSearchChanged,
    required this.isSearching,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final double baseTitleSize = SizeConfig.isTabletDevice ? 14 : 12;
    final double baseIconSize = SizeConfig.isTabletDevice ? 28 : 22;

    double titleFontSize = SizeConfig.fontSize(baseTitleSize);
    double iconButtonSize = SizeConfig.fontSize(baseIconSize);

    if (!SizeConfig.isTabletDevice) {
      titleFontSize = titleFontSize.clamp(15.0, 22.0);
      iconButtonSize = iconButtonSize.clamp(18.0, 28.0);
    } else {
      titleFontSize = titleFontSize.clamp(18.0, 28.0);
      iconButtonSize = iconButtonSize.clamp(22.0, 36.0);
    }

    final double toolbarHeight = SizeConfig.isTabletDevice ? 70 : 56;
    final double verticalPadding = (toolbarHeight - iconButtonSize) / 2.3;

    return AppBar(
      backgroundColor: ColorsData.primary,
      toolbarHeight: toolbarHeight,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: onMenuTap,
        icon: Icon(Icons.menu, color: ColorsData.secondary_white),
      ),
      title: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: isSearching
              ? TextField(
                  key: const ValueKey("searchField"),
                  controller: searchController,
                  onChanged: onSearchChanged,
                  autofocus: true,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter song number or title',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                )
              : GestureDetector(
                  key: const ValueKey("songTitle"),
                  onTap: onTitleTap,
                  child: Text(
                    songTitle,
                    style: TextStyle(
                      color: ColorsData.secondary_white,
                      fontSize: titleFontSize,
                      fontFamily: 'GasoekOne',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
        ),
      ),
      actions: [
        isSearching
            ? IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: onCancelSearch,
              )
            : IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: onSearchTap,
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
