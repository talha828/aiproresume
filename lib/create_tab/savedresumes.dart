import 'package:aiproresume/common/app_utils.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/personal_details.dart';
import 'package:aiproresume/templates/customizer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../apis/webapi.dart';
import '../common/colors.dart';
import '../common/custom_text.dart';

class SavedResume extends StatefulWidget {
  const SavedResume({super.key});

  @override
  State<SavedResume> createState() => _SavedResumeState();
}

// enum Filter { All, Free, Paid }

class _SavedResumeState extends State<SavedResume> {
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
          const CustomText(
            text: "Saved Resume",
            fontWeight: FontWeight.bold,
            fontSize: 25,
            textColor: Colors.black,
          ),
          const SizedBox(height: 10),
          //_filterbutton(),
          //_fliterchip(),
          const SizedBox(height: 10),
          Expanded(
            child: _allTemplates(),
          )
        ],
      ),
    );
  }

  // Widget _fliterchip() {
  //   return Wrap(
  //     spacing: 8.0,
  //     direction: Axis.horizontal,
  //     children: List<Widget>.generate(
  //       _options.length,
  //       (int index) {
  //         return FilterChip(
  //           selectedColor: Mycolors().blue,
  //           label: Text(
  //             _options[index],
  //           ),
  //           selected: _value == index,
  //           labelStyle:
  //               TextStyle(color: _value == index ? Colors.white : Colors.black),
  //           onSelected: (selected) {
  //             setState(() {
  //               _value = (selected ? index : null);
  //             });
  //           },
  //         );
  //       },
  //     ).toList(),
  //   );
  // }

  Widget _allTemplates() {
    return FutureBuilder(
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
            itemCount: 1,
            itemBuilder: (context, index) {
              // print("count: " + data.length.toString());
              //   debugPrint("Template id: " + certList[index]['id'].toString());
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Image.network(
                            height: 241,
                            fit: BoxFit.fill,
                            'https://cdn3d.iconscout.com/3d/premium/thumb/pdf-file-5544159-4626714.png',
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
                    Text(certList['cv_file'].toString()),
                  ],
                ),
              );
            },
          );
        }
        if (snapshot.hasError) {
          debugPrint("Error: " + snapshot.error.toString());
          return const Center(
            child: CustomText(
              text: "Fail to load CVs",
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

  _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    // profile_id = prefs.getInt("prof_id");
    //print("inside");
    await _api.fetchSummary('user_cv/1', token);
    certList = _api.response;
    print("CertList " + _api.response.toString());
    return certList;
  }
}
