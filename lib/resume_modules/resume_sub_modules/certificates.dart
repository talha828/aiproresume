// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:aiproresume/apis/post_data.dart';
import 'package:aiproresume/common/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/fetch_data.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';
import '../edit_pages/edit_certificates.dart';

class Certificates extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // ignore: todo
    // TODO: implement createState
    return CertificatesState();
  }
}

class CertificatesState extends State<Certificates> {
  final title = TextEditingController();
  final description = TextEditingController();
  final institute = TextEditingController();
  final cdate = TextEditingController();

  dynamic certList = [];
  String? skillItem;

  var user_id, token;

  static var id, ctitle, cdescription, cinstitute, date;

  Future<List<dynamic>> dataFetched() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var pid = prefs.getString("profile_id");
    certList = await FetchData().getCertasList("certificates");
    return certList;
  }

  postCertificates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");

    var certCred = {
      'title': title.text,
      'description': description.text,
      'institute': institute.text,
      'date': cdate.text,
      'user_id': user_id
    };
    PostData().post_data(context, certCred, "certificates");
  }

  deleteCertificates(int index, int listIndex) async {
    CustomProgressDialogue.progressDialogue(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Deleting ...",
        style: TextStyle(fontSize: 16),
      ),
    ));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");
    print("UserID: " + user_id.toString());
    var certCred = {
      'title': title.text,
      'description': description.text,
      'institute': institute.text,
      'date': cdate.text,
    };
    var res = await CallApi()
        .deleteInfoData( 'certificates/' + index.toString(), token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() {
        certList.removeAt(listIndex);
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
                        const SizedBox(width: 10),
                        const CustomText(
                          text: "Certificates",
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
                    SizedBox(height: 10),
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
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      margin: EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 238, 228, 228)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Your Certificates"),
                          SizedBox(height: 10),
                          Expanded(
                            child: FutureBuilder<List<dynamic>>(
                                future: dataFetched(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      itemCount: certList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          child: ListTile(
                                            leading: IconButton(
                                              onPressed: () {
                                                setState(() {});
                                                id = certList[index]['id'];
                                                ctitle =
                                                    certList[index]['title'];
                                                print("title: " + ctitle);
                                                cdescription = certList[index]
                                                    ['description'];
                                                print("desc: " + cdescription);
                                                cinstitute = certList[index]
                                                    ['institute'];
                                                print("inst: " + cinstitute);
                                                date = certList[index]['date'];
                                                print("date: " + date);
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          CertificatesEdit()),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit,
                                                color: Mycolors().blue,
                                              ),
                                            ),
                                            title: Text(
                                                '${certList[index]['title']}',
                                                style: TextStyle()),
                                            onTap: () {
                                              id = certList[index]['id'];
                                              ctitle = certList[index]['title'];
                                              print("title: " + ctitle);
                                              cdescription = certList[index]
                                                  ['description'];
                                              print("desc: " + cdescription);
                                              cinstitute =
                                                  certList[index]['institute'];
                                              print("inst: " + cinstitute);
                                              date = certList[index]['date'];
                                              print("date: " + date);
                                              // Navigator.push(
                                              //   context,
                                              //   CupertinoPageRoute(
                                              //       builder: (context) =>
                                              //           CertificatesEdit()),
                                              // );
                                            },
                                            trailing: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                print("DeleteITEM: " +
                                                    certList[index]['id']
                                                        .toString());
                                                deleteCertificates(
                                                    certList[index]['id'],
                                                    index);
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: CustomButton(
                        onTap: () {
                          postCertificates();
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
        ),
      ),
    );
  }
}
