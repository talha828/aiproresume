
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';


// ignore: must_be_immutable
class SignatureSection extends StatefulWidget {
  SignatureSection({super.key, this.h1color});

  Color? h1color;

  @override
  State<SignatureSection> createState() => SignatureSectionState();
}

class SignatureSectionState extends State<SignatureSection> {
  CallApi _api = CallApi();
  var token;
  static dynamic signList = [];

  _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var pid = prefs.getString("profile_id");
    await _api.fetchSigns('user_digital_signature?profile_id=$pid', token);
    signList = _api.response;
    return signList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getCert(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Signature',
                    style: GoogleFonts.getFont(global.fontStyle,
                        fontSize: global.headingSize,
                        fontWeight: FontWeight.bold,
                        color: global.heading1color ?? widget.h1color),
                  ),
                  const SizedBox(height: 10),
                  Image.network(
                      height: 100,
                      width: 200,
                      fit: BoxFit.fill,
                      'http://resume.cognitiveitsolutions.ca/public/images/${signList['image']}')
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }


}
