// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:aiproresume/resume_modules/resume_modules_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';
import '../../apis/post_data.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../common/custom_textfield.dart';

class SummaryObjective extends StatefulWidget {
  const SummaryObjective({super.key});

  @override
  State<SummaryObjective> createState() => _SummaryObjectiveState();
}

class _SummaryObjectiveState extends State<SummaryObjective> {
  final jobTitle = TextEditingController();
  final skills = TextEditingController();
  // final skills_again = TextEditingController();
  dynamic summaryList = [];

  String? summaryItem;
  var objective_id;

  Future<List<dynamic>> dataFetched() async {
    summaryList = await FetchData().getCertasList("objectives");

    // debugPrint("Summary: $summaryList");
    return summaryList;
  }

  apiParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
    var certCred = {
      'title': jobTitle.text,
      'description': skills.text,
      'profile_id': pid,
    };

    PostData().post_data(context, certCred, 'add_summary');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    text: "Summary",
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
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => Listsummary(),
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
                  text: 'Add your Summary/Objective.',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),

              //Body
              Expanded(
                child: mainBody(),
              ),

              //Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    apiParams();
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CustomTextField(
              label: 'Title',
              controller: jobTitle,
            ),
            const SizedBox(height: 12),

            //Cover Letter
            CustomTextField(
              label: 'Summary',
              maxLines: 5,
              maxlength: 250,
              controller: skills,
              inputFormatters: [LengthLimitingTextInputFormatter(250)],
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 228, 228)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Let's pick your Objective"),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: dataFetched(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        //print("Token in summ" + token);

                        if (snapshot.hasData) {
                          // print(_api.objective(snapshot.data![0]));

                          //  print("Summary Objectives:" + summaryList.toString());
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.add),
                                  title: Text(
                                      '${summaryList[index]['objective']}'),
                                  onTap: () {
                                    summaryItem =
                                        summaryList[index]['objective'];
                                    skills.text += "$summaryItem\n";
                                    // jobTitle.text =
                                    //     summaryList[index]['title'].toString();
                                    objective_id = summaryList[index]['id'];
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
