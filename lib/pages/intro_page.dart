import 'package:flutter/material.dart';
import 'package:hymn_song/utils/colors_data.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {

    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: ColorsData.primary,
      body: Center(
        child: Container(
          child: Text(
            "VAX HYMN",
            style: TextStyle(color: ColorsData.secondary_white,
            fontSize: SizeConfig.fontSize(40)
            ),
            ),
        ),
      ),
    );
  }
}