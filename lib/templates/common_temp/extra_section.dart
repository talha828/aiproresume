import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';


// ignore: must_be_immutable
class ExtraSection extends StatefulWidget {
  ExtraSection({super.key, this.h2color, this.f2color});

  Color? h2color;
  Color? f2color;

  @override
  State<ExtraSection> createState() => ExtraSectionState();
}

class ExtraSectionState extends State<ExtraSection> {
  
  static dynamic extraList = [];

  

  Future<List<dynamic>> _dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profile_id = prefs.getString("profile_id");
    extraList = await FetchData()
        .getCertasList("custom_details?profile_id=$profile_id");
    return extraList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Extra Details',
          style: GoogleFonts.getFont(global.fontStyle,
              fontSize: global.headingSize,
              fontWeight: FontWeight.bold,
              color: global.heading2color ?? widget.h2color),
        ),
        FutureBuilder<List<dynamic>>(
            future: _dataFetched(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: extraList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              extraList[index]['title'],
                              style: GoogleFonts.getFont(global.fontStyle,
                                  fontSize: global.fontSize,
                                  color: global.font2color ?? widget.f2color),
                            ),
                            Text(
                              extraList[index]['detail'],
                              maxLines: 4,
                              style: GoogleFonts.getFont(global.fontStyle,
                                  fontSize: global.fontSize,
                                  color: global.font2color ?? widget.f2color),
                            )
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    );
  }
}
