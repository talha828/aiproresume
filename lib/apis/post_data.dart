import 'dart:convert';

import 'package:aiproresume/apis/webapi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/custom_dialogue.dart';

class PostData {
  var user_id;
  var token;

  post_data(context, certCred, endpointurl) async {
    CustomProgressDialogue.progressDialogue(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString("user_id");
    token = prefs.getString("session_token");

    //'add_summary'
    var res = await CallApi().postInfoData(certCred, endpointurl, token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Adding Record please wait...",
        style: TextStyle(fontSize: 16),
      ),
    ));
    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      // _isSent = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ));
      //Navigator.of(context).pop();
    } else {
      print("Some  issue");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ));
    }
  }

  bool isDeleted = false;
  deleteData(context, endpointurl) async {
    CustomProgressDialogue.progressDialogue(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var res = await CallApi().deleteInfoData(endpointurl, token);
    var bodyOTP = jsonDecode(res.body);
    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      isDeleted = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ));
    } else {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      isDeleted = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ));
    }
  }

  updateCertificates(context, certCred, endpointurl) async {
    CustomProgressDialogue.progressDialogue(context);
    var token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");

    var res = await CallApi().updateInfoData(certCred, endpointurl, token);
    var bodyOTP = jsonDecode(res.body);
    print(bodyOTP.toString());

    if (res.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      print("Some  issue");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          bodyOTP['message'].toString(),
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}
