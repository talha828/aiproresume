// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../resume_sub_modules/certificates.dart';

class CertificatesEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // ignore: todo
    // TODO: implement createState
    return CertificatesEditState();
  }
}

class CertificatesEditState extends State<CertificatesEdit> {
  final title = TextEditingController();
  final description = TextEditingController();
  final institute = TextEditingController();
  final cdate = TextEditingController();
  var id;

  CertificatesEditState() {
    title.text = CertificatesState.ctitle;
    description.text = CertificatesState.cdescription;
    institute.text = CertificatesState.cdescription;
    cdate.text = CertificatesState.date;
    id = CertificatesState.id.toString();
  }

  final _formKey = GlobalKey<FormState>();
  bool? isUpdate = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Form(
                key: _formKey,
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
                        const SizedBox(width: 20),
                        const CustomText(
                          text: "Edit Certificates",
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          textColor: Colors.black,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: CustomText(
                        text: 'Add Certification Details',
                        textColor: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Add title",
                        hintText: "Please choose title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // user keyboard will have a button to move cursor to next line
                      controller: title,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field must not be empty";
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Add Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      minLines: 1,
                      maxLines: 5, // allow user to enter 3 line in textfield
                      keyboardType: TextInputType
                          .multiline, // user keyboard will have a button to move cursor to next line
                      controller: description,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field must not be empty";
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Add Institute",
                        hintText: "Please write Name of Institute",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      // user keyboard will have a button to move cursor to next line
                      controller: institute,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field must not be empty";
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: cdate,
                      decoration: InputDecoration(
                        labelText: "Certification Date",
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field must not be empty";
                        }
                      },
                      onTap: () async {
                        DateTime date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());

                        date = (await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100)))!;

                        cdate.text =
                            DateFormat('yyyy-MM-dd').format(date).toString();
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 350,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: CustomButton(
                        onTap: () {
                          updateCertificates(id);
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
        ),
      ),
    );
  }

  updateCertificates(String id) async {
    CustomProgressDialogue.progressDialogue(context);
    var user_id, token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    var certCred = {
      'title': title.text,
      'description': description.text,
      'institute': institute.text,
      'date': cdate.text,
      'user_id': user_id
    };
    var res =
        await CallApi().updateInfoData(certCred, 'certificates/' + id, token);
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
