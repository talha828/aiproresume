import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;

// ignore: must_be_immutable
class HobbiesSection extends StatefulWidget {
  HobbiesSection({super.key, this.h2color, this.f2color});

  Color? h2color;
  Color? f2color;

  @override
  State<HobbiesSection> createState() => _HobbiesSectionState();
}

class _HobbiesSectionState extends State<HobbiesSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hobbies',
            style: GoogleFonts.getFont(global.fontStyle,
                fontSize: global.headingSize,
                fontWeight: FontWeight.bold,
                color: global.heading2color ?? widget.h2color),
          ),
          const SizedBox(height: 10),
          Text(
            'Painting, Sketching',
            style: GoogleFonts.getFont(
              global.fontStyle,
              fontSize: global.fontSize,
              color: global.font2color ?? widget.f2color,
            ),
          ),
        ],
      ),
    );
  }
}
