import 'package:aiproresume/common/app_utils.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/personal_details.dart';
import 'package:aiproresume/templates/customizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/webapi.dart';
import '../common/colors.dart';
import '../common/custom_text.dart';

class Template extends StatefulWidget {
  const Template({super.key});

  @override
  State<Template> createState() => _TemplateState();
}

// enum Filter { All, Free, Paid }

class _TemplateState extends State<Template> {
  final List<String> _options = ['All', 'Free', 'Paid'];
  int? _value = 0;
  var profile_value;
  // Filter filterview = Filter.All;
  getPrefs(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profile_value = prefs.getString("new_profile");
    switch (profile_value) {
      case "0":
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Customizer(data: certList[index]['sort']),
          ),
        );
        break;
      case "1":
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const PersonalDetails(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _mainbody(),
      ),
    );
  }

  Widget _mainbody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                text: "Templates",
                fontWeight: FontWeight.bold,
                fontSize: 25,
                textColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 10),
          //_filterbutton(),
          _fliterchip(),
          const SizedBox(height: 10),
          Expanded(
            child: _allTemplates(),
          )
        ],
      ),
    );
  }

  Widget _fliterchip() {
    return Wrap(
      spacing: 8.0,
      direction: Axis.horizontal,
      children: List<Widget>.generate(
        _options.length,
        (int index) {
          return FilterChip(
            selectedColor: Mycolors().blue,
            label: Text(
              _options[index],
            ),
            selected: _value == index,
            labelStyle:
                TextStyle(color: _value == index ? Colors.white : Colors.black),
            onSelected: (selected) {
              setState(() {
                _value = (selected ? index : null);
              });
            },
          );
        },
      ).toList(),
    );
  }

  // getcustomPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var bg1clr = prefs!.getString("bg1Color");
  //   String start = "Color(";
  //   String end = ")";
  //   final startIndex = bg1clr!.indexOf(start);
  //   final endIndex = bg1clr.indexOf(end, startIndex + start.length);
  //   bg1clr = bg1clr.substring(startIndex + start.length, endIndex);
  //   print("Final Color: " + bg1clr.toString());
  //   global.bg1color = Color(int.parse(bg1clr));
  // }

  Widget _allTemplates() {
    return FutureBuilder<List<dynamic>>(
      future: _getCert(),
      builder: (context, snapshot) {
        print(snapshot.data.toString());
        if (snapshot.hasData) {
          //  List<Alltemplate> data = snapshot.data as List<Alltemplate>;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1 / 1.52),
            itemCount: certList.length,
            itemBuilder: (context, index) {
              // print("count: " + data.length.toString());
              debugPrint("Template id: " + certList[index]['id'].toString());
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        AppUtils().storeId(
                            "template_id", certList[index]['id'].toString());
                        debugPrint(
                            "Template id: " + certList[index]['id'].toString());
                        getPrefs(index);
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            height: 241,
                            fit: BoxFit.fill,
                            'http://resume.cognitiveitsolutions.ca/public/images/${certList[index]['image']}',
                          ),
                          Positioned(
                            right: 8,
                            top: 5,
                            child: Container(
                              height: 20,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Mycolors().green),
                              child: const Center(
                                child: Text(
                                  //certList[index]['name'],
                                  "PRO",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(certList[index]['name']),
                  ],
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: CustomText(
              text: "Fail to load Templates",
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Mycolors().blue,
          ),
        );
      },
    );
  }

  var token;

  dynamic certList = [];
  final CallApi _api = CallApi();

  var profile_id;

  Future<List<dynamic>> _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    // profile_id = prefs.getInt("prof_id");
    //print("inside");
    await _api.fetchCertsTemps('templates', token);
    certList = _api.response;
    // print("CertList " + _api.response.toString());
    return certList;
  }
}
