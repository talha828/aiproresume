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
import '../common_temp/signature_section.dart';
import '../common_temp/skill_section.dart';
import '../common_temp/softskill_section.dart';
import '../common_temp/summary_section.dart';

class TemplateFourPdf extends StatefulWidget {
  const TemplateFourPdf({super.key});

  @override
  State<TemplateFourPdf> createState() => _TemplateFourPdfState();
}

class _TemplateFourPdfState extends State<TemplateFourPdf> {
  @override
  void initState() {
    super.initState();

    imgLoading();
    generate();

    Navigator.pop(context);
  }

  var imageLogo;

  var signLogo;
  imgLoading() async {
    imageLogo = await networkImage(
        'http://resume.cognitiveitsolutions.ca/public/images/' +
            ImagesectionState.img);
    try {
      signLogo = await networkImage(
          'http://resume.cognitiveitsolutions.ca/public/images/${SignatureSectionState.signList['image']}');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Template Four'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     generate();
      //   },
      //   child: const Icon(Icons.picture_as_pdf_outlined),
      // ),
    );
  }

  //Name & Contact Header
  pw.Widget header(pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      color: PdfColor.fromInt(
        global.bg1color?.value ?? 0xff450B51,
      ),
      child: pw.Row(
        children: [
          //Name & Designation
          nameDesignation(),

          pw.Spacer(),
          pw.SizedBox(
              height: 80,
              child: pw.VerticalDivider(
                color: PdfColor.fromInt(
                  global.bg1color?.value ?? 0xffffff,
                ),
              )),
          pw.SizedBox(width: 30),

          //Conatct Details
          contact(),
        ],
      ),
    );
  }

  //pdf generate & cv body
  Future<dynamic> generate() async {
    pw.Document pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.montserratRegular(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        header: header,
        build: (pw.Context context) {
          return [
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: pw.Column(children: [
                pw.Partitions(
                  mainAxisSize: pw.MainAxisSize.max,
                  children: [
                    //Side One
                    pw.Partition(
                      width: 300,
                      child: pw.Padding(
                        padding: pw.EdgeInsets.only(right: 15),
                        child: pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.SizedBox(height: 20),

                              //work experience
                              if (global.showExperience) experience(),

                              pw.SizedBox(height: 15),

                              //Education
                              if (global.showEducation) education(),
                              pw.SizedBox(height: 20),

                              //Certificates
                              if (global.showCertificates) certificate(),
                              pw.SizedBox(height: 20),

                              //awards
                              if (global.showAwards) award(),
                              pw.SizedBox(height: 20),
                              // if (global.showExtarDetail) extradetail(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    //Side two
                    pw.Partition(
                        child: pw.Padding(
                      padding: pw.EdgeInsets.only(left: 15),
                      child: pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            //Summary
                            if (global.showsummary)
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.SizedBox(height: 20),
                                  pw.Text(
                                    'Summary',
                                    style: pw.TextStyle(
                                        fontSize: global.headingSize,
                                        color: PdfColor.fromInt(
                                            global.heading1color?.value ??
                                                0xff450B51),
                                        fontWeight: pw.FontWeight.bold),
                                  ),
                                  pw.SizedBox(height: 10),
                                  summary(),
                                ],
                              ),
                            pw.SizedBox(height: 20),
                            //languages
                            if (global.showLanguages) language(),
                            pw.SizedBox(height: 20),

                            //tech Skill
                            if (global.showSkill) skill(),
                            pw.SizedBox(height: 15),

                            //softskills
                            if (global.showSoftSkill) softskill(),
                            pw.SizedBox(height: 15),
                            if (global.showReference) references(),
                            pw.SizedBox(height: 15),
                            // if (global.showSignature) signature(),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ]),
            ),
          ];
        },
      ),
    );
    try {
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      showPrintedMessage("Success Save to doucment", context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showPrintedMessage("Error Something Wrong", context);
    }
  }

  //Msg
  showPrintedMessage(String title, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Profile
  pw.Widget profileWidget() {
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
          NameDesignationSectionState.nameNM.toString(),
          style: pw.TextStyle(
            fontSize: 28,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromInt(global.heading1color?.value ?? 0xffffff),
          ),
        ),

        //designation
        pw.Text(
          NameDesignationSectionState.jobTitleNM,
          style: pw.TextStyle(
            fontSize: 25,
            color: PdfColor.fromInt(global.heading1color?.value ?? 0xffffff),
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
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //Heading
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe8f9),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xff450B51),
              size: 22,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              'Work Experience',
              style: pw.TextStyle(
                  fontSize: global.headingSize,
                  color: PdfColor.fromInt(
                      global.heading1color?.value ?? 0xff450B51),
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(width: 10),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.ListView(
            children: List.generate(
          ExperienceSectionState.expList.length,
          (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                //Experience
                pw.Text(
                  ExperienceSectionState.expList[index]['job_position']
                      .toUpperCase(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff010103),
                  ),
                ),
                pw.Text(
                  ExperienceSectionState.expList[index]['company_name'],
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff717173),
                  ),
                ),
                pw.Text(
                  ExperienceSectionState.expList[index]['start_date'] +
                      " - " +
                      ExperienceSectionState.expList[index]['end_date'],
                  style: pw.TextStyle(
                      fontSize: global.fontSize,
                      color: PdfColor.fromInt(
                          global.font1color?.value ?? 0xff717173)),
                ),

                pw.SizedBox(height: 5),
                pw.Text(
                  ExperienceSectionState.expList[index]['company_description'] +
                      "\n" +
                      ExperienceSectionState.expList[index]['job_description'],
                  maxLines: 4,
                  style: pw.TextStyle(
                      fontSize: global.fontSize,
                      color: PdfColor.fromInt(
                          global.font1color?.value ?? 0xff010103)),
                ),
                pw.SizedBox(height: 5),
              ]),
        )),
      ],
    );
  }

  //Education
  pw.Widget education() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //Heading
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe80c),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xff450B51),
              size: 22,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              'Education',
              style: pw.TextStyle(
                  fontSize: global.headingSize,
                  color: PdfColor.fromInt(
                      global.heading1color?.value ?? 0xff450B51),
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(width: 10),
          ],
        ),
        pw.SizedBox(height: 10),

        pw.ListView(
            children: List.generate(
                EducationSectionState.eduList.length,
                (index) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            EducationSectionState.eduList[0]['institution']
                                    .toUpperCase() +
                                "\n",
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: global.fontSize,
                              color: PdfColor.fromInt(
                                  global.font1color?.value ?? 0xff010103),
                            ),
                          ),
                          pw.Text(
                            EducationSectionState.eduList[0]['field'] + "\n",
                            style: pw.TextStyle(
                              fontSize: global.fontSize,
                              color: PdfColor.fromInt(
                                  global.font1color?.value ?? 0xff717173),
                            ),
                          ),
                          // pw.Row(
                          //   mainAxisAlignment:
                          //       pw.MainAxisAlignment.spaceBetween,
                          //   children: [

                          //   ],
                          // ),
                          pw.Text(
                            EducationSectionState.eduList[0]['start_date'] +
                                " - " +
                                EducationSectionState.eduList[0]['end_date'],
                            style: pw.TextStyle(
                                fontSize: global.fontSize,
                                color: PdfColor.fromInt(
                                    global.font1color?.value ?? 0xff717173)),
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
                        ]))),
      ],
    );
  }

  //certificate
  pw.Widget certificate() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe8f7),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xff450B51),
              size: 22,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              'Certificate',
              style: pw.TextStyle(
                  fontSize: global.headingSize,
                  color: PdfColor.fromInt(
                      global.heading1color?.value ?? 0xff450B51),
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(width: 10),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.ListView(
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
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff010103),
                  ),
                ),
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
                pw.Text(
                  CertificateSectionState.certificateList[index]['description'],
                  maxLines: 4,
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff010103),
                  ),
                ),

                pw.SizedBox(height: 5),
              ],
            ),
          ),
        ),

        pw.SizedBox(height: 5),
      ],
    );
  }

  //Award
  pw.Widget award() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xea23),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xff450B51),
              size: 22,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              'Award',
              style: pw.TextStyle(
                  fontSize: global.headingSize,
                  color: PdfColor.fromInt(
                      global.heading1color?.value ?? 0xff450B51),
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(width: 10),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.ListView(
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
                  color:
                      PdfColor.fromInt(global.font1color?.value ?? 0xff010103),
                ),
              ),
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
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                AwardsSectionState.awardList[index]['description'],
                maxLines: 4,
                style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff010103)),
              ),
              pw.SizedBox(height: 5),
            ],
          ),
        )),
      ],
    );
  }

  //Contact
  pw.Widget contact() {
    ContactSectionState css = ContactSectionState();
    return pw.Column(
      children: [
        //Address
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe0c8),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xffffff),
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
                color: PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
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
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xffffff),
              size: 18,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              ContactSectionState.contactCS.toString(),
              style: pw.TextStyle(
                color: PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
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
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xffffff),
              size: 18,
            ),
            pw.SizedBox(width: 10),
            pw.Text(
              ContactSectionState.emailCS.toString(),
              style: pw.TextStyle(
                color: PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
                fontSize: global.fontSize,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 5),

        //Website
        pw.Row(
          children: [
            pw.Icon(
              const pw.IconData(0xe894),
              color: PdfColor.fromInt(global.iconColor?.value ?? 0xffffff),
              size: 18,
            ),
            pw.SizedBox(width: 10),
            // pw.Text(
            //   ContactSectionState.contactList[index]["personal_information"]
            //               [index]['website'] !=
            //           null
            //       ? ContactSectionState.contactList[index]
            //               ["personal_information"][index]['website']
            //           .toString()
            //       : "---",
            //   style: pw.TextStyle(
            //     color: PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
            //     fontSize: global.fontSize,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  //Skill
  pw.Widget skill() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Text(
          'Tech Skills',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff450B51),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            SkillSectionState.techskillsList.length,
            (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  SkillSectionState.techskillsList[index]['body'] + "\n",
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font2color?.value ?? 0xff010103),
                  ),
                ),
                pw.LinearProgressIndicator(
                    value: 0.60,
                    valueColor: PdfColors.purple,
                    minHeight: 6,
                    backgroundColor: PdfColors.grey),
                pw.SizedBox(height: 5),
              ],
            ),
          ),
        ),
        //skill
      ],
    );
  }

  //soft Skill
  pw.Widget softskill() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Text(
          'Soft Skills',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff450B51),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            SoftskillSectionState.sslList.length,
            (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  SoftskillSectionState.sslList[index]['body'] + "\n",
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font2color?.value ?? 0xff010103),
                  ),
                ),
                pw.LinearProgressIndicator(
                    value: 0.60,
                    valueColor: PdfColors.purple,
                    minHeight: 6,
                    backgroundColor: PdfColors.grey),
                pw.SizedBox(height: 5),
              ],
            ),
          ),
        ),
        //skill
      ],
    );
  }

  //Languages
  pw.Widget language() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Text(
          'Languages',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff450B51),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.ListView(
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
                    color: PdfColor.fromInt(
                        global.font2color?.value ?? 0xff010103),
                  ),
                ),
                pw.LinearProgressIndicator(
                    value: 0.60,
                    valueColor: PdfColors.purple,
                    minHeight: 6,
                    backgroundColor: PdfColors.grey),
                pw.SizedBox(height: 5),
                //
              ],
            ),
          ),
        ),
      ],
    );
  }

  //hobbies
  pw.Widget hobbies() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Text(
          'Hobbies',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff450B51),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),

        //hobbies
        pw.Text(
          "Gameing, Reading, traveling,",
          style: pw.TextStyle(
            fontSize: global.fontSize,
            color: PdfColor.fromInt(global.font2color?.value ?? 0xff010103),
          ),
        ),
      ],
    );
  }

  //Extra Details
  pw.Widget extradetail() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Text(
          'Extra Detail',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff450B51),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            ExtraSectionState.extraList.length,
            (index) => pw.Column(
              children: [
//details
                pw.Text(
                  ExtraSectionState.extraList[index]['title'],
                  style: pw.TextStyle(
                      fontSize: global.fontSize,
                      color: PdfColor.fromInt(
                          global.font2color?.value ?? 0xff010103),
                      fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  ExtraSectionState.extraList[index]['detail'],
                  maxLines: 4,
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font2color?.value ?? 0xff010103),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //Referencess
  pw.Widget references() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading

        pw.Text(
          'References',
          style: pw.TextStyle(
              fontSize: global.headingSize,
              color:
                  PdfColor.fromInt(global.heading2color?.value ?? 0xff450B51),
              fontWeight: pw.FontWeight.bold),
        ),

        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            ReferenceSectionState.referenceList.length,
            (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                //references

                pw.Text(
                  ReferenceSectionState.referenceList[index]['name']
                      .toUpperCase(),
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff010103),
                  ),
                ),

                pw.Text(
                  ReferenceSectionState.referenceList[index]['designation'],
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff717173),
                  ),
                ),
                pw.Text(
                  ReferenceSectionState.referenceList[index]['company'],
                  style: pw.TextStyle(
                      fontSize: global.fontSize,
                      color: PdfColor.fromInt(
                          global.font1color?.value ?? 0xff717173)),
                ),
                pw.Text(
                  ReferenceSectionState.referenceList[index]['email'],
                  maxLines: 4,
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff010103),
                  ),
                ),
                pw.Text(
                  ReferenceSectionState.referenceList[index]['contact_no']
                      .toString(),
                  maxLines: 4,
                  style: pw.TextStyle(
                    fontSize: global.fontSize,
                    color: PdfColor.fromInt(
                        global.font1color?.value ?? 0xff010103),
                  ),
                ),

                pw.SizedBox(height: 5),
              ],
            ),
          ),
        ),

        pw.SizedBox(height: 5),
      ],
    );
  }

  //Signamtue
  pw.Widget signature() {
    return pw.Column(
      children: [
        pw.Text(
          'Signature',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff450B51),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        signLogo != null ? pw.Image(signLogo) : pw.Text("issue"),
        pw.SizedBox(height: 10),

        //sign
      ],
    );
  }
}

class CustomHeading extends pw.StatelessWidget {
  CustomHeading({
    required this.title,
    this.icon,
  });
  final String title;
  final pw.IconData? icon;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      children: [
        if (icon != null) pw.Icon(icon!, color: PdfColors.blue, size: 18),
        pw.SizedBox(
          width: 10,
        ),
        pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(
              width: 220,
              child: pw.Divider(color: PdfColors.grey, height: 1),
            ),
            pw.Text(
              title.toUpperCase(),
              style: pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.blue,
                  fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(
              width: 220,
              child: pw.Divider(color: PdfColors.grey, height: 1),
            ),
          ],
        ),
      ],
    );
  }
}
