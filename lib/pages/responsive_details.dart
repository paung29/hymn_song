import 'package:flutter/material.dart';
import 'package:hymn_song/model/responsive.dart';
import 'package:hymn_song/utils/colors_data.dart';
import 'package:hymn_song/utils/secreen_size.dart';

class ResponsiveReadingDetail extends StatefulWidget {
  final ResponsiveReading reading;

  const ResponsiveReadingDetail({super.key, required this.reading});

  @override
  State<ResponsiveReadingDetail> createState() =>
      _ResponsiveReadingDetailState();
}

class _ResponsiveReadingDetailState extends State<ResponsiveReadingDetail> {
  double _fontScale = 1.0;
  double _baseFontScale = 1.0;
  static const double _minScale = 0.6;
  static const double _maxScale = 2.2;
  bool _scaling = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final normalTextStyle = TextStyle(
      fontFamily: 'GasoekOne',
      fontSize:
          SizeConfig.fontSize(SizeConfig.isTabletDevice ? 20 : 15) * _fontScale,
      height: 1.5,
      color: Colors.black87,
    );

    final boldTextStyle = normalTextStyle.copyWith(
      fontWeight: FontWeight.bold,
    );

    final titleStyle = TextStyle(
      fontFamily: 'GasoekOne',
      fontWeight: FontWeight.bold,
      fontSize:
          SizeConfig.fontSize(SizeConfig.isTabletDevice ? 24 : 18) * _fontScale,
      color: Colors.black,
    );

    final subtitleStyle = TextStyle(
      fontFamily: 'GasoekOne',
      fontSize: SizeConfig.fontSize(15) * _fontScale,
      color: Colors.black54,
    );

    return Scaffold(
      backgroundColor: Colors.white, // ✅ white background
      appBar: AppBar(
        backgroundColor: ColorsData.primary,
        elevation: 0.8,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text("Responsive Reading ${widget.reading.id}",style:TextStyle(color: Colors.white),),
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          _scaling = true;
          _baseFontScale = _fontScale;
        },
        onScaleUpdate: (details) {
          if (details.pointerCount > 1) {
            setState(() {
              _fontScale = (_baseFontScale * details.scale)
                  .clamp(_minScale, _maxScale);
            });
          }
        },
        onScaleEnd: (_) => _scaling = false,
        child: NotificationListener<ScrollNotification>(
          onNotification: (_) => _scaling,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.fontSize(20),
              vertical: SizeConfig.fontSize(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & subtitle
                Center(
                  child: Column(
                    children: [
                      Text(
                        widget.reading.name,
                        style: titleStyle.copyWith(
                          fontSize: titleStyle.fontSize! + 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.reading.title,
                        style: subtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Alternating verse lines
                for (int i = 0; i < widget.reading.verse.length; i++) ...[
                  Text(
                    widget.reading.verse[i],
                    style: i % 2 == 0 ? normalTextStyle : boldTextStyle,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}