import 'package:flutter/material.dart';

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
import 'package:aiproresume/global.dart' as global;

class LayoutOne extends StatefulWidget {
  const LayoutOne({super.key});

  @override
  State<LayoutOne> createState() => _LayoutOneState();
}

class _LayoutOneState extends State<LayoutOne> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                StatefulBuilder(builder: (context, setState) {
                  
                  return sideOne();
                }),
                StatefulBuilder(builder: (context, setState) {
                  return sideTwo();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sideOne() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.60,
      color: global.bg1color ?? Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                if (global.showImage) Imagesection(),
                Expanded(child: NameDesignationSection()),
              ],
            ),
            if (global.showsummary)
              SummarySection(
                f1color: Colors.black,
                h1color: Colors.black,
              ),
            if (global.showExperience)
              ExperienceSection(
                f1color: Colors.black,
                h1color: Colors.black,
              ),
            if (global.showEducation)
              EducationSection(
                f1color: Colors.black,
                h1color: Colors.black,
              ),
            if (global.showAwards)
              AwardsSection(
                f1color: Colors.black,
                h1color: Colors.black,
              ),
            if (global.showCertificates)
              CertificateSection(
                f1color: Colors.black,
                h1color: Colors.black,
              ),
            SizedBox(height: 15),
            if (global.showSignature)
              SignatureSection(
                h1color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }

  Widget sideTwo() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.40,
      color: global.bg2color ?? Colors.white,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const ContactSection(
              icolor: Color(0xff007296),
            ),
            if (global.showSkill)
              SkillSection(
                barcolor: Colors.black,
                h2color: Colors.black,
                f2color: Colors.black,
              ),
            if (global.showSoftSkill)
              SoftskillSection(
                barcolor: Colors.black,
                h2color: Colors.black,
                f2color: Colors.black,
              ),
            if (global.showLanguages)
              LanguagesSection(
                barcolor: Colors.black,
                h2color: Colors.black,
                f2color: Colors.black,
              ),
            if (global.showHobbies)
              HobbiesSection(
                h2color: Colors.black,
                f2color: Colors.black,
              ),
            if (global.showExtarDetail)
              ExtraSection(
                h2color: Colors.black,
                f2color: Colors.black,
              ),
            if (global.showReference)
              ReferenceSection(
                h2color: Colors.black,
                f2color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}
