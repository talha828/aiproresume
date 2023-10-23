// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../common/custom_textfield.dart';
import '../listing/list_summary.dart';

class EditSummary extends StatefulWidget {
  EditSummary();
  @override
  State<EditSummary> createState() => EditSummaryState();
}

class EditSummaryState extends State<EditSummary> {
  EditSummaryState() {
    _titleSummary.text = ListSummaryState.ctitleSummary;
    _coverLetter.text = ListSummaryState.cdescription;
  }
  final _coverLetter = TextEditingController();
  final _titleSummary = TextEditingController();
  dynamic _coverLetterList = [];

  String? coverletterdec;
  //var token = Auth.token;
  var coverletterid;
  CallApi _api = CallApi();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //headrer
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    text: "Summary/Objectives",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                  Expanded(
                      child: SizedBox(
                    width: 20,
                  )),
                  Expanded(
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.list,
                          color: Colors.blue,
                        )),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Update Summary/objectives',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              // body
              Expanded(child: mainBody()),

              //buttom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    updateCoverLetter(ListSummaryState.cover_id.toString());
                  },
                  buttonText: 'Update',
                  sizeWidth: double.infinity,
                  sizeHeight: 55,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: [
            CustomTextField(
              controller: _titleSummary,
              label: 'Title',
            ),
            const SizedBox(height: 10),
            CustomTextField(
              label: 'Update Summary/Objective',
              maxLines: 6,
              controller: _coverLetter,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 238, 228, 228),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Let's pick objective"),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder(
                      future: _getcoverletter(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.add),
                                  title: CustomText(
                                      text:
                                          '${_coverLetterList[index]['objective']}',
                                      maxline: 5),
                                  onTap: () {
                                    coverletterdec =
                                        _coverLetterList[index]['objective'];
                                    _coverLetter.text = "- $coverletterdec\n";
                                    coverletterid =
                                        _coverLetterList[index]['id'];
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  var profile_id;
  Future<List<dynamic>> _getcoverletter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    profile_id = prefs.getInt("prof_id");
    await _api.fetchCerts('objectives', token);
    // print("Resssss: " + _api.response.toString());
    _coverLetterList = await _api.response;
    return _coverLetterList;
  }

  var user_id, token;
  updateCoverLetter(String id) async {
    CustomProgressDialogue.progressDialogue(context);
    var user_id, token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    var certCred = {
      'title': "Objective",
      'description': _coverLetter.text,
    };
    var res =
        await CallApi().updateInfoData(certCred, 'user_summary/' + id, token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    Center(
      child: CircularProgressIndicator(),
    );

    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Record Updated Successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
      // Navigator.of(context).pop();
    } else {
      print("Some  issue");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error Updating data",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}
