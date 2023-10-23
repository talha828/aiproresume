import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';


// ignore: must_be_immutable
class ReferenceSection extends StatefulWidget {
  ReferenceSection({super.key, this.h2color, this.f2color});

  Color? h2color;
  Color? f2color;

  @override
  State<ReferenceSection> createState() => ReferenceSectionState();
}

class ReferenceSectionState extends State<ReferenceSection> {

 static  dynamic referenceList = [];

Future<List<dynamic>> _dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
    
    referenceList = await FetchData().getCertasList("user_references/$pid");
    
    return referenceList;
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
                  'References',
                  style: GoogleFonts.getFont(global.fontStyle,
                      fontSize: global.headingSize,
                      fontWeight: FontWeight.bold,
                      color: global.heading2color ?? widget.h2color),
                ),
                ListView.builder(
                    itemCount: referenceList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  //name
                                  child: Text(
                                    '${referenceList[index]['name']}',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.getFont(
                                      global.fontStyle,
                                      fontSize: global.fontSize,
                                      color:
                                          global.font2color ?? widget.f2color,
                                    ),
                                  ),
                                ),

                                //designation
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    '${referenceList[index]['designation']}',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.getFont(
                                      global.fontStyle,
                                      fontSize: global.fontSize,
                                      color:
                                          global.font2color ?? widget.f2color,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // company name
                            Text(
                              '${referenceList[index]['company']}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.getFont(
                                global.fontStyle,
                                fontSize: global.fontSize,
                                color: global.font2color ?? widget.f2color,
                              ),
                            ),

                            //emal
                            Text(
                              '${referenceList[index]['email']}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.getFont(
                                global.fontStyle,
                                fontSize: global.fontSize,
                                color: global.font2color ?? widget.f2color,
                              ),
                            ),

                            //number
                            Text(
                              '${referenceList[index]['contact_no']}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.getFont(
                                global.fontStyle,
                                fontSize: global.fontSize,
                                color: global.font2color ?? widget.f2color,
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
