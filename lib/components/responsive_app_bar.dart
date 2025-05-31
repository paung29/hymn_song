import 'package:flutter/material.dart';
import 'package:hymn_song/utils/colors_data.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class ResponsiveReadingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuTap;

  const ResponsiveReadingAppBar({
    Key? key,
    required this.title,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final double titleFontSize = SizeConfig.fontSize(SizeConfig.isTabletDevice ? 18 : 16).clamp(16.0, 24.0);
    final double iconSize = SizeConfig.fontSize(SizeConfig.isTabletDevice ? 28 : 22).clamp(22.0, 32.0);

    return AppBar(
      backgroundColor: ColorsData.primary,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: SizeConfig.isTabletDevice ? 70 : 56,
      leading: IconButton(
        onPressed: onMenuTap,
        icon: Icon(Icons.menu, size: iconSize, color: ColorsData.secondary_white),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: ColorsData.secondary_white,
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
          fontFamily: 'GasoekOne',
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}