import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

import '../common/custom_settingtile.dart';
import '../common/custom_text.dart';

import '../register_modules/login_page.dart';
import 'sub_section/contact/contact.dart';
import 'sub_section/go_premium/upgrade_plan.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

final Uri _url = Uri.parse('https://flutter.dev');

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Setting',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(child: mainBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Settings
          CustomText(
            text: 'Settings',
            fontSize: 15,
            textColor: Colors.grey[600],
          ),
          const SizedBox(height: 25),

          

          // upgrade plan
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const UpgradePlan(),
                ),
              );
            },
            child: CustomSettingTile(
              icon: Icons.star_outline,
              title: 'Go Premium',
            ),
          ),
          const Divider(
            thickness: 1.5,
          ),
          const SizedBox(height: 20),

          //Terms & Conditon
          CustomText(
            text: 'Term & Privacy',
            fontSize: 15,
            textColor: Colors.grey[600],
          ),
          const SizedBox(height: 25),

          //term of use
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => const Profile(),
              //   ),
              // );
            },
            child: CustomSettingTile(
              icon: Icons.description_outlined,
              title: 'Terms of Use',
            ),
          ),

          //Terms of privacy
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => const Profile(),
              //   ),
              // );
            },
            child: CustomSettingTile(
              icon: Icons.description_outlined,
              title: 'Terms of Privacy',
            ),
          ),
          const Divider(
            thickness: 1.5,
          ),
          const SizedBox(height: 20),

          //contact
          CustomText(
            text: 'Contact Us',
            fontSize: 15,
            textColor: Colors.grey[600],
          ),
          const SizedBox(height: 25),

          //contact us
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const Contact(),
                ),
              );
            },
            child: CustomSettingTile(
              icon: Icons.alternate_email_rounded,
              title: 'Contact Us',
            ),
          ),

          //rate app
          CustomSettingTile(
            icon: Icons.star_outline,
            title: 'Rate Our App',
          ),

          //our website
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(_url)) {
                throw Exception('Could not launch $_url');
              }
            },
            child: CustomSettingTile(
              icon: Icons.language_outlined,
              title: 'Our Website',
            ),
          ),

          const Divider(
            thickness: 1.5,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              _signOutApi();
            },
            child: CustomSettingTile(
              icon: Icons.logout_outlined,
              title: 'Logout',
            ),
          ),
          //app version
          Center(
            child: CustomText(
              text: 'Version 1.0.0',
              textColor: Colors.grey[700],
            ),
          )
        ],
      ),
    );
  }

  _signOutApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    print("Token inside signout: " + token.toString());
    await http
        .post(
      Uri.parse("http://resume.cognitiveitsolutions.ca/public/api/destroy"),
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      encoding: Encoding.getByName("utf-8"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        print(json.decode(response.body));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
    prefs.remove("session_token");
  }
}
