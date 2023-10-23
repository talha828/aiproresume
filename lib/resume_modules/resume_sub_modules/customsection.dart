import 'dart:convert';

import 'package:aiproresume/apis/post_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../edit_pages/edit_custom_section.dart';

class CustomSection extends StatefulWidget {
  const CustomSection({super.key});

  @override
  State<CustomSection> createState() => CustomSectionState();
}

class CustomSectionState extends State<CustomSection> {
  final List<TextEditingController> _titlecntroller = [];
  final List<TextEditingController> _decriptioncontroller = [];

  final List<TextField> _titlefiled = [];
  final List<TextField> _descriptionfields = [];

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
                    postCustomDetails();
                  },
                  buttonText: 'Add/Update',
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
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 228, 228)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Custom Data"),
                  SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                        future: dataFetched(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: custList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: IconButton(
                                      onPressed: () {
                                        setState(() {});
                                        custome_id = custList[index]['id'];
                                        custom_detail =
                                            custList[index]['detail'];
                                        custom_title = custList[index]['title'];
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  const EditCustomSection()),
                                         );
                                        // showAlertDialog(context);
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    title: Text('${custList[index]['title']}',
                                        style: TextStyle()),
                                    subtitle: Text(
                                        '${custList[index]['detail']}',
                                        style: TextStyle()),
                                    onTap: () {
                                      setState(() {});
                                    },
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        deleteCertificates(
                                            custList[index]['id'], index);
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
          ],
        ),
      ),
    );
  }

  static var custome_id, custom_detail, custom_title;
  Widget customListView() {
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _titlefiled.length,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _titlefiled[index],
                    const SizedBox(height: 8),
                    _descriptionfields[index],
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _titlefiled.removeAt(index);
                    _descriptionfields.removeAt(index);
                  });
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
    );
  }

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

  dynamic custList = [];

  Future<List<dynamic>> dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profile_id = prefs.getString("profile_id");
    custList = await FetchData()
        .getCertasList("custom_details?profile_id=$profile_id");
    return custList;
  }

  postCustomDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var profile = prefs.getString("profile_id");
    var certCred = {
      'title': title.text,
      'detail': description.text,
      'personal_profile_id': profile.toString(),
    };
    PostData().post_data(context, certCred, "custom_details");
  }

  deleteCertificates(int index, int listIndex) async {
    //isDelete = false;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Deleting ...",
        style: TextStyle(fontSize: 16),
      ),
    ));
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var user_id = prefs.getString("user_id");
   var token = prefs.getString("session_token");
    var profile_id = prefs.getString("profile_id");
    print("UserID: " + user_id.toString());
    var certCred = {
      'title': title.text,
      'detail': description.text,
      'user_id': user_id.toString(),
      'personal_profile_id': profile_id.toString(),
    };
    var res = await CallApi()
        .deleteInfoData( 'custom_details/$index', token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      setState(() {
        custList.removeAt(listIndex);
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Deleted successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      print("Some  issue");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Error deleting data",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}
