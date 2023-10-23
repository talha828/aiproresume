import 'dart:convert';

import 'package:aiproresume/apis/post_data.dart';
import 'package:aiproresume/common/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../apis/auth.dart';
import '../../apis/fetch_data.dart';
import '../../apis/webapi.dart';
import '../../common/custom_buttom.dart';
import '../../common/custom_text.dart';
import '../edit_pages/edit_reference.dart';

class References extends StatefulWidget {
  const References({super.key});

  @override
  State<References> createState() => ReferencesState();
}

class ReferencesState extends State<References> {
  String baseUrl = Auth.baseUrl;
  String designationEndpoint = Auth.getDesignation;

  List allDesignation = [];
  var designationDropdown;

  final List<TextField> _namefield = [];
  final List<TextField> _emailfield = [];
  final List<IntlPhoneField> _numberfield = [];
  final List<TextField> _companyfield = [];
  final List<DropdownButtonFormField> _designationfield = [];

  @override
  void initState() {
    super.initState();
    getDesignation();
    setState(() {});
  }

  static var fid, fname, femail, fcontact, fcompany, fdesignation;
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
                    postReferences();
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
              controller: number,
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
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 238, 228, 228)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Your References"),
                  SizedBox(height: 10),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                        future: dataFetched(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: referList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    leading: IconButton(
                                      onPressed: () {
                                        setState(() {});
                                        fid = referList[index]['id'];
                                        fname = referList[index]['name'];
                                        femail = referList[index]['email'];
                                        fcompany = referList[index]['company'];
                                        fdesignation =
                                            referList[index]['designation'];
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  const EditReferences()),
                                        );
                                        // showAlertDialog(context);
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Mycolors().blue,
                                      ),
                                    ),
                                    title: Text('${referList[index]['name']}',
                                        style: TextStyle()),
                                    subtitle: Text(
                                        '${referList[index]['company']}',
                                        style: TextStyle()),
                                    onTap: () {
                                      setState(() {});
                                      // id = referList[index]['id'];
                                      // ctitle = referList[index]['name'];
                                      // print("title: " + ctitle);
                                      // cdescription =
                                      //     referList[index]['description'];
                                      // print("desc: " + cdescription);
                                      // cinstitute = referList[index]['body'];
                                      // print("inst: " + cinstitute);
                                      // date = referList[index]['date'];
                                      // print("date: " + date);
                                    },
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        deleteCertificates(
                                            referList[index]['id'], index);
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

  Widget _referenceListView() {
    return ListView.separated(
      physics: const RangeMaintainingScrollPhysics(),
      shrinkWrap: true,
      itemCount: _namefield.length,
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
                    _namefield[index],
                    const SizedBox(height: 8),
                    _emailfield[index],
                    const SizedBox(height: 8),
                    _numberfield[index],
                    const SizedBox(height: 8),
                    _companyfield[index],
                    const SizedBox(height: 8),
                    _designationfield[index],
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _namefield.removeAt(index);
                    _emailfield.removeAt(index);
                    _numberfield.removeAt(index);
                    _companyfield.removeAt(index);
                    _designationfield.removeAt(index);
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

  dynamic referList = [];

  Future<List<dynamic>> dataFetched() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pid = prefs.getString("profile_id");
    print("pid in ref: " + pid.toString());
    referList = await FetchData().getCertasList("user_references/$pid");
    print("refList: " + referList.toString());
    return referList;
  }

  var user_id;
  postReferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    var pid = prefs.getString("profile_id");

    var certCred = {
      'name': name.text,
      'email': email.text,
      'contact_no': number.text,
      'company': company.text,
      'designation_id': designationDropdown.toString(),
      'profile_id': pid.toString(),
    };
    PostData().post_data(context, certCred, 'add_reference');
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
    user_id = prefs.getString("user_id");
    var token = prefs.getString("session_token");
    print("UserID: " + user_id.toString());
    var certCred = {
      'name': name.text,
      'email': email.text,
      'company': company.text,
      'designation_id': designationDropdown.toString(),
    };
    var res = await CallApi()
        .deleteInfoData('delete_reference/' + index.toString(), token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      setState(() {
        referList.removeAt(listIndex);
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
}
