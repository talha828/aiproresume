// ignore_for_file: prefer_const_constructors

import 'package:aiproresume/create_tab/create_tab_file.dart';
import 'package:aiproresume/create_tab/savedresumes.dart';
import 'package:aiproresume/services/services.dart';
import 'package:aiproresume/setting/setting.dart';
import 'package:flutter/material.dart';

import 'common/colors.dart';
import 'create_tab/cover_letter_create.dart';

class MyHomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MyHomePage> {
  int _selectedTab = 2;

  final List _pages = [
    ServicesScreen(),
    SavedResume(),
    CreateResumeCover(),
    CreateCover(),
    Setting(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedTab!],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,

          elevation: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedTab!,
          selectedItemColor: Mycolors().blue,
          unselectedItemColor: Colors.grey,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          iconSize: 28,
          onTap: (index) => _changeTab(index),
          items: [
            BottomNavigationBarItem(
              label: "Store",
              icon: Icon(Icons.shop),
            ),
            BottomNavigationBarItem(
              label: "Resume",
              icon: Icon(Icons.edit_document),
            ),
            BottomNavigationBarItem(
              label: "Create",
              icon: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color.fromARGB(255, 116, 225, 119)),
                height: 70,
                width: 70,
                child: Icon(
                  Icons.add,
                  size: 50,
                  color: Mycolors().blue,
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "Cover Letter",
              icon: Icon(Icons.article),
            ),
            BottomNavigationBarItem(
              label: "Setting",
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
