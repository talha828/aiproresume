// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../location/city_list.dart';
import '../../location/country_list.dart';
import '../../location/state_list.dart';

import 'dart:convert';

import '../apis/fetch_data.dart';
import '../apis/post_data.dart';
import '../apis/webapi.dart';
import '../common/colors.dart';

class CoverLetterBuilder extends StatefulWidget {
  const CoverLetterBuilder({super.key});

  @override
  State<CoverLetterBuilder> createState() => _CoverLetterBuilderState();
}

GlobalKey<FormState> _formKey1 = GlobalKey();
GlobalKey<FormState> _formKey2 = GlobalKey();
GlobalKey<FormState> _formKey3 = GlobalKey();
GlobalKey<FormState> _formKey4 = GlobalKey();

class _CoverLetterBuilderState extends State<CoverLetterBuilder> {
  getCoverEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isCoverEdit = prefs.getString("cover_edit");
    switch (isCoverEdit) {
      case "0":
        postCoverletter();

        break;
      case "1":
        updateCoverLetter();
        break;
      default:
    }
  }

  var user_id, token;
  postCoverletter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var certCred = {
      "first_name": CoverLetterHeaderP1State.firstNameCover.text,
      "last_name": CoverLetterHeaderP1State.lastName.text,
      "cover_id": prefs.getString("ctempId").toString(),
      "phone_number": CoverLetterHeaderP1State.mobileNumber.text,
      "email_address": CoverLetterHeaderP1State.emailAddress.text,
      "country_id": CountryListState.country_id_normal.toString(),
      "state_id": StateListState.state_id_normal.toString(),
      "city_id": CityListState.city_id_normal.toString(),
      'street_address': CoverLetterHeaderP1State.street.text,
      'zip_code': CoverLetterHeaderP1State.postalCode.text,
      'experience': CoverOpenerstate.value.toString() + " years",
      'job_title': CoverBodyState.jobTitleCover.text,
      'employer_name': CoverBodyState.employeerNameCover.text,
      'body_skills': CoverBodyState.bodySkillCover.text,
      'opener_detail': CoverOpenerstate.opener_detail.text,
      'body_detail': CoverBodyState.bodySuggestionCover.text,
      'closer_detail': CoverReviewState.closureSuggestion.text,
    };
    PostData().post_data(context, certCred, "cover_letters");
  }

  updateCoverLetter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var coverId = prefs.getString("edit_id_cover").toString();
    var certCred = {
      "first_name": CoverLetterHeaderP1State.firstNameCover.text,
      "last_name": CoverLetterHeaderP1State.lastName.text,
      "cover_id": coverId,
      "phone_number": CoverLetterHeaderP1State.mobileNumber.text,
      "email_address": CoverLetterHeaderP1State.emailAddress.text,
      "country_id": CountryListState.country_id_normal.toString(),
      "state_id": StateListState.state_id_normal.toString(),
      "city_id": CityListState.city_id_normal.toString(),
      'street_address': CoverLetterHeaderP1State.street.text,
      'zip_code': CoverLetterHeaderP1State.postalCode.text,
      'experience': CoverOpenerstate.value.toString() + " years",
      'job_title': CoverBodyState.jobTitleCover.text,
      'employeer_name': CoverBodyState.employeerNameCover.text,
      'body_skills': CoverBodyState.bodySkillCover.text,
      'opener_detail': CoverOpenerstate.opener_detail.text,
      'body_detail': CoverBodyState.bodySuggestionCover.text,
      'closer_detail': CoverReviewState.closureSuggestion.text,
    };
    PostData().updateCertificates(context, certCred, "cover_letters/$coverId");
  }

  static var dOB = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "male", child: Text("Male")),
      const DropdownMenuItem(value: "female", child: Text("Female")),
      const DropdownMenuItem(value: "other", child: Text("Other")),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get ddmaritalstatus {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "single", child: Text("Single")),
      const DropdownMenuItem(value: "married", child: Text("Married")),
      const DropdownMenuItem(value: "divorced", child: Text("Divorced")),
    ];
    return menuItems;
  }

  static String selectedValue = "female";
  String selectMstatus = "single";

  int _active_stepIndex = 0;

  int expPage = 1;
  File? _image;
  final picker = ImagePicker();
  String header_text = "Cover Letter Header";
  _changeHeaderText(step) {
    switch (step) {
      case 0:
        setState(() {
          header_text = "Cover Letter Header";
        });
        break;
      case 1:
        setState(() {
          header_text = "Cover Letter Opener";
        });
        break;
      case 2:
        setState(() {
          header_text = "Cover Letter Body";
        });
        break;
      case 3:
        setState(() {
          header_text = "Cover Letter Closure";
        });
        break;
      case 4:
        setState(() {
          header_text = "Cover Letter Review";
        });
        break;
    }
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
                  CustomText(
                    text: header_text.toString(),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text:
                      'Your name will be in the heading and signature of your cover letter',
                  textColor: Colors.grey,
                ),
              ),

              //stepper
              Theme(
                data: ThemeData(
                  colorScheme: Theme.of(context).colorScheme.copyWith(
                        primary: Mycolors().blue,
                      ),
                ),
                child: Expanded(
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: _active_stepIndex,
                    steps: stepList(),
                    onStepTapped: null,
                    // (step) {
                    //   _active_stepIndex = step;
                    // },
                    onStepContinue: () {
                      print("step: " + _active_stepIndex.toString());
                      _changeHeaderText(_active_stepIndex + 1);
                      final islastStep =
                          _active_stepIndex == stepList().length - 1;
                      if (_active_stepIndex < 4) {
                        setState(() {
                          _active_stepIndex += 1;
                        });
                      } else if (islastStep) {
                        getCoverEdit();
                        return;
                      }
                    },
                    onStepCancel: () {
                      _changeHeaderText(_active_stepIndex - 1);
                      if (_active_stepIndex > 0) {
                        setState(() => _active_stepIndex -= 1);
                      } else {
                        null;
                      }
                    },

                    controlsBuilder: (context, details) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: details.onStepCancel,
                                    child: const CustomText(text: 'Back'),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 55,
                                  child: ElevatedButton.icon(
                                    onPressed: details.onStepContinue,
                                    icon: const Icon(Icons.save,
                                        color: Colors.white),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Mycolors().blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    label: Text(
                                      style: TextStyle(color: Colors.white),
                                      _active_stepIndex == stepList().length - 1
                                          ? "Confirm"
                                          : "Continue",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Step> stepList() => [
        Step(
          state: _active_stepIndex > 0 ? StepState.complete : StepState.indexed,
          isActive: _active_stepIndex >= 0,
          title: const CustomText(text: ''),
          content: CoverLetterHeaderP1(),
        ),
        Step(
          state: _active_stepIndex > 1 ? StepState.complete : StepState.indexed,
          isActive: _active_stepIndex >= 1,
          title: const CustomText(text: ''),
          content: CoverOpener(),
        ),
        Step(
          state: _active_stepIndex > 2 ? StepState.complete : StepState.indexed,
          isActive: _active_stepIndex >= 2,
          title: const CustomText(text: ''),
          content: CoverBody(),
        ),
        Step(
          state: _active_stepIndex > 3 ? StepState.complete : StepState.indexed,
          isActive: _active_stepIndex >= 3,
          title: const CustomText(text: ''),
          content: CoverDigitalSignature(),
        ),
        Step(
          state: StepState.indexed,
          isActive: _active_stepIndex >= 4,
          title: const CustomText(text: ''),
          content: CoverReview(),
        ),
      ];
}

class CoverLetterHeaderP1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoverLetterHeaderP1State();
  }
}

class CoverLetterHeaderP1State extends State<CoverLetterHeaderP1> {
  CoverLetterHeaderP1State() {
    getCoverEdit();
  }
  getCoverEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isCoverEdit = prefs.getString("cover_edit");
    switch (isCoverEdit) {
      case "0":
        firstNameCover.clear();
        lastName.clear();
        mobileNumber.clear();
        emailAddress.clear();
        postalCode.clear();

        break;
      case "1":
        firstNameCover.text = prefs.getString("first_name_cover").toString();
        lastName.text = prefs.getString("last_name_cover").toString();
        mobileNumber.text = prefs.getString("phone_number_cover").toString();
        emailAddress.text = prefs.getString("email_cover").toString();
        street.text = prefs.getString("street_address_cover").toString();
        postalCode.text = prefs.getString("zip_code_cover").toString();

        break;
      default:
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  static var firstNameCover = TextEditingController();
  static var lastName = TextEditingController();
  static var mobileNumber = TextEditingController();
  static var emailAddress = TextEditingController();
  var country = TextEditingController();
  var stateProvince = TextEditingController();
  var city = TextEditingController();
  static var street = TextEditingController();
  static var postalCode = TextEditingController();

  var country_id;
  var state_id;
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: 570,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: firstNameCover,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                maxLength: 10,
                validator: (val) {
                  if ((val!.isEmpty)) {
                    return "First Name cannot be empty";
                  } else if (!RegExp(
                          r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                      .hasMatch(val)) {
                    return "Enter a valid name";
                  }
                  return null;
                },
              ),
              //SizedBox(height: 10),

              TextFormField(
                controller: lastName,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                maxLength: 10,
                validator: (val) {
                  if (!RegExp(
                          r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
                      .hasMatch(val!)) {
                    return "Enter a valid name";
                  }
                  return null;
                },
              ),
              //  SizedBox(height: 10),
              TextFormField(
                controller: emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                maxLength: 50,
                validator: (val) {
                  if ((val!.isEmpty)) {
                    return "Email cannot be empty";
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                      .hasMatch(val)) {
                    return "Enter a valid email address";
                  }
                  return null;
                },
              ),
              // SizedBox(height: 10),

              IntlPhoneField(
                controller: mobileNumber,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'PK',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },
              ),
              TextFormField(
                controller: country,
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
                            controller: country,
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
              SizedBox(height: 10),
              TextFormField(
                controller: stateProvince,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "state/Province",
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
                          title: Text("Search State/Province"),
                          content: CountryListState.country_id_normal != null
                              ? StateList(
                                  url: "states/show-states/" +
                                      CountryListState.country_id_normal,
                                  controller: stateProvince,
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
              SizedBox(height: 10),
              TextFormField(
                controller: city,
                decoration: InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  getStateLoc();
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        child: AlertDialog(
                          title: Text("Search City"),
                          content: StateListState.state_id_normal != null
                              ? CityList(
                                  url: "cities/show-cities/" +
                                      StateListState.state_id_normal,
                                  controller: city,
                                )
                              : Text("Please choose state first"),
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
              SizedBox(height: 10),

              TextFormField(
                controller: street,
                decoration: InputDecoration(
                  labelText: "Street Address",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: postalCode,
                decoration: InputDecoration(
                  labelText: "Postal Code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class CoverOpener extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoverOpenerstate();
  }
}

class CoverOpenerstate extends State<CoverOpener> {
  CoverOpenerstate() {
    getCoverEdit();
  }

  getCoverEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isCoverEdit = prefs.getString("cover_edit");
    switch (isCoverEdit) {
      case "0":
        value = 0.0;

        opener_detail.clear();

        break;
      case "1":
        // value = double.parse(prefs.getString("experience_cover").toString());
        opener_detail.text = prefs.getString("opener_detail_cover").toString();

        break;
      default:
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey();

  static double value = 0.0;
  static var opener_detail = TextEditingController();

  dynamic suggestList = [];
  var skillItem, skill_id;
  // Future<List<dynamic>> _getOpener() async {
  //   suggestList = FetchData().getCertasList("show-opener-suggestions");
  //   print("My Opener Suggests: " + suggestList[0].toString());
  //   return suggestList;
  // }
  CallApi _api = CallApi();
  var token;
  Future<List<dynamic>> _getOpener(endpointurl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    await _api.fetchCerts(endpointurl, token);
    suggestList = _api.response;
    debugPrint("Fetched Data: $suggestList");
    return suggestList;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: 580,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "How Long Have You Been Working?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Include relevant internships, Volunteer work and unpaid jobs",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              SfSlider(
                min: 0.0,
                max: 10.0,
                value: value,
                interval: 1,
                showLabels: true,
                showTicks: true,
                enableTooltip: true,
                // tooltipShape: SfRectangularTooltipShape(),
                onChanged: (dynamic newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: opener_detail,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Add Some Details",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 228, 228),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Some Opener Suggesstions for you",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder<List<dynamic>>(
                        future: _getOpener("show-opener-suggestions"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: suggestList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.add),
                                    title: CustomText(
                                        text: '${suggestList[index]['body']}'),
                                    onTap: () {
                                      skillItem = suggestList[index]['body'];
                                      opener_detail.text += "- $skillItem  ";
                                      //  Skill_id = suggestList[index]['id'];
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
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class CoverBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoverBodyState();
  }
}

class CoverBodyState extends State<CoverBody> {
  CoverBodyState() {
    getCoverEdit();
  }
  getCoverEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isCoverEdit = prefs.getString("cover_edit");
    switch (isCoverEdit) {
      case "0":
        jobTitleCover.clear();
        employeerNameCover.clear();
        bodySkillCover.clear();
        bodySuggestionCover.clear();

        break;
      case "1":
        jobTitleCover.text = prefs.getString("job_title_cover").toString();
        employeerNameCover.text =
            prefs.getString("employer_name_cover").toString();
        bodySkillCover.text = prefs.getString("body_skills_cover").toString();
        bodySuggestionCover.text =
            prefs.getString("body_detail_cover").toString();

        break;
      default:
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  static var jobTitleCover = TextEditingController();
  static var bodySkillCover = TextEditingController();
  static var employeerNameCover = TextEditingController();
  static var bodySuggestionCover = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Container(
        height: 570,
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                "Let's Add some more Detail",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: jobTitleCover,
                decoration: InputDecoration(
                  labelText: "Job Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: employeerNameCover,
                decoration: InputDecoration(
                  labelText: "Employeer Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field cannot be empty";
                  } else
                    return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: bodySkillCover,
                decoration: InputDecoration(
                  labelText: "Add skill relevant to your position",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 228, 228),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add these relevant skills to your position",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder(
                        future: _getSoftSkills("show_body_skills"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.add),
                                    title: CustomText(
                                        text: '${suggestList[index]['name']}'),
                                    onTap: () {
                                      skillItem = suggestList[index]['name'];
                                      bodySkillCover.text += "- $skillItem  ";
                                      //  Skill_id = suggestList[index]['id'];
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
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: bodySuggestionCover,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "Add Some Details",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: 250,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 228, 228),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Some Suggesstions for you",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: FutureBuilder(
                        future: _getBodySuggestions("show-body-suggestions"),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.add),
                                    title: CustomText(
                                        text: '${bodySugg[index]['body']}'),
                                    onTap: () {
                                      bodyItem = bodySugg[index]['body'];
                                      bodySuggestionCover.text +=
                                          "- $bodyItem  ";
                                      //  Skill_id = suggestList[index]['id'];
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
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  CallApi _api = CallApi();
  dynamic suggestList = [];
  var skillItem, skill_id;

  var token;
  Future<List<dynamic>> _getSoftSkills(endpointurl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    await _api.fetchCerts(endpointurl, token);
    suggestList = _api.response;
    debugPrint("Fetched Data: $suggestList");
    return suggestList;
  }

  dynamic bodySugg = [];
  var bodyItem;

  Future<List<dynamic>> _getBodySuggestions(endpointurl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    await _api.fetchCerts(endpointurl, token);
    bodySugg = _api.response;
    debugPrint("Fetched Data: $bodySugg");
    return bodySugg;
  }
}

class CoverReview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoverReviewState();
  }
}

class CoverReviewState extends State<CoverReview> {
  CoverReviewState() {
    getCoverEdit();
  }

  getCoverEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isCoverEdit = prefs.getString("cover_edit");
    switch (isCoverEdit) {
      case "0":
        closureSuggestion.clear();

        break;
      case "1":
        closureSuggestion.text =
            prefs.getString("closer_detail_cover").toString();

        break;
      default:
    }
  }

  static var closureSuggestion = TextEditingController();
  CallApi _api = CallApi();
  dynamic suggestList = [];
  var skillItem, skill_id;

  Future<List<dynamic>> _getClosureDetails(endpointurl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    await _api.fetchCerts(endpointurl, token);
    suggestList = _api.response;
    debugPrint("Fetched Data: $suggestList");
    return suggestList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      child: Column(children: [
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: closureSuggestion,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: "Add Some Closure Details",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 238, 228, 228),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Some Closer Suggesstions for you",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _getClosureDetails("show-closer-suggestions"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.add),
                              title: CustomText(
                                  text: '${suggestList[index]['body']}'),
                              onTap: () {
                                skillItem = suggestList[index]['body'];
                                closureSuggestion.text += "- $skillItem  ";
                                //  Skill_id = suggestList[index]['id'];
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}

class CoverDigitalSignature extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CoverDigitalSignState();
  }
}

class CoverDigitalSignState extends State<CoverDigitalSignature>
    with SingleTickerProviderStateMixin {
  String? fileName;
  late TabController _tabController;
  String fontStyle = 'Freehand';
  GlobalKey globalKey = GlobalKey();
  GlobalKey keyText = GlobalKey();
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  int? is_draw = 1, is_upload = 0, is_text = 0;
  String? filePath;
  void _pickFile() async {
    filePath = await FilePicker.platform
        .pickFiles(
          type: FileType.any,
        )
        .then((result) => result?.files.single.path);

    if (filePath != null) {
      print("File Path: " + filePath.toString());
      setState(() {
        fileName = filePath!.split('/').last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //header

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: CustomText(
              text: 'Add or Update your signature.',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          //body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                onTap: (value) {
                  print(value);
                  if (value == 0) {
                    is_draw = 1;
                    is_upload = 0;
                    is_text = 0;
                  } else if (value == 1) {
                    is_upload = 1;
                    is_draw = 0;
                    is_text = 0;
                  } else if (value == 2) {
                    is_text = 1;
                    is_upload = 0;
                    is_draw = 0;
                  }
                  print("draw: " + is_draw.toString());
                  print("Upload: " + is_upload.toString());
                  print("Text: " + is_text.toString());
                },
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: Mycolors().blue,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  SizedBox(
                    width: double.infinity,
                    child: Tab(
                      text: 'Draw',
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Tab(
                      text: 'Upload',
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Tab(
                      text: 'TextField',
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                // Draw
                RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, strokeAlign: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 4,
                          blurRadius: 7,
                          offset:
                              const Offset(4, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SfSignaturePad(
                      minimumStrokeWidth: 3,
                      maximumStrokeWidth: 3,
                      strokeColor: Mycolors().blue,
                      backgroundColor: Colors.grey[100],
                    ),
                  ),
                ),

                // image upload
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CustomText(text: fileName ?? 'Attach Document'),
                      ),
                      IconButton(
                          onPressed: () {
                            _pickFile();
                          },
                          icon: const Icon(Icons.attach_file_outlined))
                    ],
                  ),
                ),

                //signature text
                Column(
                  children: [
                    RepaintBoundary(
                      key: keyText,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: TextField(
                          cursorColor: Colors.black,
                          style: GoogleFonts.getFont(fontStyle, fontSize: 40),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(10),
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
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          _fontStyleChanger();
                        },
                        child: const CustomText(text: 'Signature Style'))
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 250,
          ),
          //const Spacer(),

          //buttom
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: CustomButton(
          //     onTap: () {
          //       if (is_draw == 1 && is_upload == 0 && is_text == 0) {
          //         _capturePng(globalKey);
          //       } else if (is_upload == 1 && is_draw == 0 && is_text == 0) {
          //         upload(filePath.toString());
          //       } else if (is_text == 1 && is_upload == 0 && is_draw == 0) {
          //         _capturePng(keyText);
          //       }
          //     },
          //     buttonText: 'Add/Update',
          //     sizeWidth: double.infinity,
          //     sizeHeight: 55,
          //   ),
          // ),
        ],
      ),
    );
  }

  void _fontStyleChanger() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStatesb) {
            return AlertDialog(
              title: const Text('Select a font'),
              content: SingleChildScrollView(
                child: DropdownButton<String>(
                  value: fontStyle,
                  onChanged: (String? font) {
                    setState(() {
                      fontStyle = font!;
                    });
                    setStatesb(
                      () {
                        fontStyle = font!;
                      },
                    );
                  },
                  items: <String>[
                    'Freehand',
                    'Dancing Script',
                    'Zeyada',
                    'Kaushan Script',
                    'Mr Dafoe',
                    'Parisienne',
                    'Homemade Apple',
                    'Pinyon Script',
                    'Mrs Saint Delafield',
                    'La Belle Aurore',
                  ].map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
