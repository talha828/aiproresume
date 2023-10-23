// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, use_key_in_widget_constructors

import 'dart:io';

import 'package:aiproresume/create_tab/create_tab_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import '../../common/app_utils.dart';
import '../../common/colors.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../../common/error_text.dart';
import '../../location/city_list.dart';
import '../../location/country_list.dart';
import '../../location/state_list.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails();

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  var editProfile;
  var updateId;
  getisEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    editProfile = prefs.getString("edit_Profile");
    updateId = prefs.getString("personal_uuid_update");

    switch (editProfile) {
      case "0":
        upload();

      case "1":
        update(updateId);

        break;
      default:
    }
  }

  update(updateId) async {
    CustomProgressDialogue.progressDialogue(context);
    File? imageFile;
    try {
      imageFile = File(UP4.imagePath.path);
      var stream = http.ByteStream(imageFile.openRead());
      stream.cast();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Image not Selected",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var template_id = prefs.getString("template_id");
    //var profile_id = prefs.getString("profile_id");
    //var length = imageFile!.length;
    //print("lengthimage:  " + length.toString());

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> infoData = {
      "first_name": UserProfilePage1State.firstName.text.toString(),
      "last_name": UserProfilePage1State.lastName.text.toString(),
      "email_address": UserProfilePage1State.emailAddress.text.toString(),
      "job_title":
          UserProfilePage1State.jobTitlePersonal.text.toString().isEmpty
              ? "---"
              : UserProfilePage1State.jobTitlePersonal.text.toString(),
      "phone_number": UserProfilePage1State.phoneNumber.text.toString(),
      "contact_number": UserProfilePage1State.mobileNumber.text.toString(),
      "template_id": template_id.toString(),
      "country_id": CountryListState.country_id_normal.toString(),
      "state_id": StateListState.state_id_normal.toString(),
      "city_id": CityListState.city_id_normal.toString(),
      "street_address": UserProfilePage2state.street.text.toString().isEmpty
          ? "---"
          : UserProfilePage2state.street.text.toString(),
      "postal_code": UserProfilePage2state.postalCode.text.toString().isEmpty
          ? "---"
          : UserProfilePage2state.postalCode.text.toString(),
      "date_of_birth": UP3State.dOB.text.toString().isEmpty
          ? "---"
          : UP3State.dOB.text.toString(),
      "gender": UP3State.selectedValue.toString().isEmpty
          ? "---"
          : UP3State.selectedValue.toString(),
      "maritial_status": UP3State.selectMstatus.toString().isEmpty
          ? "---"
          : UP3State.selectMstatus.toString(),
      "nationality": UP3State.nationality.text.toString().isEmpty
          ? "---"
          : UP3State.nationality.text.toString(),
      "id_no": UP3State.idNo.text.toString().isEmpty
          ? "---"
          : UP3State.idNo.text.toString(),
      "_method": "PUT",
      "status": "1",
    };

    debugPrint("info data: $infoData");

    var fileExtension = AppUtils.getFileExtension(imageFile.toString());
    if (fileExtension.isEmpty) {
      print("Not found");
      return false;
    }

    var url = Uri.parse(
        "http://resume.cognitiveitsolutions.ca/public/api/personal_information/$updateId");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields.addAll(infoData);

    final file = await http.MultipartFile.fromPath(
        'profile_image', imageFile!.path,
        contentType: MediaType('application', fileExtension));
    request.files.add(file);
    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("Data uploaded");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated Successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context).pop();
    } else {
      print("Error: " + response.statusCode.toString());
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error Updating. Please check for empty fields",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }

  upload() async {
    CustomProgressDialogue.progressDialogue(context);
    File? imageFile;
    try {
      imageFile = File(UP4.imagePath.path);
      var stream = http.ByteStream(imageFile.openRead());
      stream.cast();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Image not Selected",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var template_id = prefs.getString("template_id");
    //var profile_id = prefs.getString("profile_id");
    //var length = imageFile!.length;
    //print("lengthimage:  " + length.toString());

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };

    Map<String, String> infoData = {
      "first_name": UserProfilePage1State.firstName.text.toString(),
      "last_name": UserProfilePage1State.lastName.text.toString(),
      "email_address": UserProfilePage1State.emailAddress.text.toString(),
      "job_title":
          UserProfilePage1State.jobTitlePersonal.text.toString().isEmpty
              ? "---"
              : UserProfilePage1State.jobTitlePersonal.text.toString(),
      "phone_number": UserProfilePage1State.phoneNumber.text.toString(),
      "contact_number": UserProfilePage1State.mobileNumber.text.toString(),
      "template_id": template_id.toString(),
      "country_id": CountryListState.country_id_normal.toString(),
      "state_id": StateListState.state_id_normal.toString(),
      "city_id": CityListState.city_id_normal.toString(),
      "street_address": UserProfilePage2state.street.text.toString().isEmpty
          ? "---"
          : UserProfilePage2state.street.text.toString(),
      "postal_code": UserProfilePage2state.postalCode.text.toString().isEmpty
          ? "---"
          : UserProfilePage2state.postalCode.text.toString(),
      "date_of_birth": UP3State.dOB.text.toString().isEmpty
          ? "---"
          : UP3State.dOB.text.toString(),
      "gender": UP3State.selectedValue.toString().isEmpty
          ? "---"
          : UP3State.selectedValue.toString(),
      "maritial_status": UP3State.selectMstatus.toString().isEmpty
          ? "---"
          : UP3State.selectMstatus.toString(),
      "nationality": UP3State.nationality.text.toString().isEmpty
          ? "---"
          : UP3State.nationality.text.toString(),
      "id_no": UP3State.idNo.text.toString().isEmpty
          ? "---"
          : UP3State.idNo.text.toString(),
    };

    debugPrint("info data: $infoData");

    var fileExtension = AppUtils.getFileExtension(imageFile.toString());
    if (fileExtension.isEmpty) {
      print("Not found");
      return false;
    }

    var url = Uri.parse(
        "http://resume.cognitiveitsolutions.ca/public/api/personal_information");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields.addAll(infoData);

    final file = await http.MultipartFile.fromPath(
        'profile_image', imageFile!.path,
        contentType: MediaType('application', fileExtension));
    request.files.add(file);
    var response = await request.send();
    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print("Data uploaded");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Updated Successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
      Navigator.of(context).pop();
    } else {
      print("Error: " + response.statusCode.toString());
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error Updating. Please check for empty fields",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
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
                    text: "Personal Details",
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
                      'Update your personal details, including your full name, email, phone number, address etc.',
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
                    onStepContinue: () {
                      print("step: " + _active_stepIndex.toString());
                      final islastStep =
                          _active_stepIndex == stepList().length - 1;
                      if (_active_stepIndex < 3) {
                        setState(() {
                          _active_stepIndex += 1;
                        });
                      } else if (islastStep) {
                        print("last step came");
                        getisEdit();
                        //upload();
                        return;
                      }
                    },
                    onStepCancel: _active_stepIndex > 0
                        ? () => setState(() => _active_stepIndex -= 1)
                        : null,
                    controlsBuilder: (context, details) {
                      return Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(
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
                                        : "Save and Next",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
          title: const CustomText(text: 'Info'),
          content: UserProfilePage1(),
        ),
        Step(
          state: _active_stepIndex > 1 ? StepState.complete : StepState.indexed,
          isActive: _active_stepIndex >= 1,
          title: const CustomText(text: 'Address'),
          content: UserProfilePage2(),
        ),
        Step(
          state: _active_stepIndex > 2 ? StepState.complete : StepState.indexed,
          isActive: _active_stepIndex >= 2,
          title: const CustomText(text: 'Details'),
          content: UserProfilePage3(),
        ),
        Step(
          state: StepState.indexed,
          isActive: _active_stepIndex >= 3,
          title: const CustomText(text: 'Extra'),
          content: UserProfilePage4(),
        ),
      ];

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    File file = File(pickedFile!.path);
    setState(() {
      _image = file;
    });
    print(_image);
    return file;
  }

  Future showSelectionDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select photo'),
          children: <Widget>[
            SimpleDialogOption(
              child: const Text('From gallery'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text('Take a photo'),
              onPressed: () {
                selectOrTakePhoto(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class UserProfilePage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserProfilePage1State();
  }
}

class UserProfilePage1State extends State<UserProfilePage1> {
  var editProfile;
  var profileId;
  getisEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    editProfile = prefs.getString("edit_Profile");
    profileId = prefs.getString("profile_id");
    var id = int.parse(profileId);
    switch (editProfile) {
      case "0":
        firstName.clear();
        lastName.clear();
        jobTitlePersonal.clear();
        emailAddress.clear();
        mobileNumber.clear();
        phoneNumber.clear();

      case "1":
        firstName.text = prefs.getString("personal_name").toString();
        lastName.text = prefs.getString("personal_last_name").toString();
        jobTitlePersonal.text =
            prefs.getString("personal_job_title").toString();
        emailAddress.text = prefs.getString("personal_email").toString();
        mobileNumber.text = prefs.getString("personal_phone").toString();
        phoneNumber.text = prefs.getString("personal_phone").toString();
        setState(() {});
        break;
      default:
    }
  }

  UserProfilePage1State() {
    getisEdit();

    //
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  static var firstName = TextEditingController();
  static var middleName = TextEditingController();
  static var lastName = TextEditingController();
  static var jobTitlePersonal = TextEditingController();
  static var mobileNumber = TextEditingController();
  static var phoneNumber = TextEditingController();
  static var emailAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: firstName,
                decoration: InputDecoration(
                  labelText: "First Name",
                  errorText: ErrorText().errorText(firstName),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                maxLength: 10,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (val) {
                  if ((val!.isEmpty)) {
                    return "First Name cannot be empty";
                  } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val)) {
                    return "Enter a valid name";
                  }
                  return null;
                },
              ),
              //SizedBox(height: 10),
              TextFormField(
                controller: middleName,
                decoration: InputDecoration(
                  labelText: "Middle Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                maxLength: 10,
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return "Field cannot be empty";
                //   }

                //   return null;
                // },
              ),
              // SizedBox(height: 10),
              TextFormField(
                controller: lastName,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  errorText: ErrorText().errorText(lastName),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                maxLength: 10,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (val) {
                  if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val!)) {
                    return "Enter a valid name";
                  }
                  return null;
                },
              ),
              //  SizedBox(height: 10),
              TextFormField(
                controller: jobTitlePersonal,
                decoration: InputDecoration(
                  labelText: "Job Title",
                  // errorText: ErrorText().errorText(jobTitlePersonal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                maxLength: 20,
                validator: (val) {
                  if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(val!)) {
                    return "Enter a valid Value";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailAddress,
                decoration: InputDecoration(
                  labelText: "Email Address",
                  errorText: ErrorText().errorTextEmail(emailAddress),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(50),
                ],
                maxLength: 50,
                onChanged: (value) {
                  setState(() {});
                },
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
                controller: phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  errorText: ErrorText().errorText(phoneNumber),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'PK',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  setState(() {});
                },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },
              ),
              // SizedBox(height: 10),
              IntlPhoneField(
                controller: mobileNumber,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  errorText: ErrorText().errorText(mobileNumber),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'PK',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  setState(() {});
                },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfilePage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UserProfilePage2state();
  }
}

