import 'package:flutter/material.dart';
import 'package:hymn_song/model/song.dart';
import 'package:hymn_song/pages/menu_page.dart';
import 'package:hymn_song/utils/colors_data.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String songTitle;
  final VoidCallback onTitleTap;
  final VoidCallback onSearchTap;
  final List<Song> songs;
  final VoidCallback onMenuTap;

  const CustomAppBar({
    required this.songTitle,
    required this.onTitleTap,
    required this.onSearchTap,
    required this.songs,
    required this.onMenuTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final double baseTitleSize = SizeConfig.isTabletDevice ? 14 : 12;
    final double baseIconSize = SizeConfig.isTabletDevice ? 28 : 22;

    double titleFontSize = SizeConfig.fontSize(baseTitleSize);
    double iconButtonSize = SizeConfig.fontSize(baseIconSize);

    // Tighter clamps for both tablet and phone
    if (!SizeConfig.isTabletDevice) {
      titleFontSize = titleFontSize.clamp(15.0, 22.0); // Phone max 22
      iconButtonSize = iconButtonSize.clamp(18.0, 28.0); // Phone max 28
    } else {
      titleFontSize = titleFontSize.clamp(18.0, 28.0); // Tablet max 28
      iconButtonSize = iconButtonSize.clamp(22.0, 36.0); // Tablet max 36
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: GestureDetector(
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
            IconButton(
              onPressed: onSearchTap,
              icon: Icon(
                Icons.search,
                color: ColorsData.secondary_white,
                size: iconButtonSize,
              ),
              splashRadius: iconButtonSize * 0.8,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56); // Matches default AppBar
}
