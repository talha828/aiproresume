import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';

// ignore: must_be_immutable
class SummarySection extends StatefulWidget {
  SummarySection({super.key, this.f1color, this.h1color});

  Color? f1color;
  Color? h1color;

  @override
  State<SummarySection> createState() => SummarySectionState();
}

class SummarySectionState extends State<SummarySection> {
  static dynamic sumList = [];
  CallApi _api = CallApi();
  var token;
  var profile_id;
  var summm;

  _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    profile_id = prefs.getString("profile_id");

    await _api.fetchSummary('show_summaries/$profile_id', token);
    sumList = _api.response;
    summm = sumList['description'].toString();
    // debugPrint("summarySection: " + );
    return sumList;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _getCert();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCert(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            debugPrint("length: " + snapshot.data.length.toString());
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: GoogleFonts.getFont(global.fontStyle,
                        fontSize: global.headingSize,
                        fontWeight: FontWeight.bold,
                        color: global.heading1color ?? widget.h1color),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    summm,
                    // overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: GoogleFonts.getFont(
                      global.fontStyle,
                      fontSize: global.fontSize,
                      color: global.font1color ?? widget.f1color,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
