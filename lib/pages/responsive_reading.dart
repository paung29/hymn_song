import 'package:flutter/material.dart';
import 'package:hymn_song/model/responsive.dart';
import 'package:hymn_song/pages/responsive_details.dart';

class ResponsiveReadingList extends StatefulWidget {
  final List<ResponsiveReading> readings;

  const ResponsiveReadingList({super.key, required this.readings});

  @override
  State<ResponsiveReadingList> createState() => _ResponsiveReadingListState();
}

class _ResponsiveReadingListState extends State<ResponsiveReadingList> {
  int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resposive Reading List"),
        centerTitle: true,
        backgroundColor: const Color(0xFF624E5B),
        foregroundColor: Colors.white,
        elevation: 0.8,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF624E5B),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        itemCount: widget.readings.length,
        separatorBuilder: (context, i) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final item = widget.readings[i];
          final isSelected = selectedId == item.id;

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              setState(() {
                selectedId = item.id;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ResponsiveReadingDetail(reading: item),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white24 : const Color(0xFF7B6471),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.black,
                  width: isSelected ? 2 : 1.2,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Text(
                    "${item.id}",
                    style: const TextStyle(
                      fontFamily: 'GasoekOne',
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 1,
                          color: Colors.black26,
                          offset: Offset(0.5, 1.2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontFamily: 'GasoekOne',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: 1.05,
                        overflow: TextOverflow.ellipsis,
                        shadows: [
                          Shadow(
                            blurRadius: 0.5,
                            color: Colors.black26,
                            offset: Offset(0.2, 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}