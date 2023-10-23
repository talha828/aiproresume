// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../../apis/auth.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';

import 'package:http/http.dart' as http;

import '../resume_sub_modules/languages.dart';



class EditLanguages extends StatefulWidget {
  const EditLanguages({super.key});

  @override
  State<EditLanguages> createState() => _EditLanguagesState();
}

final List<DropdownButtonFormField> _languagelevelsfield = [];
final List<DropdownButtonFormField> _languagefield = [];

String baseUrl = Auth.baseUrl;
String languagesEndpoint = Auth.getAllLanguages;
String languageslevelEndPpoint = Auth.getLangusgesLevel;

List allLanguages = [];
List languagesLevel = [];

var languagesDropdown;
var languagesLevelDropdown;

class _EditLanguagesState extends State<EditLanguages> {
  @override
  void initState() {
    super.initState();
    getLanguages();
    getLanguagesLevel();
    languagesLevelDropdown = LanguagesState.levelSelected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
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
                    text: "Languages",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Update your languages.',
                  textColor: Colors.grey,
                ),
              ),

              //body
              // Expanded(child: ),
              mainBody(),
              const SizedBox(height: 10),

              //button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    updateCertificates(LanguagesState.langSelected.toString());
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          // DropdownButtonFormField(
          //   isExpanded: true,
          //   decoration: InputDecoration(
          //     labelText: 'Choose Language',
          //     labelStyle: const TextStyle(color: Colors.black),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide: const BorderSide(color: Colors.black, width: 2.0),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     hintStyle: const TextStyle(
          //       color: Colors.black,
          //     ),
          //     errorStyle: const TextStyle(
          //       color: Colors.red,
          //       fontSize: 12.0,
          //       fontWeight: FontWeight.w300,
          //       fontStyle: FontStyle.normal,
          //       letterSpacing: 1.2,
          //     ),
          //     errorBorder: OutlineInputBorder(
          //       borderSide: const BorderSide(color: Colors.red),
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     focusedErrorBorder: OutlineInputBorder(
          //       borderSide: const BorderSide(color: Colors.red),
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //   ),
          //   items: allLanguages.map((item) {
          //     lang = item['id'].toString();
          //     print("lang id: " + lang.toString());
          //     return DropdownMenuItem(
          //         value: item['id'].toString(),
          //         child: Text(
          //           item['name'].toString(),
          //           overflow: TextOverflow.ellipsis,
          //         ));
          //   }).toList(),
          //   onChanged: (newVal) {
          //     setState(() {
          //       languagesDropdown = newVal;
          //       // aStr =
          //       //     languagesDropdown.replaceAll(new RegExp(r'[^0-9]'), '');
          //       print("Val" + languagesDropdown);
          //     });
          //   },
          //   value: languagesDropdown,
          // ),
          // SizedBox(
          //   height: 20,
          // ),
          //languages level
          // final languageslevels =
          DropdownButtonFormField(
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Language Level',
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              hintStyle: const TextStyle(
                color: Colors.black,
              ),
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 12.0,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
                letterSpacing: 1.2,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            items: languagesLevel.map((item) {
              // level_id = item['id'].toString();
              return DropdownMenuItem(
                  value: item['name'].toString(),
                  child: Text(
                    item['name'].toString(),
                    overflow: TextOverflow.ellipsis,
                  ));
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                languagesLevelDropdown = newVal;
                switch (languagesLevelDropdown) {
                  case "Beginner":
                    level_id = "1";
                    break;
                  case "Intermediate":
                    level_id = "2";
                    break;
                  case "Advanced":
                    level_id = "3";
                    break;
                }
              });
            },
            value: languagesLevelDropdown,
          ),
          // _languageListView(),
        ],
      ),
    );
  }

  var aStr;
  Widget _languageListView() {
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      //itemCount: 3,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _languagefield[index],
                    const SizedBox(height: 10),
                    _languagelevelsfield[index],
                  ],
                ),
              ),
              // IconButton(
              //   onPressed: () {
              //     setState(() {
              //       _languagefield.removeAt(index);
              //       _languagelevelsfield.removeAt(index);
              //     });
              //   },
              //   icon: const Icon(
              //     Icons.delete_outline_rounded,
              //     color: Colors.red,
              //   ),
              // )
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
    );
  }

  // Get Lanuages from api
  var lang;
  Future getLanguages() async {
    var response = await http.get(Uri.parse(baseUrl + languagesEndpoint));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      //  lang = jsonData['id'].toString();
      setState(() {
        allLanguages = jsonData;
      });
      print(allLanguages);
    } else {}
  }

  var level_id;
  //get languages level from api
  Future getLanguagesLevel() async {
    var response = await http.get(Uri.parse(baseUrl + Auth.getLangusgesLevel));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];

      print("level" + level_id.toString());
      setState(() {
        languagesLevel = jsonData;
      });
      print(languagesLevel);
    } else {
      print('error');
    }
  }

  var user_id, token;

  CallApi _api = CallApi();
  updateCertificates(String id) async {
    CustomProgressDialogue.progressDialogue(context);
    var user_id, token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    var certCred = {
      'level_id': level_id,
    };
    var res = await CallApi().updateInfoData(
        certCred, 'update_user_language_level/' + id.toString(), token);
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
