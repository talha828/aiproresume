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

class LayoutTwo extends StatefulWidget {
  const LayoutTwo({super.key});

  @override
  State<LayoutTwo> createState() => _LayoutTwoState();
}

class _LayoutTwoState extends State<LayoutTwo> {
  @override
  Widget build(BuildContext context) {
    return
    // SafeArea(
     // child: Scaffold(
       // body: 
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                sideOne(),
                sideTwo(),
              ],
            ),
          ),
       // ),
     // ),
    );
  }

  Widget sideOne() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.40,
      color: global.bg1color ?? Color(0xff303B41),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            if (global.showImage) Imagesection(),
            ContactSection(
              icolor: Colors.white,
              f2color: Colors.white,
            ),
            if (global.showSoftSkill)
              SkillSection(
                barcolor: Colors.white,
                h2color: Colors.white,
                f2color: Colors.white,
              ),
            if (global.showSkill)
              SoftskillSection(
                barcolor: Colors.white,
                h2color: Colors.white,
                f2color: Colors.white,
              ),
            if (global.showLanguages)
              LanguagesSection(
                barcolor: Colors.white,
                h2color: Colors.white,
                f2color: Colors.white,
              ),
            if (global.showExtarDetail)
              ExtraSection(
                h2color: Colors.white,
                f2color: Colors.white,
              ),
            if (global.showHobbies)
              HobbiesSection(
                h2color: Colors.white,
                f2color: Colors.white,
              ),
            if (global.showReference)
              ReferenceSection(
                h2color: Colors.white,
                f2color: Colors.white,
              )
          ],
        ),
      ),
    );
  }

  Widget sideTwo() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.60,
      color: global.bg2color ?? Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            NameDesignationSection(),
            if (global.showsummary)
              SummarySection(
                h1color: Colors.red,
              ),
            if (global.showEducation)
              EducationSection(
                h1color: Colors.red,
              ),
            if (global.showExperience)
              ExperienceSection(
                h1color: Colors.red,
              ),
            if (global.showAwards)
              AwardsSection(
                h1color: Colors.red,
              ),
            if (global.showCertificates)
              CertificateSection(
                h1color: Colors.red,
              ),
            if (global.showSignature)
              SignatureSection(
                h1color: Colors.red,
              )
          ],
        ),
      ),
    );
  }
}
