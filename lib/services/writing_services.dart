import 'package:aiproresume/setting/sub_section/payment/payment_option.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../apis/webapi.dart';
import '../common/custom_buttom.dart';

class WritingServices extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WritingServicesState();
  }
}

class WritingServicesState extends State<WritingServices> {
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
    ));
  }

  mainBody() {
    return FutureBuilder(
        future: _getCert(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     mainAxisSpacing: 8,
              //     crossAxisSpacing: 6,
              //     childAspectRatio:
              //         MediaQuery.of(context).size.aspectRatio * 1),
              itemCount: serviceList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white,
                  shadowColor: Colors.blue.shade900,
                  elevation: 15,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(40),
                          bottomRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.network(
                            fit: BoxFit.contain,
                            height: 150,
                            width: 150,
                            'http://resume.cognitiveitsolutions.ca/public/images/${serviceList[index]['image']}',
                          ),
                        ),
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              serviceList[index]["name"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Price: " + serviceList[index]['price'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) =>
                                          const PaymentOption(),
                                    ),
                                  );
                                },
                                buttonText: "Buy me",
                                sizeWidth: MediaQuery.of(context).size.width),
                          ],
                        )),

                        // Text(serviceList[index]["description"]),
                        // SizedBox(
                        //   height: 5,
                        // ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  dynamic serviceList = [];
  final CallApi _api = CallApi();

  var profile_id;

  Future<List<dynamic>> _getCert() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    // profile_id = prefs.getInt("prof_id");
    print("inside");
    await _api.fetchCertsServices('web-services', token);
    serviceList = _api.response;
    print("serviceList " + _api.response.toString());
    return serviceList;
  }
}
