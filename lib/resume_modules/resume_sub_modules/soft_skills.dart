import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';
import '../../apis/post_data.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../common/custom_textfield.dart';

class SoftSkills extends StatefulWidget {
  const SoftSkills({super.key});

  @override
  State<SoftSkills> createState() => _SoftSkillsState();
}

class _SoftSkillsState extends State<SoftSkills> {
  final _techSkill = TextEditingController();
  dynamic skillList = [];
  String? skillItem;

  var softSkill_id;

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
                    text: "Soft Skills",
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
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => ListSoftSkills(),
                          //   ),
                          // );
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
                  text: 'Update your Soft Skills.',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              //body
              Expanded(child: mainBody()),

              //buttom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    postSoftSkills();
                  },
                  buttonText: 'Add',
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
              label: 'Add Soft Skills',
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
                      future: dataFetched(),
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

  Future<List<dynamic>> dataFetched() async {
    skillList = await FetchData().getCertasList("soft_skills");

    // debugPrint("Summary: $summaryList");
    return skillList;
  }

  postSoftSkills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");

    if (pid != null) {
      var certCred = {
        'body': _techSkill.text,
        'profile_id': pid.toString(),
      };
      PostData().post_data(context, certCred, "soft_skills");
    } else {
      return;
    }
  }
}
