import 'dart:convert';

import 'package:aiproresume/apis/post_data.dart';
import 'package:aiproresume/common/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/auth.dart';
import '../../apis/fetch_data.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_dialogue.dart';
import '../../common/custom_text.dart';

import 'package:http/http.dart' as http;

import '../edit_pages/edit_language.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<Languages> createState() => LanguagesState();
}

final List<DropdownButtonFormField> _languagelevelsfield = [];
final List<DropdownButtonFormField> _languagefield = [];

String baseUrl = Auth.baseUrl;
String languagesEndpoint = Auth.getAllLanguages;
String languageslevelEndPpoint = Auth.getLangusgesLevel;

List allLanguages = [];
List languagesLevel = [];

var languagesDropdown;
var languagesLevelDropdown;

class LanguagesState extends State<Languages> {
  @override
  void initState() {
    super.initState();
    getLanguages();
    getLanguagesLevel();
    setState(() {});
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
                    text: "Languages",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Add your languages.',
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
                    postLanguage();
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
    );
  }

  static var langSelected, levelSelected;
  Widget mainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Choose Language',
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
              items: allLanguages.map((item) {
                lang = item['id'].toString();
                print("lang id: " + lang.toString());
                return DropdownMenuItem(
                    value: item['id'].toString(),
                    child: Text(
                      item['name'].toString(),
                      overflow: TextOverflow.ellipsis,
                    ));
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  languagesDropdown = newVal;
                  // aStr =
                  //     languagesDropdown.replaceAll(new RegExp(r'[^0-9]'), '');
                  print("Val" + languagesDropdown);
                });
              },
              value: languagesDropdown,
            ),
            SizedBox(
              height: 20,
            ),
            //languages level
            // final languageslevels =
            DropdownButtonFormField(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Language Level',
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
              items: languagesLevel.map((item) {
                level_id = item['id'].toString();
                return DropdownMenuItem(
                    value: item['name'].toString(),
                    child: Text(
                      item['name'].toString(),
                      overflow: TextOverflow.ellipsis,
                    ));
              }).toList(),
              onChanged: (newVal) {
                switch (newVal) {
                  case "Beginner":
                    level_id = "1";
                    break;
                  case "Intermediate":
                    level_id = "2";
                    break;
                  case "Advanced":
                    level_id = "3";
                    break;
                }
                setState(() {
                  languagesLevelDropdown = newVal;
                });
              },
              value: languagesLevelDropdown,
            ),
            // _languageListView(),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: 450,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 228, 228)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Your Languages"),
                  SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                        future: dataFetched(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: langList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: IconButton(
                                      onPressed: () {
                                        setState(() {});
                                        langSelected = langList[index]['id'];
                                        levelSelected =
                                            langList[index]['level'].toString();
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  const EditLanguages()),
                                        );
                                       // showAlertDialog(context);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Mycolors().blue,
                                      ),
                                    ),
                                    title: Text(
                                        '${langList[index]['language']}',
                                        style: TextStyle()),
                                    subtitle: Text(
                                        '${langList[index]['level']}',
                                        style: TextStyle()),
                                    onTap: () {
                                      setState(() {});
                                      // id = langList[index]['id'];
                                      // ctitle = langList[index]['name'];
                                      // print("title: " + ctitle);
                                      // cdescription =
                                      //     langList[index]['description'];
                                      // print("desc: " + cdescription);
                                      // cinstitute = langList[index]['body'];
                                      // print("inst: " + cinstitute);
                                      // date = langList[index]['date'];
                                      // print("date: " + date);
                                    },
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        print("DeleteITEM: " +
                                            langList[index]['id'].toString());
                                        deleteLanguage(
                                            langList[index]['id'], index);
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

  var aStr;
  Widget _languageListView() {
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 1,
      //itemCount: 3,
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
                    _languagefield[index],
                    const SizedBox(height: 10),
                    _languagelevelsfield[index],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
    );
  }

  // Get Lanuages from api
  var lang;
  Future getLanguages() async {
    var response = await http.get(Uri.parse(baseUrl + languagesEndpoint));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];
      //  lang = jsonData['id'].toString();
      setState(() {
        allLanguages = jsonData;
      });
      print(allLanguages);
    } else {}
  }

  var level_id;
  //get languages level from api
  Future getLanguagesLevel() async {
    var response = await http.get(Uri.parse(baseUrl + Auth.getLangusgesLevel));
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['data'];

      print("level" + level_id.toString());
      setState(() {
        languagesLevel = jsonData;
      });
      print(languagesLevel);
    } else {
      print('error');
    }
  }

  var user_id, token;
  postLanguage() async {
    var certCred = {
      'language_id': languagesDropdown,
      'level_id': level_id,
    };
    PostData().post_data(context, certCred, 'store_user_language');
  }

  deleteLanguage(int index, int listIndex) async {
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
      'language_id': languagesDropdown,
      'level_id': level_id,
    };
    var res = await CallApi().deleteInfoData(
        'delete_user_language/' + index.toString(), token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      setState(() {
        langList.removeAt(listIndex);
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

  dynamic langList = [];
  Future<List<dynamic>> dataFetched() async {
    langList = await FetchData().getCertasList("show_user_languages");
    return langList;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Update"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update Language Level"),
      content: Text("something"), //EditLanguages(),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
