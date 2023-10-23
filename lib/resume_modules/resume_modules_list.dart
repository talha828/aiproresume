import 'package:aiproresume/apis/webapi.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/awards.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/certificates.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/customsection.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/digital_signature.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/education.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/experience.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/languages.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/personal_details.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/reference.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/soft_skills.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/summary.dart';
import 'package:aiproresume/resume_modules/resume_sub_modules/techinal_skills.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apis/fetch_data.dart';
import '../common/custom_profilecard.dart';
import '../common/custom_text.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileTabState();
  }
}

class ProfileTabState extends State<ProfileTab> {
  ProfileTabState() {
    _getSumEdit();
    getPrefs();
  }
  dynamic dynList = [];
  dataFetched(endpointurl) async {
    dynList = await FetchData().getCertasList(endpointurl);
    return dynList;
  }

  var isEditProfile, profileId;
  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isEditProfile = prefs.getString("edit_Profile");
    profileId = prefs.getString("profile_id");
  }

  CallApi _api = CallApi();
  dynamic sumEditList = [];
  _getSumEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("session_token");
    var profile_id = prefs.getString("profile_id");

    await _api.fetchSummary('show_summaries/$profile_id', token);
    sumEditList = _api.response;
    // summm = sumList['description'].toString();
    debugPrint("summarySectionLsttt: " + sumEditList['title'].toString());
    return sumEditList;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    text: "Profile",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              Expanded(child: mainBody(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // //Summary
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SummaryObjective(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.sort,
                title: 'Summary',
                dec: 'Update your summary',
              ),
            ),

            // //experience
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Experience1(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.work_outline_rounded,
                title: 'Work experience',
                dec:
                    'Update your past work experience, responsibilites, achievements',
              ),
            ),

            // //education
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Education(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.school_outlined,
                title: 'Education',
                dec: 'Update your colleges, universities or training program',
              ),
            ),

            // //texhnical skill
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const TechnicalSkill(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.settings_outlined,
                title: 'Technical Skills',
                dec: 'Update your technical skills',
              ),
            ),

            // //softskill
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const SoftSkills(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.settings_outlined,
                title: 'Soft Skills',
                dec: 'Update your soft skills ',
              ),
            ),

            // //certificates
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Certificates(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.article_outlined,
                title: 'Certificates',
                dec: 'Update your skills ',
              ),
            ),

            // //awards
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Awards(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.emoji_events_outlined,
                title: 'Awards',
                dec: 'Update your awards ',
              ),
            ),

            // //languages
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const Languages(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.translate_outlined,
                title: 'Languages',
                dec: 'Add/Update your languages ',
              ),
            ),

            // //refrence
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const References(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.person_search_outlined,
                title: 'Reference',
                dec: 'Add/Update your reference ',
              ),
            ),

            // //digital signature
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const DigitalSignature(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.draw_outlined,
                title: 'Digital Signature',
                dec: 'Add or Update your digital signature ',
              ),
            ),

            // //custom section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const CustomSection(),
                  ),
                );
              },
              child: CustomProfilecard(
                icon: Icons.dashboard_customize_outlined,
                title: 'Custom Section',
                dec: 'Add custom section',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
