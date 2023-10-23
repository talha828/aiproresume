// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({
    super.key,
    required this.icolor,
    this.f2color,
  });

  final Color icolor;
  final Color? f2color;
  @override
  State<ContactSection> createState() => ContactSectionState();
}

class ContactSectionState extends State<ContactSection> {
  static var contactCS, emailCS;
  final CallApi _api = CallApi();

  var profile_id, token;

  Future<List<dynamic>> _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    contactCS = prefs.getString("contact_info");
    emailCS = prefs.getString("email_address");

    var countryId = prefs.getInt("mulk");
    var stateId = prefs.getInt("suba");
    var cityId = prefs.getInt("shehar");
    print("CountryID: " + countryId.toString());
    print("StateID: " + stateId.toString());
    print("City ID:  " + cityId.toString());

    // Future.delayed(Duration(seconds: 2), () {
    _getCountryLocation('show-countries', countryId! - 1);
    _getstateLocation("states/show-states/" + countryId.toString(), stateId);
    _getCityLocation("cities/show-cities/" + stateId.toString(), cityId);
    // });
    return someList;
  }

  dynamic someList = [];
  dynamic countryList;
  static var countryNameCS;
  Future<List<dynamic>> _getCountryLocation(url, id) async {
    // print("inside Name and Designation");
    await _api.fetchCountries(url);
    countryList = _api.response;
    //print("Country: " + countryList[id]['name'].toString());
    //setState(() {
    countryNameCS = countryList[id]['name'].toString();
    // });

    // print("CountryName: " + _api.nameC("164").toString());
    return countryList;
  }

  dynamic stateList;
  static var stateNameCS;
  Future<List<dynamic>> _getstateLocation(url, id) async {
    // print("inside Name and Designation");
    await _api.fetchCountries(url);
    stateList = _api.response;
    // print("State: " + stateList.toString());
    for (int i = 0; i < stateList.length; i++) {
      // print("State: " + stateList[i]["id"].toString());

      if (stateList[i]["id"] == id) {
        //setState(() {
        stateNameCS = stateList[i]["name"].toString();
        //  });

        //print("NameState: " + stateNameCSCS);
        break;
      }
    }

    return stateList;
  }

  dynamic cityList;
  static var cityNameCS;
  Future<List<dynamic>> _getCityLocation(url, id) async {
    await _api.fetchCountries(url);
    cityList = _api.response;
    // print("City: " + cityList.toString());
    for (int i = 0; i < cityList.length; i++) {
      // print("City: " + cityList[i]["id"].toString());
      if (cityList[i]["id"] == id) {
        //setState(() {
        cityNameCS = cityList[i]["name"].toString();
        // });

        // print("NameCity: " + cityNameCS.toString());
        break;
      }
    }

    return cityList;
  }

  @override
  void initState() {
    super.initState();

    // _getCert();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: _getCert(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // return ListView.builder(
            //     itemCount: contactList.length,
            //     shrinkWrap: true,
            //     itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //address
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: global.iconColor ?? widget.icolor,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            cityNameCS != null && countryNameCS != null
                                ? cityNameCS + " , " + countryNameCS
                                : "--- , ---",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: GoogleFonts.getFont(
                              global.fontStyle,
                              fontSize: global.fontSize,
                              color: global.font2color ?? widget.f2color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    //mobile number
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          color: global.iconColor ?? widget.icolor,
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            contactCS.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: GoogleFonts.getFont(
                              global.fontStyle,
                              fontSize: global.fontSize,
                              color: global.font2color ?? widget.f2color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    //Email
                    Row(
                      children: [
                        Icon(Icons.email_outlined,
                            color: global.iconColor ?? widget.icolor),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            emailCS.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: GoogleFonts.getFont(
                              global.fontStyle,
                              fontSize: global.fontSize,
                              color: global.font2color ?? widget.f2color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // //linkdin
                    // Row(
                    //   children: [
                    //     SvgPicture.asset("assets/svg/linkdintwo.svg",
                    //         height: 25,
                    //         color: global.iconColor ?? widget.icolor),
                    //     const SizedBox(width: 10),
                    //     Flexible(
                    //       child: Text(
                    //         contactList[index]["personal_information"][index]
                    //                     ['linkedin'] !=
                    //                 null
                    //             ? contactList[index]["personal_information"]
                    //                     [index]['linkedin']
                    //                 .toString()
                    //             : "---",
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 3,
                    //         style: GoogleFonts.getFont(
                    //           global.fontStyle,
                    //           fontSize: global.fontSize,
                    //           color: global.font2color ?? widget.f2color,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 4),

                    // //website
                    // Row(
                    //   children: [
                    //     Icon(Icons.language_outlined,
                    //         color: global.iconColor ?? widget.icolor),
                    //     const SizedBox(width: 10),
                    //     Flexible(
                    //       child: Text(
                    //         contactList[index]["personal_information"]
                    //                     [index]['website'] !=
                    //                 null
                    //             ? contactList[index]
                    //                         ["personal_information"]
                    //                     [index]['website']
                    //                 .toString()
                    //             : "---",
                    //         overflow: TextOverflow.ellipsis,
                    //         maxLines: 3,
                    //         style: GoogleFonts.getFont(
                    //           global.fontStyle,
                    //           fontSize: global.fontSize,
                    //           color: global.font2color ?? widget.f2color,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
            //   });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
