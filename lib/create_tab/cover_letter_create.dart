// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'dart:convert';
import 'package:aiproresume/common/custom_dialogue.dart';
import 'package:aiproresume/cover_letter_modules/cover_letter_builder.dart';
import 'package:aiproresume/cover_letter_modules/home_cover_temps.dart';
import 'package:http/http.dart' as http;

import 'package:aiproresume/apis/webapi.dart';
import 'package:aiproresume/templates/templates.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/custom_text.dart';
import '../common/app_utils.dart';
import '../common/colors.dart';

import '../model/personal_info_model.dart';
import '../resume_modules/resume_modules_list.dart';

class CreateCover extends StatefulWidget {
  const CreateCover({super.key});

  @override
  State<CreateCover> createState() => CreateCoverState();
}

class CreateCoverState extends State<CreateCover> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CustomText(
                      text: "Create Cover Letter",
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      textColor: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () {
                        AppUtils().storeId("cover_edit", "0");
                        AppUtils().storeId("new_cover", "1");
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const TemplateCoverHome(),
                                        ),
                                      );
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Mycolors().blue),
                        height: 70,
                        width: 70,
                        child: const Icon(
                          Icons.add,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Add your Cover Letter',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              //body
              Expanded(
                child: mainBody(),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainBody() {
    return FutureBuilder(
        future: fetchaPersonalInfoProfiles(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            debugPrint("true");
            return ListView.builder(
                itemCount: personal_info.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Card(
                      elevation: 10,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.contain,
                                      'https://e7.pngegg.com/pngimages/46/732/png-clipart-job-cover-letter-author-application-for-employment-resume-get-out-credit-card-debt-company-hand.png',
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                    return Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.grey,
                                      child: const Icon(Icons.add),
                                    );
                                  }),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  personal_info[index]['first_name'] +
                                      " " +
                                      personal_info[index]['last_name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text("Created at: " +
                                          personal_info[index]['created_at'])),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      AppUtils().storeId("cover_edit", "1");
                                      storeDataCovers(index);
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const CoverLetterBuilder(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.orange,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      deleteDialogue(index);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      AppUtils().storeId(
                                          "get_cover_id",
                                          personal_info[index]['id']
                                              .toString());
                                      AppUtils().storeId("new_cover", "0");
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const TemplateCoverHome(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit_document,
                                      color: Colors.blue,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  dynamic personal_info = [];

  Future<List<PersonalInfo>> fetchaPersonalInfoProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var response = await http.get(
      Uri.parse(
          "http://resume.cognitiveitsolutions.ca/public/api/cover_letters"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  ${token}',
      },
    );
    print("cooverLetter: " + response.body.toString());
    personal_info = json.decode(response.body)['data'];

    debugPrint("info list: " + personal_info.toString());
    return (json.decode(response.body)['data'] as List)
        .map((e) => PersonalInfo.fromJson(e))
        .toList();
  }

  storeDataCovers(index) {
    AppUtils().storeId("edit_id_cover", personal_info[index]['id']);
    AppUtils().storeId("first_name_cover", personal_info[index]['first_name']);
    AppUtils().storeId("last_name_cover", personal_info[index]['last_name']);
    AppUtils()
        .storeId("phone_number_cover", personal_info[index]['phone_number']);
    AppUtils().storeId("email_cover", personal_info[index]['email_address']);
    AppUtils().storeId(
        "street_address_cover", personal_info[index]['street_address']);
    AppUtils().storeId("zip_code_cover", personal_info[index]['zip_code']);
    AppUtils().storeId("experience_cover", personal_info[index]['experience']);
    AppUtils().storeId("job_title_cover", personal_info[index]['job_title']);
    AppUtils()
        .storeId("employer_name_cover", personal_info[index]['employer_name']);
    AppUtils()
        .storeId("body_skills_cover", personal_info[index]['body_skills']);
    AppUtils()
        .storeId("opener_detail_cover", personal_info[index]['opener_detail']);
    AppUtils()
        .storeId("body_detail_cover", personal_info[index]['body_detail']);
    AppUtils()
        .storeId("closer_detail_cover", personal_info[index]['closer_detail']);
  }

  deleteDialogue(index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text("Delete Cover Letter"),
            content: const Column(
              children: [
                Text("Are you sure you want to delete complete Cover Letter?"),
                Text(
                  "By clicking yes the complete Cover Letter will be deleted from the system.",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteData(personal_info[index]["id"], index);
                    Navigator.pop(context);
                  },
                  child: const Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("No")),
            ],
          );
        });
  }

  deleteData(uuid, listindex) async {
    CustomProgressDialogue.progressDialogue(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var res = await CallApi().deleteInfoData("cover_letters/$uuid", token);
    var bodyOTP = jsonDecode(res.body);
    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {
        personal_info.removeAt(listindex);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}
