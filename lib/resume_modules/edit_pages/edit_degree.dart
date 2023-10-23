// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../resume_sub_modules/education.dart';


class EducationEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EducationEditState();
  }
}

class EducationEditState extends State<EducationEdit> {
  final institute = TextEditingController();
  final field = TextEditingController();
  final cgpa = TextEditingController();
  final sDate = TextEditingController();
  final eDate = TextEditingController();
  var uid;
  EducationEditState() {
    institute.text = EducationState.inst;
    field.text = EducationState.fld;
    cgpa.text = EducationState.grd;
    sDate.text = EducationState.startdate;
    eDate.text = EducationState.enddate;
    uid = EducationState.uuid;
    switch (EducationState.deg_title) {
      case "Bachelors":
        _selectDegree = "bs";
        break;
      case "Intermediate":
        _selectDegree = "inter";
        break;
      case "Matriculation":
        _selectDegree = "matric";
        break;
    }
    switch (EducationState.gradetype) {
      case "cgpa":
        gType = "cgpa";
        break;
      case "percentage":
        gType = "percentage";
        break;
    }
  }

  List<DropdownMenuItem<String>> get degreeTitleList {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("PHD"), value: "phd"),
      DropdownMenuItem(child: Text("MS"), value: "ms"),
      DropdownMenuItem(child: Text("Bachelors"), value: "bs"),
      DropdownMenuItem(child: Text("Intermediate"), value: "inter"),
      DropdownMenuItem(child: Text("Matricultion"), value: "matric"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get gradeList {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("A"), value: "a"),
      DropdownMenuItem(child: Text("B"), value: "b"),
      DropdownMenuItem(child: Text("C"), value: "c"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get gradeType {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("CGPA"), value: "cgpa"),
      DropdownMenuItem(child: Text("Percentage"), value: "percentage"),
    ];
    return menuItems;
  }

  String _selectDegree = "bs";
  final String _selectGrade = "a";
  String gType = "cgpa";
  bool isChecked = false;
  CallApi _api = CallApi();
  var token;
  dynamic degreeList = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
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
                      text: "Edit Education",
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      textColor: Colors.black,
                    ),
                    Expanded(
                        child: SizedBox(
                      width: 20,
                    )),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: CustomText(
                    text: 'Update Educational Details',
                    textColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: institute,
                  decoration: InputDecoration(
                    labelText: "Institute",
                    hintText: "Your institute name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Degree Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value == null ? "Select Degree" : null,
                    value: _selectDegree,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectDegree = newValue!;
                      });
                    },
                    items: degreeTitleList),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Field",
                    hintText: "Add Your Specialization Field",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  controller: field,
                ),
                // SizedBox(height: 10),
                // DropdownButtonFormField(
                //     decoration: InputDecoration(
                //       labelText: "Grade",
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //     ),
                //     validator: (value) => value == null ? "Select Grade" : null,
                //     value: _selectGrade,
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         _selectGrade = newValue!;
                //       });
                //     },
                //     items: gradeList),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: "Grade Type",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) =>
                              value == null ? "Select Grade Type" : null,
                          value: gType,
                          onChanged: (String? newValue) {
                            setState(() {
                              gType = newValue!;
                            });
                          },
                          items: gradeType),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "CGPA/Percentage",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        controller: cgpa,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: sDate,
                        decoration: InputDecoration(
                          labelText: "Start Date",
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          DateTime date = DateTime(1900);
                          DateFormat('yyyy-MM-dd').format(date);
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100)))!;

                          sDate.text =
                              DateFormat('yyyy-MM-dd').format(date).toString();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: eDate,
                        decoration: InputDecoration(
                          labelText: "End Date",
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onTap: () async {
                          DateTime date = DateTime(1900);

                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100)))!;

                          eDate.text =
                              DateFormat('yyyy-MM-dd').format(date).toString();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                    Checkbox(
                      checkColor: Colors.white,
                      //fillColor: MaterialStateProperty.resolveWith(Colors.red),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'I am currently studying',
                      style: TextStyle(fontSize: 12.0),
                    ), //Text
                    //SizedBox
                    /** Checkbox Widget **/
                    //Checkbox
                  ], //<Widget>[]
                ),
                SizedBox(height: 10),

                SizedBox(
                  height: 250,
                ),
                //buttom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomButton(
                    onTap: () {
                      updateCoverLetter(uid);
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
      ),
    );
  }

  var user_id;
  updateCoverLetter(var id) async {
    CustomProgressDialogue.progressDialogue(context);
    var user_id, token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    var degree_id;
    switch (_selectDegree) {
      case "matric":
        degree_id = "1";
        break;
      case "inter":
        degree_id = "2";
        break;
      case "bs":
        degree_id = "3";
        break;
      case "ms":
        degree_id = "4";
        break;
      case "phd":
        degree_id = "5";
        break;
    }

    var certCred = {
      'institution': institute.text,
      'degree_id': degree_id,
      'field': field.text,
      'grade_type': gType.toString(),
      'grade': cgpa.text,
      'start_date': sDate.text,
      'end_date': eDate.text,
    };
    var res =
        await CallApi().updateInfoData(certCred, 'education/' + id, token);
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
