import 'package:aiproresume/templates/common_temp/signature_section.dart';
import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:aiproresume/global.dart' as global;

import '../common_temp/award_section.dart';
import '../common_temp/certificate_section.dart';
import '../common_temp/contact_section.dart';
import '../common_temp/education_section.dart';
import '../common_temp/experience_section.dart';
import '../common_temp/extra_section.dart';
import '../common_temp/image_section.dart';
import '../common_temp/language_section.dart';
import '../common_temp/namedesignation_section.dart';
import '../common_temp/reference_section.dart';
import '../common_temp/skill_section.dart';
import '../common_temp/softskill_section.dart';
import '../common_temp/summary_section.dart';

class CommonPdfSections {
  CommonPdfSections() {
    
  }
 

  //Profile Image widget
  pw.Widget profileWidget(imageLogo) {
    pw.Widget image;
    if (global.imageShape == global.ImageShape.circle) {
      image = pw.ClipOval(
        child: pw.Container(
          color: PdfColors.amber,
          height: 150,
          width: 100,
          child: imageLogo != null
              ? pw.Image(imageLogo)
              : pw.Container(color: PdfColors.grey),
        ),
      );
    } else {
      image = pw.ClipRRect(
        child: pw.Container(
          color: PdfColors.amber,
          height: 100,
          width: 100,
          child: imageLogo != null
              ? pw.Image(imageLogo)
              : pw.Container(color: PdfColors.grey),
        ),
      );
    }
    return pw.Padding(padding: const pw.EdgeInsets.all(10), child: image);
  }

