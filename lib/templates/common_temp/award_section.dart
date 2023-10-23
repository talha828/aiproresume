import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';


// ignore: must_be_immutable
class AwardsSection extends StatefulWidget {
  AwardsSection({super.key, this.f1color, this.h1color});

  Color? f1color;
  Color? h1color;

  @override
  State<AwardsSection> createState() => AwardsSectionState();
}

class AwardsSectionState extends State<AwardsSection> {
  
 static dynamic awardList = [];

  // Future<List<dynamic>> _getCert() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString("session_token");
  //   // print("inside");
  //   await _api.fetchCerts('awards', token);
  //   awardList = _api.response;
  //   print("Awards " + awardList.toString());
  //   return awardList;
  // }
  
  Future<List<dynamic>> _dataFetched() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var pid = prefs.getString("profile_id");
    awardList = await FetchData().getCertasList("awards");
    return awardList;
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
                  'Awards',
                  style: GoogleFonts.getFont(global.fontStyle,
                      fontSize: global.headingSize,
                      fontWeight: FontWeight.bold,
                      color: global.heading1color ?? widget.h1color),
                ),
                ListView.builder(
                    itemCount: awardList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  //Name
                                  Text(
                                    awardList[index]['name'],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.getFont(
                                      global.fontStyle,
                                      fontSize: global.fontSize,
                                      color:
                                          global.font1color ?? widget.f1color,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  //date
                                  Text(
                                    awardList[index]['date'],
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

                            //Body
                            Text(
                              awardList[index]['body'],
                              style: GoogleFonts.getFont(
                                global.fontStyle,
                                fontSize: global.fontSize,
                                color: global.font1color ?? widget.f1color,
                              ),
                            ),
                            //Description
                            Text(
                              awardList[index]['description'],
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
