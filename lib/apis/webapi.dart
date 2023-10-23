import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CallApi {
  int? index;
  CallApi([this.index]);
  final String baseURL = "http://resume.cognitiveitsolutions.ca/public/api/";

  postData(data, ApiUrl) async {
    var url = baseURL + ApiUrl;
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
  var response, name, code;
  Future<List<dynamic>> fetchCountries(apiUrl) async {
    var url = baseURL + apiUrl;
    var result = await http.get(Uri.parse(url));
    response = json.decode(result.body)['data'];
    //print("id " + response.toString());
    return json.decode(result.body)['data'];
  }

  int idC(dynamic country) {
    return country['id'];
  }

  String nameC(dynamic country) {
    return country['name'];
  }

  String codeC(dynamic country) {
    return country['code'];
  }

  String objective(dynamic index) {
    return index['objective'];
  }

  // var objective_fetch;
  // Future<List<dynamic>> fetchObjectives(apiUrl, token) async {
  //   var url = baseURL + apiUrl;
  //   print("tokenValue: " + token);
  //   var result =
  //       await http.get(Uri.parse(url), headers: _setauthHeaders(token));
  //   response = json.decode(result.body)['data'] as List;
  //   // print("Fetch Response " + response.toString());
  //   // objective_fetch = json.decode(result.body)['data'][0]['title'];
  //   // print("object " + objective_fetch);
  //   return json.decode(result.body)['data'] as List;
  // }

  Future<List<dynamic>> fetchCerts(apiUrl, token) async {
    var url = baseURL + apiUrl;
    debugPrint("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data'] as List;
    print("pdfs: " + response.toString());
    return json.decode(result.body)['data'] as List;
  }

  Future fetchSummary(apiUrl, token) async {
    var url = baseURL + apiUrl;
    print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data'];

    return json.decode(result.body)['data'];
  }

  Future<List<dynamic>> fetchCertsTemps(apiUrl, token) async {
    var url = baseURL + apiUrl;
    print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data']['templates'];

    return json.decode(result.body)['data']['templates'] as List;
  }

  Future<List<dynamic>> fetchCertsServices(apiUrl, token) async {
    var url = baseURL + apiUrl;
    print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data']['services'];

    return json.decode(result.body)['data']['services'] as List;
  }

  fetchSigns(apiUrl, token) async {
    var url = baseURL + apiUrl;
    print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));
    response = json.decode(result.body)['data'];
    //debugPrint("sign response: " + response.toString());
    return json.decode(result.body)['data'];
  }

  Future<List<dynamic>> fetchPersonalInfo(apiUrl, token) async {
    var url = baseURL + apiUrl;
    // print("tokenValue: " + token);
    var result =
        await http.get(Uri.parse(url), headers: _setauthHeaders(token));

    response = json.decode(result.body)['data'][0]['personal_information'];
    print("Fetch Response " + response.toString());

    return json.decode(result.body)['data'][0]['personal_information'];
  }

  postInfoData(data, ApiUrl, token) async {
    var url = baseURL + ApiUrl;
    return await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _setauthHeaders(token),
    );
  }

  updateInfoData(data, ApiUrl, token) async {
    var url = baseURL + ApiUrl;
    return await http.put(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: _setauthHeaders(token),
    );
  }

  deleteInfoData(ApiUrl, token) async {
    var url = baseURL + ApiUrl;
    return await http.delete(
      Uri.parse(url),
      //body: jsonEncode(data),
      headers: _setauthHeaders(token),
    );
  }

  _setauthHeaders(String? token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
}