  //Name Designation
  pw.Widget nameDesignation() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          NameDesignationSectionState.nameNM.toString().toUpperCase(),
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(global.heading1color?.value ?? 0xff010103),
          ),
        ),

        //designation
        pw.Text(
          NameDesignationSectionState.jobTitleNM.toString(),
          style: pw.TextStyle(
            fontSize: 25,
            color: PdfColor.fromInt(global.heading1color?.value ?? 0xff010103),
          ),
        ),
      ],
    );
  }

  //Summary
  pw.Widget summary() {
    return pw.Text(
      SummarySectionState.sumList['description'],
      overflow: pw.TextOverflow.clip,
      maxLines: 5,
      style: pw.TextStyle(
        fontSize: global.fontSize,
        color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
      ),
    );
  }

  //Experience
  pw.Widget experience() {
    return pw.ListView(
        children: List.generate(
      ExperienceSectionState.expList.length,
      (index) =>
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        //Experience
        pw.Text(
          ExperienceSectionState.expList[index]['job_position'].toUpperCase(),
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: global.fontSize,
            color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
          ),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              ExperienceSectionState.expList[index]['company_name'],
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font1color?.value ?? 0xff717173),
              ),
            ),
            pw.Text(
              ExperienceSectionState.expList[index]['start_date'] +
                  " - " +
                  ExperienceSectionState.expList[index]['end_date'],
              style: pw.TextStyle(
                  fontSize: global.fontSize,
                  color:
                      PdfColor.fromInt(global.font1color?.value ?? 0xff717173)),
            )
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          ExperienceSectionState.expList[index]['company_description'] +
              "\n" +
              ExperienceSectionState.expList[index]['job_description'],
          maxLines: 4,
          style: pw.TextStyle(
              fontSize: global.fontSize,
              color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103)),
        ),
        pw.SizedBox(height: 5),
      ]),
    ));
  }

  //Education
  pw.Widget education() {
    return pw.ListView(
        children: List.generate(
            EducationSectionState.eduList.length,
            (index) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        EducationSectionState.eduList[0]['institution']
                            .toUpperCase(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: global.fontSize,
                          color: PdfColor.fromInt(
                              global.font1color?.value ?? 0xff010103),
                        ),
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            EducationSectionState.eduList[0]['field'],
                            style: pw.TextStyle(
                              fontSize: global.fontSize,
                              color: PdfColor.fromInt(
                                  global.font1color?.value ?? 0xff717173),
                            ),
                          ),
                          pw.Text(
                            EducationSectionState.eduList[0]['start_date'] +
                                " - " +
                                EducationSectionState.eduList[0]['end_date'],
                            style: pw.TextStyle(
                                fontSize: global.fontSize,
                                color: PdfColor.fromInt(
                                    global.font1color?.value ?? 0xff717173)),
                          )
                        ],
                      ),
                      pw.Text(
                        EducationSectionState.degreeName ?? "None",
                        style: pw.TextStyle(
                          fontSize: global.fontSize,
                          color: PdfColor.fromInt(
                              global.font1color?.value ?? 0xff010103),
                        ),
                      ),
                      pw.SizedBox(height: 5),
                    ])));
  }

  //Award
  pw.Widget award() {
    return pw.ListView(
        children: List.generate(
      AwardsSectionState.awardList.length,
      (index) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          //award
          pw.Text(
            AwardsSectionState.awardList[index]['name'].toUpperCase(),
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: global.fontSize,
              color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
            ),
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                AwardsSectionState.awardList[index]['body'],
                style: pw.TextStyle(
                  fontSize: global.fontSize,
                  color:
                      PdfColor.fromInt(global.font1color?.value ?? 0xff717173),
                ),
              ),
              pw.Text(
                AwardsSectionState.awardList[index]['date'],
                style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff717173)),
              )
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            AwardsSectionState.awardList[index]['description'],
            maxLines: 4,
            style: pw.TextStyle(
                fontSize: global.fontSize,
                color:
                    PdfColor.fromInt(global.font1color?.value ?? 0xff010103)),
          ),
          pw.SizedBox(height: 5),
        ],
      ),
    ));
  }

  //certificate
  pw.Widget certificate() {
    return pw.ListView(
      children: List.generate(
        CertificateSectionState.certificateList.length,
        (index) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            //certificate
            pw.Text(
              CertificateSectionState.certificateList[index]['title']
                  .toUpperCase(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
              ),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  CertificateSectionState.certificateList[index]['institute'],
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff717173),
                  ),
                ),
                pw.Text(
                  CertificateSectionState.certificateList[index]['date'],
                  style: pw.TextStyle(
                      fontSize: global.fontSize,
                      color: PdfColor.fromInt(
                          global.font1color?.value ?? 0xff717173)),
                ),
              ],
            ),
            pw.Text(
              CertificateSectionState.certificateList[index]['description'],
              maxLines: 4,
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
              ),
            ),
            pw.SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  //contact
  pw.Widget contact() {
    ContactSectionState css = ContactSectionState();
    return pw.Column(
      children: [
        //Address
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe0c8),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xff017197),
              size: 18,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              ContactSectionState.cityNameCS != null &&
                      ContactSectionState.countryNameCS != null
                  ? ContactSectionState.cityNameCS +
                      " , " +
                      ContactSectionState.countryNameCS
                  : "--- , ---",
              style: pw.TextStyle(
                color: PdfColor.fromInt(global.font1color?.value ?? 0x000000),
                fontSize: global.fontSize,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 5),

        //Number
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe32c),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xff017197),
              size: 18,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              ContactSectionState.contactCS.toString(),
              style: pw.TextStyle(
                color: PdfColor.fromInt(global.font1color?.value ?? 0x000000),
                fontSize: global.fontSize,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 5),

        //Email
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe158),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xff017197),
              size: 18,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              ContactSectionState.emailCS.toString(),
              style: pw.TextStyle(
                color: PdfColor.fromInt(global.font2color?.value ?? 0x000000),
                fontSize: global.fontSize,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 5),
      ],
    );
  }

  //soft Skill
  pw.Widget softskill() {
    return pw.ListView(
      children: List.generate(
        SoftskillSectionState.sslList.length,
        (index) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              SoftskillSectionState.sslList[index]['body'] + "\n",
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font2color?.value ?? 0x000000),
              ),
            ),
            pw.LinearProgressIndicator(
                value: 0.60,
                valueColor: PdfColors.lightBlue300,
                minHeight: 6,
                backgroundColor: PdfColors.white),
            pw.SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  //Skill
  pw.Widget skill() {
    return pw.ListView(
      children: List.generate(
        SkillSectionState.techskillsList.length,
        (index) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              SkillSectionState.techskillsList[index]['body'] + "\n",
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font2color?.value ?? 0x000000),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.LinearProgressIndicator(
                value: 0.60,
                valueColor: PdfColors.lightBlue300,
                minHeight: 6,
                backgroundColor: PdfColors.white),
            pw.SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  //Languages
  pw.Widget language() {
    return pw.ListView(
      children: List.generate(
        LanguagesSectionState.languageList.length,
        (index) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            //language
            pw.Text(
              LanguagesSectionState.languageList[index]['language'],
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font2color?.value ?? 0x000000),
              ),
            ),
            pw.LinearProgressIndicator(
                value: 0.60,
                valueColor: PdfColors.lightBlue300,
                minHeight: 6,
                backgroundColor: PdfColors.white),
            pw.SizedBox(height: 5),
            //
          ],
        ),
      ),
    );
  }

  //references
  pw.Widget references() {
    return pw.ListView(
      children: List.generate(
        ReferenceSectionState.referenceList.length,
        (index) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            //references

            pw.Text(
              ReferenceSectionState.referenceList[index]['name'].toUpperCase(),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
              ),
            ),

            pw.Text(
              ReferenceSectionState.referenceList[index]['designation'],
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font1color?.value ?? 0xff717173),
              ),
            ),
            pw.Text(
              ReferenceSectionState.referenceList[index]['company'],
              style: pw.TextStyle(
                  fontSize: global.fontSize,
                  color:
                      PdfColor.fromInt(global.font1color?.value ?? 0xff717173)),
            ),
            pw.Text(
              ReferenceSectionState.referenceList[index]['email'],
              maxLines: 4,
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
              ),
            ),
            pw.Text(
              ReferenceSectionState.referenceList[index]['contact_no']
                  .toString(),
              maxLines: 4,
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
              ),
            ),

            pw.SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  //Signature
  pw.Widget signature(signLogo) {
    return pw.Container(child:
    signLogo != null ? pw.Image(signLogo) : pw.Text("some issue"),);
  }

  //Extra details
  pw.Widget extradetail() {
    return pw.ListView(
      children: List.generate(
        ExtraSectionState.extraList.length,
        (index) => pw.Column(
          children: [
//details
            pw.Text(
              ExtraSectionState.extraList[index]['title'],
              style: pw.TextStyle(
                  fontSize: global.fontSize,
                  color:
                      PdfColor.fromInt(global.font2color?.value ?? 0xff010103),
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              ExtraSectionState.extraList[index]['detail'],
              maxLines: 4,
              style: pw.TextStyle(
                fontSize: global.fontSize,
                color: PdfColor.fromInt(global.font2color?.value ?? 0xff010103),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
