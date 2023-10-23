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

class LayoutFour extends StatefulWidget {
  const LayoutFour({super.key});

  @override
  State<LayoutFour> createState() => LlayoutFourState();
}

class LlayoutFourState extends State<LayoutFour> {
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
      height: MediaQuery.of(context).size.height * 0.25,
      color: global.bg1color ?? Color(0xff450B51),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // physics: NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            if (global.showImage) Imagesection(),
            NameDesignationSection(
              ndcolor: Colors.white,
            ),
            VerticalDivider(
              color: Colors.white,
            ),
            const SizedBox(
              height: 200,
              width: 180,
              child: ContactSection(
                icolor: Colors.white,
                f2color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainBody() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      width: MediaQuery.of(context).size.width,
      color: global.bg2color ?? Colors.white,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            //summary
            if (global.showsummary) SummarySection(h1color: Color(0xff450B51)),

            //exp & edu
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      if (global.showExperience)
                        ExperienceSection(
                          h1color: Color(0xff450B51),
                        )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Color(0xff450B51),
                ),
                Flexible(
                  child: Column(
                    children: [
                      if (global.showEducation)
                        EducationSection(
                          h1color: Color(0xff450B51),
                        )
                    ],
                  ),
                )
              ],
            ),

//award and certificates
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      if (global.showCertificates)
                        CertificateSection(
                          h1color: Color(0xff450B51),
                        )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Color(0xff450B51),
                ),
                Flexible(
                  child: Column(
                    children: [
                      if (global.showAwards)
                        AwardsSection(
                          h1color: Color(0xff450B51),
                        )
                    ],
                  ),
                )
              ],
            ),

            // //award
            // if (global.showAwards) AwardsSection(h1color: Color(0xff450B51)),

            // //certificate
            // if (global.showCertificates)
            //   CertificateSection(h1color: Color(0xff450B51)),

            //skill & hobbie
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      if (global.showSkill)
                        SkillSection(
                          h2color: Color(0xff450B51),
                        )
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: Color(0xff450B51),
                ),
                Flexible(
                  child: Column(
                    children: [
                      if (global.showSoftSkill)
                        SoftskillSection(
                          h2color: Color(0xff450B51),
                        )
                    ],
                  ),
                )
              ],
            ),

            //reference & language
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      if (global.showLanguages)
                        LanguagesSection(
                          h2color: Color(0xff450B51),
                        )
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: Color(0xff450B51),
                ),
                Flexible(
                  child: Column(
                    children: [
                      if (global.showReference)
                        ReferenceSection(
                          h2color: Color(0xff450B51),
                        )
                    ],
                  ),
                )
              ],
            ),

            //extra detail
            if (global.showExtarDetail) ExtraSection(h2color: Color(0xff450B51))
          ],
        ),
      ),
    );
  }
}
