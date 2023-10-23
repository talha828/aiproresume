import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class NameDesignationSection extends StatefulWidget {
  NameDesignationSection({super.key, this.ndcolor});

  Color? ndcolor;

  @override
  State<NameDesignationSection> createState() => NameDesignationSectionState();
}

class NameDesignationSectionState extends State<NameDesignationSection> {
 static var nameNM, jobTitleNM;
  dynamic rList = [];
  Future<List<dynamic>> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameNM = prefs.getString("profile_name");
    jobTitleNM = prefs.getString("job_title");
    return rList;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //_getCert();
  // }

  // static var imIndex;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: getInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // return ListView.builder(
            //     itemCount: certList.length,
            //     shrinkWrap: true,
            //     itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nameNM.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.getFont(global.fontStyle,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: global.heading1color ?? widget.ndcolor),
                  ),
                  Text(
                    overflow: TextOverflow.ellipsis,
                    jobTitleNM.toString(),
                    style: GoogleFonts.getFont(global.fontStyle,
                        fontSize: 25,
                        color: global.heading1color ?? widget.ndcolor),
                  ),
                ],
              ),
            );
            // });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
