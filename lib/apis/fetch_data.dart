import 'package:aiproresume/apis/webapi.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchData {
  CallApi _api = CallApi();
  var token;
  dynamic myList = [];

// //fetch simple data
//   Future<List<dynamic>> getObjectives(endpointurl) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     token = prefs.getString("session_token");
//     await _api.fetchObjectives(endpointurl, token);
//     //print("Data fetched: ${_api.response}");
//     myList = await _api.response;
//     // print("Data fetched: $myList");
//     return myList;
//   }

  

  dynamic certList = [];
 

  Future<List<dynamic>> getCertasList(endpointurl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("session_token");
    await _api.fetchCerts(endpointurl, token);
    certList = _api.response;
   debugPrint("Fetched Data: $certList");
    return certList;
  }

  
}
