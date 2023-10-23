import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:open_file/open_file.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AppUtils {
  static String getFileExtension(String filePath) {
    try {
      int index = filePath.lastIndexOf('.');
      return filePath.substring(index + 1);
    } catch (e) {
      return '';
    }
  }

  String getDate() {
    String cdate2 = DateFormat("MMMM, dd, yyyy").format(DateTime.now());
    return cdate2;
    //print(cdate2);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString("user_name");
    return userName;
  }

  storeId(key, index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, index.toString());
  }

  storeBool(key, index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, index);
  }

  storeLocationIds(key1, key2, key3, cid, sid, citid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key1, cid);
    prefs.setInt(key2, sid);
    prefs.setInt(key3, citid);
  }

  

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName, context) async {
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/$fileName');
    print("path: " + file.path.toString());
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open('$path/$fileName');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var template_id = prefs.getString("template_id");
    var profile_id = prefs.getString("profile_id");
    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    };
    var fileExtension = AppUtils.getFileExtension(file.path.toString());
    if (fileExtension.isEmpty) {
      print("Not found");
      return;
    }

    Map<String, String> infoData = {
      'profile_id': profile_id.toString(),
    };

    var url =
        Uri.parse("http://resume.cognitiveitsolutions.ca/public/api/user_cv");
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);
    request.fields.addAll(infoData);
    final filePdf = await http.MultipartFile.fromPath('cv_file', file.path,
        contentType: MediaType('application', fileExtension));
    request.files.add(filePdf);
    var response = await request.send();
    if (response.statusCode == 200) {
      debugPrint("Pdf Successfully Uploaded");
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Uploaded Successfully",
          style: TextStyle(fontSize: 16),
        ),
      ));
    } else {
      debugPrint("Code: " + response.statusCode.toString());
      Navigator.of(context, rootNavigator: true).pop('dialog');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Error Uploading your file",
          style: TextStyle(fontSize: 16),
        ),
      ));
    }
  }
}
