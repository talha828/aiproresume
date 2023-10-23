import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';


// ignore: must_be_immutable
class EducationSection extends StatefulWidget {
  EducationSection({super.key, this.f1color, this.h1color});

  Color? f1color;
  Color? h1color;

  @override
  State<EducationSection> createState() => EducationSectionState();
}

class EducationSectionState extends State<EducationSection> {
  static  dynamic eduList = [];

  var user_id, token;
  static var degreeName;
  // CallApi _api = CallApi();

  // Future<List<dynamic>> _getCert() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString("session_token");
  //   await _api.fetchCerts('education', token);
  //   eduList = _api.response;
  //   print("Education " + eduList.toString());

  //   return eduList;
  // }

  Future<List<dynamic>> _dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
    eduList = await FetchData().getCertasList("education?profile_id=$pid");

    // debugPrint("Summary: $eList");
    return eduList;
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
                          'Education',
                          style: GoogleFonts.getFont(
                            global.fontStyle,
                            fontSize: global.headingSize,
                            fontWeight: FontWeight.bold,
                            color: global.heading1color ?? widget.h1color,
                          ),
                        ),

                         ListView.builder(
                itemCount: eduList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  switch (eduList[index]['degree_id']) {
                    case 1:
                      degreeName = "Matriculation";
                      break;
                    case 2:
                      degreeName = "Intermediate";
                      break;
                    case 3:
                      degreeName = "Bachelors";
                      break;
                    case 4:
                      degreeName = "O Levels";
                      break;
                    case 5:
                      degreeName = "Masters";
                      break;
                    case 6:
                      degreeName = "PhD";
                      break;
                  }
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),

                        // uni name
                        Text(
                          eduList[index]['institution'],
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.getFont(global.fontStyle,
                              fontSize: global.headingSize,
                              color: global.font1color ?? widget.f1color),
                        ),

                        //field title
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                eduList[index]['field'],
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.getFont(
                                  global.fontStyle,
                                  fontSize: global.fontSize,
                                  color: global.font1color ?? widget.f1color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                degreeName != null ? degreeName : "None",
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.getFont(
                                  global.fontStyle,
                                  fontSize: global.fontSize,
                                  color: global.font1color ?? widget.f1color,
                                ),
                              ),
                            ),
                          ],
                        ),

                        //start/end date
                        Text(
                          eduList[index]['start_date'] +
                              " - " +
                              eduList[index]['end_date'],
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
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
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
