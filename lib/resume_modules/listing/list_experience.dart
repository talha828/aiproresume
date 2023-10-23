// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_dialogue.dart';
import '../edit_pages/edit_experience.dart';

class ListExperience extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListExperienceState();
  }
}

class ListExperienceState extends State<ListExperience> {
  dynamic certList = [];
  CallApi _api = CallApi();
  var token;
  var profile_id;

  Future<List<dynamic>> _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    profile_id = prefs.getInt("prof_id");
    print("inside");
    await _api.fetchCerts('experiences?profile_id=1', token);
    certList = _api.response;
    print("CertList ");
    return certList;
  }

  static var cdescription;
  static var cover_id;
  static var jobpos,
      companyname,
      country,
      state,
      city,
      jobtype,
      startdate,
      enddate,
      industry,
      uuid,
      desc;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Experiences"),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 238, 228, 228)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Your Experience List",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                    future: _getCert(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: certList.length,
                          itemBuilder: (BuildContext context, int index) {
                            cover_id = certList[index]['id'];

                            cdescription = certList[index]['job_position'];

                            return Card(
                              child: ListTile(
                                leading: IconButton(
                                  onPressed: () {
                                    setState(() {});
                                    jobpos = certList[index]['job_position'];
                                    companyname =
                                        certList[index]['company_name'];
                                    jobtype = certList[index]['type'];
                                    startdate = certList[index]['start_date'];
                                    enddate = certList[index]['end_date'];
                                    industry =
                                        certList[index]['company_description'];
                                    desc = certList[index]['job_description'];
                                    country = certList[index]['country_id'];
                                    state = certList[index]['state_id'];
                                    city = certList[index]['city_id'];
                                    uuid = certList[index]['uuid'];
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => EditExperience1(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                title: Text(
                                    '${certList[index]['job_position']}'
                                        .toUpperCase(),
                                    style: TextStyle()),
                                subtitle: Text(
                                    '${certList[index]['company_name']}',
                                    style: TextStyle()),
                                onTap: () {
                                  jobpos = certList[index]['job_position'];
                                  companyname = certList[index]['company_name'];
                                  jobtype = certList[index]['type'];
                                  startdate = certList[index]['start_date'];
                                  enddate = certList[index]['end_date'];
                                  industry =
                                      certList[index]['company_description'];
                                  desc = certList[index]['job_description'];
                                  country = certList[index]['country_id'];
                                  state = certList[index]['state_id'];
                                  city = certList[index]['city_id'];
                                  uuid = certList[index]['uuid'];
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => EditExperience1(),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    print("DeleteITEM: " +
                                        certList[index]['id'].toString());
                                    deleteCertificates(
                                        certList[index]['uuid'], index);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var  user_id;
  deleteCertificates(var index, int listIndex) async {
    CustomProgressDialogue.progressDialogue(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Deleting ...",
        style: TextStyle(fontSize: 16),
      ),
    ));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");

    print("UserID: " + user_id.toString());
    var certCred = {
      'body': cdescription.toString(),
      'profile_id': profile_id,
    };
    var res = await CallApi()
        .deleteInfoData( 'experiences/' + index.toString(), token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {
        certList.removeAt(listIndex);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Deleted successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      print("Some  issue");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error deleting data",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}
