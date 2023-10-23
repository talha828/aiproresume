import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apis/auth.dart';
import '../../../common/custom_buttom.dart';
import '../../../common/custom_text.dart';
import '../../../common/custom_textfield.dart';
import '../../../model/contact_model.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

String baseUrl = Auth.baseUrl;
String contactendpoist = Auth.contactEndpoint;
String? fileName;

final _title = TextEditingController();
final _email = TextEditingController();
final _contact = TextEditingController();
final _detail = TextEditingController();
final _formKey = GlobalKey<FormState>();

class _ContactState extends State<Contact> {
  String dropdownValue = 'Resume';
  var item = [
    'Resume',
    'Cover Letter',
    'Other',
  ];

  void _pickFile() async {
    String? filePath = await FilePicker.platform
        .pickFiles(
          type: FileType.any,
        )
        .then((result) => result?.files.single.path);

    if (filePath != null) {
      setState(() {
        fileName = filePath.split('/').last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //heading
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
                    text: "Contact Us",
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
                      'Consult us for a professional \nResume, Coverletter or general inquiry',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),

              //body
              Expanded(child: _mainBody()),

              // Submit
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      contact(_title.text, _email.text, _contact.text,
                          _detail.text);
                    }
                  },
                  buttonText: 'SUBMIT',
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

  Widget _mainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title

              CustomTextField(
                controller: _title,
                maxLines: 1,
                hintText: 'Title',
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Title Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email
              CustomTextField(
                controller: _email,
                maxLines: 1,
                hintText: 'Email',
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Email Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Number
              CustomTextField(
                controller: _contact,
                maxLines: 1,
                textInputType: TextInputType.phone,
                hintText: 'Contact No',
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Number Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              //Attachment
              // Container(
              //   height: 60,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(color: Colors.grey, width: 1),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(left: 10),
              //         child: CustomText(text: fileName ?? 'Attach Document'),
              //       ),
              //       IconButton(
              //           onPressed: () {
              //             _pickFile();
              //           },
              //           icon: const Icon(Icons.attach_file_outlined))
              //     ],
              //   ),
              // ),
              ButtonTheme(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  elevation: 2,
                  icon: const Icon(Icons.expand_more_rounded),
                  borderRadius: BorderRadius.circular(5),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: dropdownValue,
                  onChanged: (newValue) {
                    setState(
                      () {
                        dropdownValue = newValue!;
                      },
                    );
                  },
                  items: item.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: CustomText(
                        text: items,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Message
              CustomTextField(
                controller: _detail,
                maxLines: 5,
                hintText: 'Message',
                validate: (value) {
                  if (value!.isEmpty) {
                    return 'Message Required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<ContactUs> contact(
    final String title,
    final String email,
    final String conatct,
    final String detail,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    final http.Response response = await http.post(
      Uri.parse(baseUrl + contactendpoist),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer  $token',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'email': email,
        'contact': conatct,
        'detail': detail,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('We Contact You ASAP'),
        ),
      );
      return ContactUs.fromJson(json.decode(response.body));
    } else {
      throw ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fail to send message'),
        ),
      );
    }
  }
}
