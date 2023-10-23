// ignore_for_file: use_build_context_synchronously

import 'package:aiproresume/cover_letter_modules/cover_templates/cover_temp_1_pdf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:aiproresume/global.dart' as global;

import '../apis/auth.dart';
import '../apis/webapi.dart';
import '../common/colors.dart';
import '../common/custom_text.dart';
import 'cover_letter_builder.dart';
import 'cover_templates/cover_temp_2_pdf.dart';
import 'cover_templates/cover_temp_3_pdf.dart';

class TemplateCoverHome extends StatefulWidget {
  const TemplateCoverHome({super.key});

  @override
  State<TemplateCoverHome> createState() => TemplateCoverHomeState();
}

String baseUrl = Auth.baseUrl;
String alltemplateendpoist = Auth.alltemplateEndpoint;

// enum Filter { All, Free, Paid }

class TemplateCoverHomeState extends State<TemplateCoverHome> {
  TemplateCoverHomeState() {
   // _getCert();
  }
  final List<String> _options = ['All', 'Free', 'Paid'];
  //List img = ["images/cover_temp_20.png", "images/cover_template_01.png"];
  var product = [
    {
      "assets": "images/cover_temp_20.png",
    },
    {
      "assets": "images/cover_template_01.png",
    },
    {
      "assets": "images/cover_template_02.png",
    },
    {
      "assets": "images/cover_template_03.png",
    },
    {
      "assets": "images/cover_template_04.png",
    }
  ];
  List title = ["Temp1", "Temp2", "Temp3", "Temp4", "Temp5"];
  int? _value = 0;
  // Filter filterview = Filter.All;

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
          const Text(
            'Cover Letter Templates',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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

  setCoverTempId(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var ind = index + 1;
    prefs.setString("ctempId", ind.toString());
    var newCover = prefs.getString("new_cover");
    switch (newCover) {
      case "0":
        _getCert();
        openCoverLetterPdf(index);
        break;
      case "1":
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const CoverLetterBuilder(),
          ),
        );
        break;
    }
  }

  Widget _allTemplates() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1 / 1.52),
      itemCount: product.length,
      itemBuilder: (context, index) {
        // print("count: " + data.length.toString());

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
                  setCoverTempId(index);
                },
                child: Stack(
                  children: [
                    Image.asset(
                      height: 241,
                      fit: BoxFit.fill,
                      product[index]['assets']!,
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
                            style: TextStyle(color: Colors.white, fontSize: 11),
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
              Text(title[index]),
            ],
          ),
        );
      },
    );
  }

  var token;

  static dynamic coverTemList = [];
  final CallApi _api = CallApi();

  _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    var id = prefs.getString("get_cover_id");
    print("inside");
    await _api.fetchSummary('cover_letters/$id', token);
    coverTemList = _api.response;
    print("CertList " + _api.response.toString());
    return coverTemList;
  }

  openCoverLetterPdf(index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const CoverTemp1(),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const CoverTemp2(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const CoverTemp3(),
          ),
        );
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }
}
