import 'package:flutter/material.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final double iconSize = SizeConfig.fontSize(SizeConfig.isTabletDevice ? 36 : 28);
    final Color activeColor = Colors.black;
    final Color inactiveColor = Colors.grey;

    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 2, color: Colors.black)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Row(
          children: [
            _buildNavIcon(Icons.menu_book, "Lyrics", 0, iconSize, activeColor, inactiveColor),
            _buildNavIcon(Icons.library_music, "Note", 1, iconSize, activeColor, inactiveColor),
            _buildNavIcon(Icons.question_answer, "Responsive Reading", 2, iconSize, activeColor, inactiveColor),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(
    IconData icon,
    String label,
    int index,
    double iconSize,
    Color active,
    Color inactive,
  ) {
    final bool isActive = selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: isActive ? active : inactive),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? active : inactive,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}