// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:aiproresume/apis/post_data.dart';
import 'package:aiproresume/common/error_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../location/city_list.dart';
import '../../location/country_list.dart';
import '../../location/state_list.dart';

class Experience1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Experience1State();
  }
}

class Experience1State extends State<Experience1> {
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
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("On Site"), value: "onsite"),
      DropdownMenuItem(child: Text("Remote"), value: "remote"),
      DropdownMenuItem(child: Text("Hybrid"), value: "hybrid"),
      DropdownMenuItem(child: Text("Internship"), value: "internship"),
    ];
    return menuItems;
  }

  static var country_id;
  static var state_id;
  var city_id;
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

  getCityLoc() async {
    prefs = await SharedPreferences.getInstance();
    city_id = prefs!.getString("cityID");
    //city_id = prefs!.getString("cityID");
    print("City:  " + city_id);
  }

  static String selectMstatus = "onsite";
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
                      text: "Experience",
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
                            //     builder: (context) => ListExperience(),
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
                    text: 'Add Experience Details',
                    textColor: Colors.grey,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: jobPosition,
                          decoration: InputDecoration(
                            labelText: "Job Position",
                            errorText: ErrorText().errorText(jobPosition),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: companyName,
                          decoration: InputDecoration(
                            labelText: "Company Name",
                            errorText: ErrorText().errorText(companyName),
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
                                            url: "states/show-states/" +
                                                country_id,
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
                                            url: "cities/show-cities/" +
                                                state_id,
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
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());

                                  date = (await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100)))!;

                                  sDate.text = DateFormat('yyyy-MM-dd')
                                      .format(date)
                                      .toString();
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
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  date = (await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100)))!;

                                  eDate.text = DateFormat('yyyy-MM-dd')
                                      .format(date)
                                      .toString();
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
                            errorText: ErrorText().errorText(industry),
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
                            errorText: ErrorText().errorText(description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          minLines: 1,
                          maxLines:
                              3, // allow user to enter 3 line in textfield
                          keyboardType: TextInputType.multiline,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
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

  var certCred;
  apiParams() async {
    getCityLoc();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
    certCred = {
      'profile_id': pid,
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
    PostData().post_data(context, certCred, "experiences");
  }
}
