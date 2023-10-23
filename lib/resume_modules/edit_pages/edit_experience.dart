// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../location/city_list.dart';
import '../../location/country_list.dart';
import '../../location/state_list.dart';
import '../listing/list_experience.dart';


class EditExperience1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditExperience1State();
  }
}

class EditExperience1State extends State<EditExperience1> {
  static final jobPosition = TextEditingController();
  static final companyName = TextEditingController();
  static final countryName = TextEditingController();
  static final stateName = TextEditingController();
  static final cityName = TextEditingController();
  static final locationType = TextEditingController();
  static final sDate = TextEditingController();
  static final eDate = TextEditingController();
  static final industry = TextEditingController();
  static final description = TextEditingController();
  bool isChecked = false;

  List<DropdownMenuItem<String>> get droplocationType {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("On Site"), value: "onsite"),
      DropdownMenuItem(child: Text("Remote"), value: "remote"),
      DropdownMenuItem(child: Text("Hybrid"), value: "hybrid"),
      DropdownMenuItem(child: Text("Internship"), value: "internship"),
    ];
    return menuItems;
  }

  static var country_id;
  static var state_id;
  static var city_id;
  SharedPreferences? prefs;
  getCountryLoc() async {
    prefs = await SharedPreferences.getInstance();
    country_id = prefs!.getString("countryID");

    print("Country:  " + country_id);
  }

  getStateLoc() async {
    prefs = await SharedPreferences.getInstance();
    state_id = prefs!.getString("stateID");
    //city_id = prefs!.getString("cityID");
    print("State:  " + state_id);
  }

  static String selectMstatus = "onsite";
  EditExperience1State() {
    jobPosition.text = ListExperienceState.jobpos;
    companyName.text = ListExperienceState.companyname;
    switch (ListExperienceState.jobtype) {
      case "onsite":
        selectMstatus = "onsite";
        break;
      case "hybrid":
        selectMstatus = 'hybrid';
        break;
      case "remote":
        selectMstatus = "remote";
        break;
      case "internship":
        selectMstatus = "internship";
        break;
    }
    sDate.text = ListExperienceState.startdate;
    eDate.text = ListExperienceState.enddate;
    industry.text = ListExperienceState.industry;
    description.text = ListExperienceState.desc;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
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
                      text: "Edit Experience",
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
                                builder: (context) => ListExperience(),
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
                    text: 'Update Experience Details',
                    textColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: jobPosition,
                  decoration: InputDecoration(
                    labelText: "Job Position",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: companyName,
                  decoration: InputDecoration(
                    labelText: "Company Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: countryName,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Country",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: AlertDialog(
                            title: Text("Search Country"),
                            content: CountryList(
                              url: "show-countries",
                              controller: countryName,
                            ),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: stateName,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "State/Province",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () {
                    getCountryLoc();
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: AlertDialog(
                            title: Text("Search State"),
                            content: country_id != null
                                ? StateList(
                                    url: "states/show-states/" + country_id,
                                    controller: stateName,
                                  )
                                : Text("Please choose country first"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: cityName,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "City Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onTap: () {
                    getStateLoc();
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: AlertDialog(
                            title: Text("Search City"),
                            content: state_id != null
                                ? CityList(
                                    url: "cities/show-cities/" + state_id,
                                    controller: cityName,
                                  )
                                : Text("Please Choose State First"),
                            actions: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: Colors.white,
                  ),
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        labelText: "Job Type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) =>
                          value == null ? "Select job type" : null,
                      value: selectMstatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectMstatus = newValue!;
                        });
                      },
                      items: droplocationType),
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
                const SizedBox(height: 10),
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
                      'I am currently employeed in this company',
                      style: TextStyle(fontSize: 12.0),
                    ), //Text
                    //SizedBox
                    /** Checkbox Widget **/
                    //Checkbox
                  ], //<Widget>[]
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: industry,
                  decoration: InputDecoration(
                    labelText: "Write Industry",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  minLines: 1,
                  maxLines: 3, // allow user to enter 3 line in textfield
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(
                  height: 10,
                ),
                //buttom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CustomButton(
                    onTap: () {
                      updateExperience(ListExperienceState.uuid.toString());
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
  updateExperience(var id) async {
    CustomProgressDialogue.progressDialogue(context);
    var user_id, token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    // if (country_id || state_id || city_id == null) {
    //   Navigator.of(context, rootNavigator: true).pop('dialog');
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     content: Text(
    //       "Please select country. state and city",
    //       style: TextStyle(fontSize: 16),
    //     ),
    //   ));
    // }

    var certCred = {
      'job_position': jobPosition.text,
      'company_name': companyName.text,
      'country_id': country_id,
      'state_id': state_id,
      'city_id': city_id,
      'type': selectMstatus,
      'start_date': sDate.text,
      'end_date': eDate.text,
      'company_description': industry.text,
      'job_description': description.text
    };
    var res = await CallApi()
        .updateInfoData(certCred, 'experiences/' + id.toString(), token);
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
