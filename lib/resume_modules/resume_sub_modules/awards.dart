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
import '../../common/custom_text.dart';
import '../edit_pages/edit_awards.dart';

class Awards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // ignore: todo
    // TODO: implement createState
    return AwardsState();
  }
}

class AwardsState extends State<Awards> {
  final name = TextEditingController();
  final description = TextEditingController();
  final body = TextEditingController();
  final cdate = TextEditingController();

  dynamic awList = [];
  String? skillItem;

  var user_id, token;

  static var id, ctitle, cdescription, cinstitute, date;

  Future<List<dynamic>> dataFetched() async {
    awList = await FetchData().getCertasList("awards");
    return awList;
  }

  postAwards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    var certCred = {
      'name': name.text,
      'description': description.text,
      'body': body.text,
      'date': cdate.text,
      'user_id': user_id,
    };
    PostData().post_data(context, certCred, 'awards');
  }

  // var isDelete = false;
  deleteCertificates(int index, int listIndex) async {
    //isDelete = false;
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
      'name': name.text,
      'description': description.text,
      'body': body.text,
      'date': cdate.text,
    };
    var res = await CallApi()
        .deleteInfoData('awards/' + index.toString(), token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      setState(() {
        awList.removeAt(listIndex);
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                        text: "Awards",
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
                      text: 'Add Award Details',
                      textColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Add Name",
                      hintText: "Name of the Award",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // user keyboard will have a button to move cursor to next line
                    controller: name,
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
                      labelText: "Add Body",
                      hintText: "Please write Name of awarding body",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    // user keyboard will have a button to move cursor to next line
                    controller: body,
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
                      labelText: "Award Date",
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
                  SizedBox(height: 10),
                  SizedBox(height: 10),
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
                        Text("Your Awards and Honours"),
                        SizedBox(height: 10),
                        Expanded(
                          child: FutureBuilder<List<dynamic>>(
                              future: dataFetched(),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return ListView.builder(
                                    itemCount: awList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        child: ListTile(
                                          leading: IconButton(
                                            onPressed: () {
                                              setState(() {});
                                              id = awList[index]['id'];
                                              ctitle = awList[index]['name'];
                                              print("title: " + ctitle);
                                              cdescription =
                                                  awList[index]['description'];
                                              print("desc: " + cdescription);
                                              cinstitute =
                                                  awList[index]['body'];
                                              print("inst: " + cinstitute);
                                              date = awList[index]['date'];
                                              print("date: " + date);
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        EditAwards()),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Mycolors().blue,
                                            ),
                                          ),
                                          title: Text(
                                              '${awList[index]['name']}',
                                              style: TextStyle()),
                                          onTap: () {
                                            setState(() {});
                                            id = awList[index]['id'];
                                            ctitle = awList[index]['name'];
                                            print("title: " + ctitle);
                                            cdescription =
                                                awList[index]['description'];
                                            print("desc: " + cdescription);
                                            cinstitute = awList[index]['body'];
                                            print("inst: " + cinstitute);
                                            date = awList[index]['date'];
                                            print("date: " + date);
                                          },
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              print("DeleteITEM: " +
                                                  awList[index]['id']
                                                      .toString());
                                              deleteCertificates(
                                                  awList[index]['id'], index);
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
                        postAwards();
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
    );
  }
}
