import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_dialogue.dart';
import '../edit_pages/edit_summary.dart';

class Listsummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListSummaryState();
  }
}

class ListSummaryState extends State<Listsummary> {
  dynamic certList = [];
  CallApi _api = CallApi();
  var token;
  var profile_id;

  _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    profile_id = prefs.getString("profile_id");
    print("profile_id: " + profile_id.toString());
    await _api.fetchSummary('show_summaries/$profile_id', token);
    certList = _api.response;
    print("CertList " + certList.toString());
    return certList;
  }

  static var cdescription, ctitleSummary;
  static var cover_id;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Objectives"),
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
                "Your Objectives Summary",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder(
                    future: _getCert(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            cover_id = certList['id'];
                            ctitleSummary = certList['title'];
                            cdescription = certList['description'];

                            return Card(
                              child: ListTile(
                                leading: IconButton(
                                  onPressed: () {
                                    setState(() {});

                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => EditSummary(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                                title: Text('${certList['title']}',
                                    style: TextStyle()),
                                subtitle: Text('${certList['description']}',
                                    style: TextStyle()),
                                onTap: () {
                                  return;
                                },
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    print("DeleteITEM: " +
                                        certList['id'].toString());
                                    deleteCertificates(certList['id'], index);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("Failed to Load Data : " +
                            snapshot.error.toString());
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
    var profile_id_delete = prefs.getString("profile_id");

    print("UserID: " + user_id.toString());
    var certCred = {
      'body': cdescription.toString(),
      'profile_id': profile_id_delete,
    };
    var res =
        await CallApi().deleteInfoData('user_summary/$index', token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      setState(() {
        certList.remove(listIndex);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Deleted successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context).pop();
      Navigator.of(context, rootNavigator: true).pop('dialog');
    } else {
      print("Some  issue");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error deleting data",
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context, rootNavigator: true).pop('dialog');
    }
  }
}
