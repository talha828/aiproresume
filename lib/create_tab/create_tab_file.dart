// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'dart:convert';
import 'package:aiproresume/common/custom_dialogue.dart';
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
import '../resume_modules/resume_modules_edit_list.dart';
import '../resume_modules/resume_modules_list.dart';

class CreateResumeCover extends StatefulWidget {
  const CreateResumeCover({super.key});

  @override
  State<CreateResumeCover> createState() => CreateResumeCoverState();
}

class CreateResumeCoverState extends State<CreateResumeCover> {
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
                      text: "Create Resume",
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      textColor: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () {
                        AppUtils().storeId("new_profile", "1");
                        AppUtils().storeId("edit_Profile", "0");
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const Template(),
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
                  text: 'Add your Resume',
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
                  var imgLink =
                      'http://resume.cognitiveitsolutions.ca/public/images/${personal_info[index]['profile_image']}';

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
                                      'http://resume.cognitiveitsolutions.ca/public/images/${personal_info[index]['profile_image']}',
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
                                      AppUtils().storeId("profile_id",
                                          personal_info[index]['id']);

                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => ProfileTab(),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    onPressed: () {
                                      AppUtils().storeId("edit_Profile", "1");
                                      AppUtils().storeId("profile_id",
                                          personal_info[index]['id']);
                                      saveAllData(index);
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const EditProfileTab(),
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
                                      AppUtils().storeId("profile_id",
                                          personal_info[index]['id']);
                                      AppUtils().storeId("new_profile", "0");
                                      AppUtils().storeId(
                                          "profile_name",
                                          personal_info[index]['first_name'] +
                                              " " +
                                              personal_info[index]
                                                  ['last_name']);
                                      AppUtils().storeId("job_title",
                                          personal_info[index]['job_title']);
                                      AppUtils().storeId(
                                          "profile_pic",
                                          personal_info[index]
                                              ['profile_image']);
                                      AppUtils().storeId("contact_info",
                                          personal_info[index]['phone_number']);
                                      AppUtils().storeId(
                                          "email_address",
                                          personal_info[index]
                                              ['email_address']);
                                      AppUtils().storeLocationIds(
                                          "mulk",
                                          "suba",
                                          "shehar",
                                          personal_info[index]['country_id'],
                                          personal_info[index]['state_id'],
                                          personal_info[index]['city_id']);
                                      Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const Template(),
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

  saveAllData(index) async {
    //first page
    AppUtils().storeId("personal_name", personal_info[index]['first_name']);
    AppUtils().storeId("personal_last_name", personal_info[index]['last_name']);
     AppUtils().storeId("personal_job_title", personal_info[index]['job_title']);
      AppUtils().storeId("personal_email", personal_info[index]['email_address']);
       AppUtils().storeId("personal_phone", personal_info[index]['phone_number']);
        AppUtils().storeId("personal_contact", personal_info[index]['contact_number']);
        //second page
        AppUtils().storeId("personal_street", personal_info[index]['street_address']);
           AppUtils().storeId("personal_postal", personal_info[index]['postal_code']);
           //third page
           AppUtils().storeId("personal_dob", personal_info[index]['date_of_birth']);
           AppUtils().storeId("personal_gender", personal_info[index]['gender']);
           AppUtils().storeId("personal_nationality", personal_info[index]['maritial_status']);
           AppUtils().storeId("personal_marital", personal_info[index]['nationality']);
           AppUtils().storeId("personal_cnic", personal_info[index]['id_no']);

           //uuid to update
           AppUtils().storeId("personal_uuid_update", personal_info[index]['uuid']);



  }

  dynamic personal_info = [];

  Future<List<PersonalInfo>> fetchaPersonalInfoProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var response = await http.get(
      Uri.parse(
          "http://resume.cognitiveitsolutions.ca/public/api/personal_information"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  ${token}',
      },
    );
    var jsonData = json.decode(response.body) as Map<String, dynamic>;

    jsonData.forEach((k, v) => _getdata(k, v));
    // debugPrint("Json data: $jsonData");
    debugPrint("info list: " + personal_info.toString());
    return (json.decode(response.body)['data'] as List)
        .map((e) => PersonalInfo.fromJson(e))
        .toList();
  }

  _getdata(k, v) {
    if (k == 'data') {
      v.forEach((v1) {
        personal_info = v1['personal_information'];

        print("NamePrint: " + personal_info[0]['first_name'].toString());
        // v1['personal_information'].forEach((v2) {

        //   profile_id_personal = v2['first_name'] + " " + v2['last_name'];
        //   print("profileeee: " + profile_id_personal.toString());

        // });
      });
    }
  }

  deleteDialogue(index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text("Delete Profile"),
            content: const Column(
              children: [
                Text("Are you sure you want to delete complete profile?"),
                Text(
                  "By clicking yes the complete profile will be deleted from the system.",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    deleteData(personal_info[index]["uuid"], index);
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
    var res =
        await CallApi().deleteInfoData("personal_information/$uuid", token);
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
