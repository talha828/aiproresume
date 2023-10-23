import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';

// ignore: must_be_immutable
class SkillSection extends StatefulWidget {
  SkillSection({super.key, this.h2color, this.f2color, this.barcolor});

  Color? h2color;
  Color? f2color;
  Color? barcolor;

  @override
  State<SkillSection> createState() => SkillSectionState();
}

class SkillSectionState extends State<SkillSection> {
  static dynamic techskillsList = [];

  Future<List<dynamic>> _dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");

    techskillsList = await FetchData().getCertasList("technical_skills/$pid");

    return techskillsList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataFetched(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: techskillsList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tech Skills',
                          style: GoogleFonts.getFont(global.fontStyle,
                              fontSize: global.headingSize,
                              fontWeight: FontWeight.bold,
                              color: global.heading2color ?? widget.h2color),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          techskillsList[index]['body']+"\n",
                          softWrap: false,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.getFont(
                            global.fontStyle,
                            fontSize: global.fontSize,
                            color: global.font2color ?? widget.f2color,
                          ),
                        ),
                        LinearProgressIndicator(
                          value: 0.60,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              widget.barcolor ?? Colors.black),
                        ),
                        const SizedBox(height: 15),
                        // Text(
                        //   'Native Java',
                        //   softWrap: false,
                        //   maxLines: 3,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: GoogleFonts.getFont(
                        //     global.fontStyle,
                        //     fontSize: global.fontSize,
                        //     color: global.font2color ?? widget.f2color,
                        //   ),
                        // ),
                        // LinearProgressIndicator(
                        //   value: 0.60,
                        //   valueColor: AlwaysStoppedAnimation<Color>(
                        //       widget.barcolor ?? Colors.black),
                        // ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
