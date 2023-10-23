// ignore_for_file: prefer_const_constructors

import 'package:aiproresume/services/writing_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/custom_buttom.dart';

class ServicesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ServicesScreenState();
  }
}

class ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header
              const Text(
                'Services',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              //body
              Expanded(child: mainBody()),
            ],
          ),
        ),
      ),
    );
  }

  mainBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            color: Colors.white,
            shadowColor: Colors.blue.shade900,
            elevation: 15,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(0))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset(
                    "images/writing.jpeg",
                    // height: 150,
                    // width: MediaQuery.of(context).size.width,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => WritingServices(),
                          ),
                        );
                      },
                      buttonText: "Professoinal Resume Writing",
                      sizeWidth: MediaQuery.of(context).size.width * 0.6),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.white,
            shadowColor: Colors.blue.shade900,
            elevation: 15,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(40))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("images/review.jpg"),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => WritingServices(),
                          ),
                        );
                      },
                      buttonText: "Professoinal Resume Review",
                      sizeWidth: MediaQuery.of(context).size.width * 0.6),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.white,
            shadowColor: Colors.blue.shade900,
            elevation: 15,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(0))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("images/writing.jpeg"),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => WritingServices(),
                          ),
                        );
                      },
                      buttonText: "Professoinal Cover Writing",
                      sizeWidth: MediaQuery.of(context).size.width * 0.6),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.white,
            shadowColor: Colors.blue.shade900,
            elevation: 15,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(40))),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset("images/review.jpg"),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => WritingServices(),
                          ),
                        );
                      },
                      buttonText: "Professoinal Cover Review",
                      sizeWidth: MediaQuery.of(context).size.width * 0.6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
