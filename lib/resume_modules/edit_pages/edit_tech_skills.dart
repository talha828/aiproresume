import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../common/custom_textfield.dart';
import '../listing/list_tech_skills.dart';

class EditTechnicalSkill extends StatefulWidget {
  const EditTechnicalSkill({super.key});

  @override
  State<EditTechnicalSkill> createState() => _EditTechnicalSkillState();
}

class _EditTechnicalSkillState extends State<EditTechnicalSkill> {
  final _techSkill = TextEditingController();
  _EditTechnicalSkillState() {
    _techSkill.text = ListTechSkillsState.cdescription;
  }
  dynamic skillList = [];
  String? skillItem;
  var token;
  var softSkill_id;
  CallApi _api = CallApi();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
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
                    text: "Technical Skills",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 20,
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ListTechSkills(),
                            ),
                          );
                        },
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
                  text: 'Update your Technical Skills.',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              //body
              Expanded(child: mainBody()),

              //button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    updateCoverLetter(ListTechSkillsState.id.toString());
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
              label: 'Update Technical Skills',
              maxLines: 6,
              controller: _techSkill,
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
                  const Text("Let's pick your top skills"),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder(
                      future: _getTechSkills(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.add),
                                  title: CustomText(
                                      text: '${skillList[index]['name']}'),
                                  onTap: () {
                                    skillItem = skillList[index]['name'];
                                    _techSkill.text += "- $skillItem\n";
                                    softSkill_id = skillList[index]['id'];
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

  Future<List<dynamic>> _getTechSkills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    await _api.fetchCerts('tech_skills', token);
    // print("Resssss: " + _api.response.toString());
    skillList = await _api.response;
    return skillList;
  }

  var user_id;
  updateCoverLetter(String id) async {
    CustomProgressDialogue.progressDialogue(context);
    var user_id, token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    var certCred = {
      'body': _techSkill.text,
    };
    var res = await CallApi()
        .updateInfoData(certCred, 'technical_skills/' + id, token);
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