class UserProfilePage2state extends State<UserProfilePage2> {
  var editProfile;
  var profileId;
  getisEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    editProfile = prefs.getString("edit_Profile");
    profileId = prefs.getString("profile_id");
    var id = int.parse(profileId);
    switch (editProfile) {
      case "0":
        street.clear();
        postalCode.clear();
        country.clear();
        stateProvince.clear();
        city.clear();

      case "1":
        street.text = prefs.getString("personal_street").toString();
        postalCode.text = prefs.getString("personal_postal").toString();

        break;
      default:
    }
  }

  UserProfilePage2state() {
    getisEdit();
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  static var country = TextEditingController();
  static var stateProvince = TextEditingController();
  static var city = TextEditingController();
  static var street = TextEditingController();
  static var postalCode = TextEditingController();

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

  // UserProfilePage2state() {
  //   getAllLoc();
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Build Callled: ");
    return Form(
      key: _formKey,
      child: Container(
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text(
              //   selected.toString(),
              // ),
              TextFormField(
                controller: country,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Country",
                  errorText: ErrorText().errorText(country),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
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
                  errorText: ErrorText().errorText(stateProvince),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
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
                  errorText: ErrorText().errorText(city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                readOnly: true,
                onChanged: (value) {
                  setState(() {});
                },
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
                maxLength: 30,
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
                maxLength: 20,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfilePage3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UP3State();
  }
}

class UP3State extends State<UserProfilePage3> {
  var editProfile;
  var profileId;
  getisEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    editProfile = prefs.getString("edit_Profile");
    profileId = prefs.getString("profile_id");
    var id = int.parse(profileId);
    switch (editProfile) {
      case "0":
        dOB.clear();

        nationality.clear();

        idNo.clear();
      case "1":
        dOB.text = prefs.getString("personal_dob").toString();
        //selectedValue = prefs.getString("personal_gender").toString();
        nationality.text =
            prefs.getString("personal_nationality").toString() + " National ";
        // selectMstatus = prefs.getString("personal_marital").toString();
        idNo.text = prefs.getString("personal_cnic").toString();
        break;
      default:
    }
  }

  UP3State() {
    getisEdit();
  }

  GlobalKey<FormState> _formKey = GlobalKey();
  static var dOB = TextEditingController();
  static var gender = TextEditingController();
  static var nationality = TextEditingController();
  static var maritalStatus = TextEditingController();
  static var idNo = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Male"), value: "male"),
      DropdownMenuItem(child: Text("Female"), value: "female"),
      DropdownMenuItem(child: Text("Other"), value: "other"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get ddmaritalstatus {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Single"), value: "single"),
      DropdownMenuItem(child: Text("Married"), value: "married"),
      DropdownMenuItem(child: Text("Divorced"), value: "divorced"),
    ];
    return menuItems;
  }

  static String selectedValue = "female";
  static String selectMstatus = "single";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Container(
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: dOB,
                decoration: InputDecoration(
                  labelText: "Date of birth",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onTap: () async {
                  DateTime date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());

                  date = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100)))!;

                  dOB.text = DateFormat('yyyy-MM-dd').format(date).toString();
                },
              ),
              SizedBox(height: 10),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                ),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Gender",
                      hoverColor: Colors.white,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value == null ? "Select gender" : null,
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    items: dropdownItems),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nationality,
                maxLength: 15,
                enableSuggestions: true,
                decoration: InputDecoration(
                  labelText: "Nationality",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.white,
                ),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: "Marital Status",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) =>
                        value == null ? "Select marital Status" : null,
                    value: selectMstatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectMstatus = newValue!;
                      });
                    },
                    items: ddmaritalstatus),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: idNo,
                decoration: InputDecoration(
                  labelText: "CNIC No",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Field cannot be empty";
                  } else
                    return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfilePage4 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UP4();
  }
}

