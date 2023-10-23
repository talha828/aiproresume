import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';

// ignore: must_be_immutable
class CertificateSection extends StatefulWidget {
  CertificateSection({super.key, this.h1color, this.f1color});

  Color? h1color;
  Color? f1color;

  @override
  State<CertificateSection> createState() => CertificateSectionState();
}

class CertificateSectionState extends State<CertificateSection> {
  static dynamic certificateList = [];

  Future<List<dynamic>> _dataFetched() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var pid = prefs.getString("profile_id");
    certificateList = await FetchData().getCertasList("certificates");
    debugPrint("certficates: " + certificateList.toString());
    return certificateList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataFetched(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Certificates',
                  style: GoogleFonts.getFont(global.fontStyle,
                      fontSize: global.headingSize,
                      fontWeight: FontWeight.bold,
                      color: global.heading1color ?? widget.h1color),
                ),
                ListView.builder(
                    itemCount: certificateList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  //title
                                  Text(
                                    certificateList[index]['title'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.getFont(
                                      global.fontStyle,
                                      fontSize: global.fontSize,
                                      color:
                                          global.font1color ?? widget.f1color,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  //date
                                  Text(
                                    certificateList[index]['date'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.getFont(
                                      global.fontStyle,
                                      fontSize: global.fontSize,
                                      color:
                                          global.font1color ?? widget.f1color,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //Institute
                            Text(
                              certificateList[index]['institute'],
                              style: GoogleFonts.getFont(
                                global.fontStyle,
                                fontSize: global.fontSize,
                                color: global.font1color ?? widget.f1color,
                              ),
                            ),
                            //Description
                            Text(
                              certificateList[index]['description'],
                              maxLines: 4,
                              style: GoogleFonts.getFont(
                                global.fontStyle,
                                fontSize: global.fontSize,
                                color: global.font1color ?? widget.f1color,
                              ),
                            ),
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
