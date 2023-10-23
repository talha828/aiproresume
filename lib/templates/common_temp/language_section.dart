import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';


// ignore: must_be_immutable
class LanguagesSection extends StatefulWidget {
  LanguagesSection({super.key, this.h2color, this.f2color, this.barcolor});

  Color? h2color;
  Color? f2color;
  Color? barcolor;

  @override
  State<LanguagesSection> createState() => LanguagesSectionState();
}

class LanguagesSectionState extends State<LanguagesSection> {
  
  static dynamic languageList = [];
 

  Future<List<dynamic>> _dataFetched() async {
    languageList = await FetchData().getCertasList("show_user_languages");
    return languageList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: _dataFetched(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Languages',
                  style: GoogleFonts.getFont(global.fontStyle,
                      fontSize: global.headingSize,
                      fontWeight: FontWeight.bold,
                      color: global.heading2color ?? widget.h2color),
                ),
                ListView.builder(
                    itemCount: languageList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              languageList[index]['language'],
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

                            // Text(
                            //   languageList[index]['language'],
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
                    }),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
