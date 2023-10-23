import 'dart:convert';

import 'package:aiproresume/apis/webapi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../../common/custom_dialogue.dart';
import '../edit_pages/edit_soft_skills.dart';


class ListSoftSkills extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListSoftSkillsState();
  }
}

class ListSoftSkillsState extends State<ListSoftSkills> {
  dynamic certList = [];
  CallApi _api = CallApi();
  var token;
  var profile_id;

  Future<List<dynamic>> _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    profile_id = prefs.getString("profile_id");
    print("inside");
    await _api.fetchCerts('soft_skills/$profile_id', token);
    certList = _api.response;
    print("CertList ");
    return certList;
  }

  static var softskillsbody;
  static var id;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Soft Skills"),
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
                "Your Soft Skills",
                style: TextStyle(fontSize: 30),
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
                            softskillsbody = certList[index]['body'];
                            return Card(
                              child: ListTile(
                                leading: IconButton(
                                  onPressed: () {
                                    setState(() {});
                                    id = certList[index]['id'];

                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => EditSofSkill(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                title: Text('${certList[index]['body']}',
                                    style: TextStyle()),
                                onTap: () {
                                  id = certList[index]['id'];
                                  softskillsbody = certList[index]['body'];
                                  EditSoftSkillState.softskillController.text =
                                      softskillsbody;
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => EditSofSkill(),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteCertificates(
                                        certList[index]['id'], index);
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

  var user_id;
  deleteCertificates(int index, int listIndex) async {
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
      'body': softskillsbody.toString(),
      'profile_id': profile_id,
    };
    var res = await CallApi()
        .deleteInfoData( 'soft_skills/' + index.toString(), token);
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
