// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:aiproresume/apis/post_data.dart';
import 'package:aiproresume/common/colors.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../edit_pages/edit_degree.dart';

class Education extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EducationState();
  }
}

class EducationState extends State<Education> {
  final institute = TextEditingController();
  final field = TextEditingController();
  final cgpa = TextEditingController();
  final sDate = TextEditingController();
  final eDate = TextEditingController();

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
  String _selectGrade = "a";
  String gType = "cgpa";
  bool isChecked = false;

  dynamic degreeList = [];
  static var inst, deg_title, fld, grd, gradetype, cpgrade, startdate, enddate;
  static var uuid;

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
                      text: "Education",
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
                    text: 'Add Educational Details',
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
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 238, 228, 228)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Your Degrees"),
                      SizedBox(height: 10),
                      Expanded(
                        child: FutureBuilder<List<dynamic>>(
                            future: dataFetched(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: eList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Card(
                                      child: ListTile(
                                        leading: IconButton(
                                          onPressed: () {
                                            setState(() {});
                                            inst = eList[index]['institution'];
                                            deg_title =
                                                eList[index]['degree']['title'];
                                            fld = eList[index]['field'];
                                            gradetype =
                                                eList[index]['grade_type'];
                                            grd = eList[index]['grade'];
                                            startdate =
                                                eList[index]['start_date'];
                                            enddate = eList[index]['end_date'];
                                            uuid = eList[index]['uuid'];
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    EducationEdit(),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Mycolors().blue,
                                          ),
                                        ),
                                        title: Text(
                                            '${eList[index]['degree']['title'].toString()}',
                                            style: TextStyle()),
                                        onTap: () {
                                          inst = eList[index]['institution'];
                                          deg_title =
                                              eList[index]['degree']['title'];
                                          fld = eList[index]['field'];
                                          gradetype =
                                              eList[index]['grade_type'];
                                          grd = eList[index]['grade'];
                                          startdate =
                                              eList[index]['start_date'];
                                          enddate = eList[index]['end_date'];
                                          uuid = eList[index]['uuid'];
                                          // Navigator.push(
                                          //   context,
                                          //   CupertinoPageRoute(
                                          //     builder: (context) =>
                                          //         EducationEdit(),
                                          //   ),
                                          // );
                                        },
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            print("DeleteITEM: " +
                                                eList[index]['id'].toString());
                                            deleteCertificates(
                                                eList[index]['uuid'], index);
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
                SizedBox(
                  height: 10,
                ),
                //buttom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
      ),
    );
  }
 deleteCertificates(var index, int listIndex) async {
    CustomProgressDialogue.progressDialogue(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Deleting ...",
        style: TextStyle(fontSize: 16),
      ),
    ));
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var user_id = prefs.getString("user_id");
   var token = prefs.getString("session_token");
    print("UserID: " + user_id.toString());
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
      // 'institution': institute.text,
      // 'degree_id': degree_id,
      // 'field': field.text,
      // 'grade_type': gType.toString(),
      // 'grade': cgpa.text,
      // 'start_date': sDate.text,
      // 'end_date': eDate.text,
    };
    var res = await CallApi()
        .deleteInfoData( 'education/' + index.toString(), token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {
        eList.removeAt(listIndex);
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
  dynamic eList = [];
  String? skillItem;
  Future<List<dynamic>> dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
    eList = await FetchData().getCertasList("education?profile_id=$pid");

    // debugPrint("Summary: $eList");
    return eList;
  }

  var certCred;
  apiParams() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
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
    if (pid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Please add Personal Details first",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      var certCred = {
        // 'body': _coverLetter.text,
        'institution': institute.text,
        'degree_id': degree_id,
        'field': field.text,
        'grade_type': gType.toString(),
        'grade': cgpa.text,
        'start_date': sDate.text,
        'end_date': eDate.text,
        'profile_id': pid,
      };
      PostData().post_data(context, certCred, 'education');
    }
  }
}
