// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'dart:async';

import 'package:aiproresume/home_page.dart';
import 'package:aiproresume/register_modules/login_page.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Splash();
  }
}

class Splash extends State<SplashScreen> {
  bool _isVisible = false;
  bool? sess;
  String? token;

  _session() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.setBool("session", null);
    //prefs.setString("session_token", "firsttime");
    //sess = prefs.getBool("session")!;
    //print("Session Bool: " + sess.toString());
    token = prefs.getString("session_token");
    print("Sess token: " + token.toString());
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (route) => false);
    } else {
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (context) => MyApp(token),
      //     ),
      //     (route) => false);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
          (route) => false);
    }
    // if (sess!) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //         builder: (context) => MyApp(token),
    //       ),
    //       (route) => false);
    // } else {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(
    //         builder: (context) => LoginPage(),
    //       ),
    //       (route) => false);
    // }
  }

  Splash() {
    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _session();
      });
    });

    Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: Duration(microseconds: 1200),
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            child: Center(
              child: ClipOval(
                child: Icon(
                  Icons.android_outlined,
                  size: 128,
                ), //app logo here
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 2.0,
                  offset: Offset(5.0, 3.0),
                  spreadRadius: 3.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