class UP4 extends State<UserProfilePage4> {
  GlobalKey<FormState> _formKey = GlobalKey();
  static var website = TextEditingController();
  static var linkedInUrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  static var length;
  static dynamic imagePath;
  getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    File mimage = File(image!.path);
    // print(image);
    if (mimage != null) {
      setState(() {
        imagePath = mimage;
        print("Image Path" + imagePath.path);
        length = UP4.imagePath!.length;
        print("NowLength" + length.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _formKey,
      child: Container(
        height: 450,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: website,
                decoration: InputDecoration(
                  labelText: "Website",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: linkedInUrl,
                decoration: InputDecoration(
                  labelText: "Add LinkedIn URL",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(5, 5),
                        ),
                      ],
                    ),
                    child: imagePath != null
                        ? CircleAvatar(
                            radius: 80,
                            backgroundImage: FileImage(
                              imagePath,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            color: Colors.grey.shade300,
                            size: 80.0,
                          ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Colors.blue,
                              ),
                              child: SafeArea(
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: Colors.blue,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(
                                          Icons.camera,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          'Camera',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        onTap: () {
                                          getImage(ImageSource.camera);
                                          // this is how you dismiss the modal bottom sheet after making a choice
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.image,
                                          color: Colors.blue,
                                        ),
                                        title: Text(
                                          'Gallery',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        onTap: () {
                                          getImage(ImageSource.gallery);
                                          // dismiss the modal sheet
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Text("Upload Photo"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
