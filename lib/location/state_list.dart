// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unused_label, dead_code

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../apis/webapi.dart';

class StateList extends StatefulWidget {
  String url;
  TextEditingController controller;
  StateList({
    required this.url,
    required this.controller,
  });

  var s_id, s_name;
  var city_id, city_name;

  @override
  State<StateList> createState() => StateListState();
}

class StateListState extends State<StateList> {
  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  static var state_id, state_name;
  static var state_id_normal;
  dynamic _allUsers = [];

  // This list holds the data for the list view
  dynamic _foundUsers = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = _allUsers;
    // print("Found or not: " + _foundUsers.toString());
    super.initState();
  }

  SharedPreferences? prefs;
  getStateId(index) async {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString("stateID", _foundUsers[index]["id"].toString());
    state_id = prefs!.getString("stateID");
    print("State ki ID" + state_id);
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    dynamic results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase())
                  ? true
                  : false)
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      _foundUsers = results;
    });
    // Refresh the UI
  }

  CallApi _api = CallApi();
  final searchC = TextEditingController();

  getState() {
    widget.controller.text = state_name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 500,
      width: 300,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: searchC,
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _api.fetchCountries(widget.url),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  //print(_api.nameC(snapshot.data[0]));
                  _allUsers = _api.response;
                  if (searchC.text.isEmpty) {
                    _foundUsers = _allUsers;
                  }

                  // print("Found or not: " + _foundUsers.toString());
                  return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      // int id = snapshot.data[index];
                      // print("IDD:  " + id.toString());
                      // print("data length" + snapshot.data.length.toString());
                      // print("Index: " + index.toString());
                      // print("Fouund: " + _foundUsers.length.toString());

                      return index < _foundUsers.length
                          ? Card(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    onTap: () {
                                      widget.s_id =
                                          _foundUsers[index]["id"].toString();
                                      widget.s_name =
                                          _foundUsers[index]["name"];
                                      state_name = _foundUsers[index]["name"];

                                      setState(() {
                                        state_id_normal =
                                            _foundUsers[index]["id"].toString();
                                        getState();
                                        getStateId(index);
                                      });

                                      Navigator.of(context).pop();
                                    },
                                    leading: Text(_foundUsers[index]["id"]
                                                .toString()
                                                .isNotEmpty &&
                                            _foundUsers.length > index
                                        ? _foundUsers[index]["id"].toString()
                                        : "N/A"),
                                    title: Text(_foundUsers[index]["name"]
                                                .toString()
                                                .isNotEmpty &&
                                            _foundUsers.length > index
                                        ? _foundUsers[index]["name"]
                                        : "N/A"),
                                  )
                                ],
                              ),
                            )
                          : Text(" ");
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
