import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../resume_sub_modules/customsection.dart';


class EditCustomSection extends StatefulWidget {
  const EditCustomSection({super.key});

  @override
  State<EditCustomSection> createState() => _EditCustomSectionState();
}

class _EditCustomSectionState extends State<EditCustomSection> {
  final List<TextEditingController> _titlecntroller = [];
  final List<TextEditingController> _decriptioncontroller = [];

  final List<TextField> _titlefiled = [];
  final List<TextField> _descriptionfields = [];
  _EditCustomSectionState() {
    title.text = CustomSectionState.custom_title;
    description.text = CustomSectionState.custom_detail;
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
                    text: "Custom Section",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Add custom section',
                  textColor: Colors.grey,
                ),
              ),

              //body
              Expanded(child: mainBody()),
              const SizedBox(height: 10),

              //button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    updateCertificates(
                        CustomSectionState.custome_id.toString());
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

  final title = TextEditingController();
  final description = TextEditingController();

  Widget mainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),

            _generateTextField(
              title,
              'Title',
              () {},
              1,
            ),
            SizedBox(
              height: 10,
            ),
            _generateTextField(
              description,
              'Description',
              () {},
              6,
            ),
            // customListView()
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  static var custome_id, custom_detail;

  TextField _generateTextField(
    TextEditingController controller,
    String label,
    GestureTapCallback? onTap,
    int? maxline,
  ) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      onTap: onTap,
      maxLines: maxline!,
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

  var user_id, token;

  CallApi _api = CallApi();
  updateCertificates(String id) async {
    CustomProgressDialogue.progressDialogue(context);
    var user_id, token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    var profile_id = prefs.getString("profile_id");
    var certCred = {
      'title': title.text,
      'detail': description.text,
      'user_id': user_id.toString(),
      'status': "1",
      'personal_profile_id': profile_id.toString(),
    };
    var res =
        await CallApi().updateInfoData(certCred, 'custom_details/$id', token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    // const Center(
    //   child: CircularProgressIndicator(),
    // );

    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Record Updated Successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      print("Some  issue");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Error Updating data",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}
