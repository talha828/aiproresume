import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';

// ignore: must_be_immutable
class ExperienceSection extends StatefulWidget {
  ExperienceSection({super.key, this.f1color, this.h1color});

  Color? f1color;
  Color? h1color;

  @override
  State<ExperienceSection> createState() => ExperienceSectionState();
}

class ExperienceSectionState extends State<ExperienceSection> {
  static dynamic expList = [];
  dynamic exlist = [];

  Future<List<dynamic>> _dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
    debugPrint("pro id: $pid");
    // expList = await FetchData().getCertasList("experiences?profile_id=$pid");
    exlist = await FetchData().getCertasList("experiences?profile_id=$pid");
    expList = exlist;
    debugPrint("Summary: $expList");
    return exlist;
  }

  @override
  void initState() {
    super.initState();
    //_getCert();
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
                'Experience',
                style: GoogleFonts.getFont(global.fontStyle,
                    fontSize: global.headingSize,
                    fontWeight: FontWeight.bold,
                    color: global.heading1color ?? widget.h1color),
              ),
              ListView.builder(
                  itemCount: expList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),

                          //name date
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  exlist[index]['company_name'],
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.getFont(global.fontStyle,
                                      fontSize: global.fontSize,
                                      color:
                                          global.font1color ?? widget.f1color,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  exlist[index]['start_date'] +
                                      " - " +
                                      exlist[index]['end_date'],
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.getFont(global.fontStyle,
                                      fontSize: global.fontSize,
                                      color:
                                          global.font1color ?? widget.f1color),
                                ),
                              ),
                            ],
                          ),

                          //decp

                          Text(
                            exlist[index]['job_description'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 8,
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
      },
    );
  }
}
