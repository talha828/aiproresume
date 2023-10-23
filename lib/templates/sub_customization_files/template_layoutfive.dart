import 'package:flutter/material.dart';

import 'package:aiproresume/global.dart' as global;

import '../common_temp/award_section.dart';
import '../common_temp/certificate_section.dart';
import '../common_temp/contact_section.dart';
import '../common_temp/education_section.dart';
import '../common_temp/experience_section.dart';
import '../common_temp/extra_section.dart';
import '../common_temp/hobbies_section.dart';
import '../common_temp/image_section.dart';
import '../common_temp/language_section.dart';
import '../common_temp/namedesignation_section.dart';
import '../common_temp/reference_section.dart';
import '../common_temp/signature_section.dart';
import '../common_temp/skill_section.dart';
import '../common_temp/softskill_section.dart';
import '../common_temp/summary_section.dart';

class LayoutFive extends StatefulWidget {
  const LayoutFive({super.key});

  @override
  State<LayoutFive> createState() => _LayoutFiveState();
}

class _LayoutFiveState extends State<LayoutFive> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                header(),
                mainBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      color: global.bg1color ?? Color(0xffDAD6CD),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        //physics: NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            if (global.showImage) Imagesection(),
            NameDesignationSection(
              ndcolor: Color(0xffC7784D),
            ),
            SizedBox(
              height: 200,
              width: 180,
              child: ContactSection(
                  icolor: Color(0xff98958C), f2color: Color(0xffC7784D)),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      width: MediaQuery.of(context).size.width,
      color: global.bg1color ?? Color(0xffDAD6CD),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, bottom: 10),
              color: global.bg2color ?? Color(0xffF0EDE8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (global.showsummary)
                      SummarySection(
                          f1color: Color(0xff98958C),
                          h1color: Color(0xffC7784D)),
                    if (global.showCertificates)
                      CertificateSection(
                          f1color: Color(0xff98958C),
                          h1color: Color(0xffC7784D)),
                    if (global.showAwards)
                      AwardsSection(
                          f1color: Color(0xff98958C),
                          h1color: Color(0xffC7784D)),
                    if (global.showLanguages)
                      LanguagesSection(
                        f2color: Color(0xff98958C),
                        h2color: Color(0xffC7784D),
                        barcolor: Color(0xffC7784D),
                      ),
                    if (global.showHobbies)
                      HobbiesSection(
                        f2color: Color(0xff98958C),
                        h2color: Color(0xffC7784D),
                      ),
                    if (global.showReference)
                      ReferenceSection(
                        f2color: Color(0xff98958C),
                        h2color: Color(0xffC7784D),
                      )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: 10, bottom: 10),
              color: global.bg2color ?? Color(0xffF0EDE8),
              // child: SingleChildScrollView(
              child: Column(
                children: [
                  if (global.showEducation)
                    EducationSection(
                        f1color: Color(0xff98958C), h1color: Color(0xffC7784D)),
                  if (global.showExperience)
                    ExperienceSection(
                        f1color: Color(0xff98958C), h1color: Color(0xffC7784D)),
                  if (global.showSkill)
                    SkillSection(
                      f2color: Color(0xff98958C),
                      h2color: Color(0xffC7784D),
                      barcolor: Color(0xffC7784D),
                    ),
                  if (global.showSoftSkill)
                    SoftskillSection(
                      f2color: Color(0xff98958C),
                      h2color: Color(0xffC7784D),
                      barcolor: Color(0xffC7784D),
                    ),
                  if (global.showExtarDetail)
                    ExtraSection(
                      f2color: Color(0xff98958C),
                      h2color: Color(0xffC7784D),
                    ),
                  if (global.showSignature)
                    SignatureSection(
                      h1color: Color(0xffC7784D),
                    )
                ],
              ),
            ),
          ),
          // )
        ],
      ),
    );
  }
}
