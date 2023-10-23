import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/auth.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../resume_sub_modules/reference.dart';

class EditReferences extends StatefulWidget {
  const EditReferences({super.key});

  @override
  State<EditReferences> createState() => _EditReferencesState();
}

class _EditReferencesState extends State<EditReferences> {
  String baseUrl = Auth.baseUrl;
  String designationEndpoint = Auth.getDesignation;

  List allDesignation = [];
  var designationDropdown;

  final List<TextEditingController> _namecontroller = [];
  final List<TextEditingController> _emailcontroller = [];
  final List<TextEditingController> _numbercontroller = [];
  final List<TextEditingController> _companycontroller = [];

  final List<TextField> _namefield = [];
  final List<TextField> _emailfield = [];
  final List<IntlPhoneField> _numberfield = [];
  final List<TextField> _companyfield = [];
  final List<DropdownButtonFormField> _designationfield = [];

  @override
  void initState() {
    super.initState();
    getDesignation();
    name.text = ReferencesState.fname;
    email.text = ReferencesState.femail;
    company.text = ReferencesState.fcompany;
    switch (ReferencesState.fdesignation) {
      case "CEO":
        designationDropdown = "1";
        break;
      case "Operation Manager":
        designationDropdown = "2";
        break;
      case "Project Manager":
        designationDropdown = "3";
        break;
      case "Team Lead":
        designationDropdown = "4";
        break;
      case "HR Manager":
        designationDropdown = "5";
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
                    text: "Reference",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Add/Update your reference.',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              //body
              Expanded(child: mainBody()),
              const SizedBox(height: 10),

              //button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    updateCertificates(ReferencesState.fid.toString());
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

  final name = TextEditingController();
  final email = TextEditingController();
  final number = TextEditingController();
  final company = TextEditingController();
  Widget mainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            // final namefield =
            _generateTextField(
              name,
              'Name',
              () {},
            ),
            SizedBox(
              height: 10,
            ),
            // final emailfield =
            _generateTextField(
              email,
              'Email',
              () {},
            ),
            SizedBox(
              height: 10,
            ),
            // final numberfield =
            IntlPhoneField(
              cursorColor: Colors.black,
              disableLengthCheck: true,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                labelStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
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
            SizedBox(
              height: 10,
            ),
            // final companyfield =
            _generateTextField(
              company,
              'Compan Name',
              () {},
            ),
            SizedBox(
              height: 10,
            ),
            // final designationfield =
            DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Select Designation',
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
              items: allDesignation.map((item) {
                return DropdownMenuItem(
                    value: item['id'].toString(),
                    child: Text(
                      item['name'].toString(),
                      overflow: TextOverflow.ellipsis,
                    ));
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  designationDropdown = newVal;
                });
              },
              value: designationDropdown,
            ),
            //_referenceListView(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _referenceListView() {
  //   return ListView.separated(
  //     physics: const RangeMaintainingScrollPhysics(),
  //     shrinkWrap: true,
  //     itemCount: _namefield.length,
  //     itemBuilder: (context, index) => Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Expanded(
  //               child: Column(
  //                 children: [
  //                   _namefield[index],
  //                   const SizedBox(height: 8),
  //                   _emailfield[index],
  //                   const SizedBox(height: 8),
  //                   _numberfield[index],
  //                   const SizedBox(height: 8),
  //                   _companyfield[index],
  //                   const SizedBox(height: 8),
  //                   _designationfield[index],
  //                 ],
  //               ),
  //             ),
  //             IconButton(
  //               onPressed: () {
  //                 setState(() {
  //                   _namefield.removeAt(index);
  //                   _emailfield.removeAt(index);
  //                   _numberfield.removeAt(index);
  //                   _companyfield.removeAt(index);
  //                   _designationfield.removeAt(index);
  //                 });
  //               },
  //               icon: const Icon(
  //                 Icons.delete_outline_rounded,
  //                 color: Colors.red,
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //     separatorBuilder: (context, index) => const SizedBox(
  //       height: 15,
  //     ),
  //   );
  // }

  TextField _generateTextField(
    TextEditingController controller,
    String label,
    GestureTapCallback? onTap,
  ) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  //get designation from api
  Future getDesignation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var response = await http.get(
      Uri.parse(baseUrl + designationEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  ${token}',
      },
    );
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      setState(() {
        allDesignation = jsonData;
      });
      print(allDesignation);
    } else {
      print(response.reasonPhrase);
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
      'name': name.text,
      'email': email.text,
      'company': company.text,
      'status': 1,
      'designation_id': designationDropdown.toString(),
    };
    var res = await CallApi()
        .updateInfoData(certCred, 'update_reference/' + id.toString(), token);
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
