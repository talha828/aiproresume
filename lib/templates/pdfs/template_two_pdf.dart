import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
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

class TemplateTwopdf extends StatefulWidget {
  const TemplateTwopdf({super.key});

  @override
  State<TemplateTwopdf> createState() => _TemplateTwopdfState();
}

class _TemplateTwopdfState extends State<TemplateTwopdf> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgLoading();
    generate();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Center(
          child: Text('Templete One'),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     generate();
        //   },
        //   child: const Icon(Icons.picture_as_pdf_outlined),
        // ),
      ),
    );
  }

  //pdf generate
  Future<dynamic> generate() async {
    pw.Document pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        // base: await PdfGoogleFonts.freehandRegular(),
        // icons: await PdfGoogleFonts.materialIcons(),
        icons: await PdfGoogleFonts.materialIcons(),
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          pw.Widget imageWidget;
          if (global.imageShape == global.ImageShape.circle) {
            imageWidget = pw.ClipOval(
                child:
                    pw.Container(color: PdfColors.amber, height: 50, width: 50)
                // Image.network(
                //   'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                //   width: 120,
                //   height: 120,
                //   fit: BoxFit.cover,
                // ),
                );
          } else {
            imageWidget = pw.ClipRRect(
                // borderRadius: BorderRadius.circular(16),
                child:
                    pw.Container(color: PdfColors.amber, height: 50, width: 50)
                // Image.network(
                //   'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
                //   width: 120,
                //   height: 120,
                //   fit: BoxFit.cover,
                // ),
                );
          }
          return [
            pw.Partitions(
              children: [
                //Personal Details
                pw.Partition(
                  width: 210,
                  child: pw.Container(
                    color:
                        PdfColor.fromInt(global.bg1color?.value ?? 0xff303B41),
                    // color: const PdfColor.fromInt(0xff2e3940),
                    height: 841,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: pw.Column(
                        children: [
                          //Image
                          if (global.showImage)
                            pw.Center(
                              child: profileWidget(),
                            ),

                          pw.SizedBox(height: 20),

                          //Contact Details
                          pw.Container(
                            width: double.infinity,
                            color: PdfColors.red,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: pw.Text(
                                'Contact',
                                style: pw.TextStyle(
                                  fontSize: global.headingSize,
                                  color: PdfColors.white,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          contact(),

                          pw.SizedBox(height: 20),

                          //Language details
                          pw.Container(
                            height: 30,
                            width: double.infinity,
                            color: PdfColors.lightGreen,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: pw.Text(
                                'Languages',
                                style: const pw.TextStyle(
                                    fontSize: 18, color: PdfColors.white),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          if (global.showLanguages) language(),

                          pw.SizedBox(height: 20),

                          //Skill & Expertise
                          pw.Container(
                            height: 30,
                            width: double.infinity,
                            color: PdfColors.red,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: pw.Text(
                                'Technical Skills',
                                style: const pw.TextStyle(
                                    fontSize: 18, color: PdfColors.white),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          if (global.showSkill) skill(),

                          pw.SizedBox(height: 20),

                          //soft skills
                          pw.Container(
                            height: 30,
                            width: double.infinity,
                            color: PdfColors.blue300,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: pw.Text(
                                'Soft Skills',
                                style: const pw.TextStyle(
                                    fontSize: 18, color: PdfColors.white),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          if (global.showSoftSkill) softskill(),
                          pw.SizedBox(height: 20),
                          //Hobbies
                          pw.Container(
                            height: 30,
                            width: double.infinity,
                            color: PdfColors.amber700,
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              child: pw.Text(
                                'Hobbies',
                                style: const pw.TextStyle(
                                    fontSize: 18, color: PdfColors.white),
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 10),
                            child: pw.Text(
                              'Reading, VideoGmme, Trvelling, Sports',
                              maxLines: 3,
                              style: const pw.TextStyle(
                                color: PdfColors.white,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          if (global.showSignature) signature(),
                        ],
                      ),
                    ),
                  ),
                ),

                //Experiance Details
                pw.Partition(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.fromLTRB(15, 16, 10, 16),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        //Name and designation
                        nameDesignation(),

                        pw.Divider(color: PdfColors.grey600),
                        pw.SizedBox(height: 10),

                        //Objective
                        pw.Text(
                          "Objective",
                          style: pw.TextStyle(
                              color: PdfColors.red,
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 10),
                        summary(),

                        pw.SizedBox(height: 10),
                        //Experience
                        if (global.showExperience) experience(),
                        pw.SizedBox(height: 10),

                        //Education
                        if (global.showEducation) education(),

                        pw.SizedBox(height: 10),

                        //Certificates
                        if (global.showCertificates) certificate(),
                        pw.SizedBox(height: 10),

                        pw.SizedBox(height: 10),
                        if (global.showAwards) award(),
                        pw.SizedBox(height: 10),
                        if (global.showReference) references(),
                        pw.SizedBox(height: 10),
                        if (global.showExtarDetail) extradetail(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );
    try {
      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {}
  }

  //Msg
  showPrintedMessage(String title, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                color: PdfColor.fromInt(global.font1color?.value ?? 0xffffff),
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
                color: PdfColor.fromInt(global.font1color?.value ?? 0xffffff),
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
                color: PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
                fontSize: global.fontSize,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 5),

        //Website
        // pw.Row(
        //   children: [
        //     pw.Icon(
        //       const pw.IconData(0xe894),
        //       color: PdfColor.fromInt(global.iconColor?.value ?? 0xff017197),
        //       size: 18,
        //     ),
        //     pw.SizedBox(width: 10),
        //     // pw.Text(
        //     //   ContactSectionState.contactList[index]["personal_information"]
        //     //               [index]['website'] !=
        //     //           null
        //     //       ? ContactSectionState.contactList[index]
        //     //               ["personal_information"][index]['website']
        //     //           .toString()
        //     //       : "---",
        //     //   style: pw.TextStyle(
        //     //     color: PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
        //     //     fontSize: global.fontSize,
        //     //   ),
        //     // ),
        //   ],
        // ),
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
          ' ',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff017197),
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
                    color:
                        PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
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
          '  ',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff017197),
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
                    color:
                        PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
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
          ' ',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff017197),
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
                    color:
                        PdfColor.fromInt(global.font2color?.value ?? 0xffffff),
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
        ),
        //skill
      ],
    );
  }

  //Image
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
      debugPrint("error iss: $e");
    }
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
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //Heading
        pw.Text(
          'Work Experience',
          style: pw.TextStyle(
              fontSize: global.headingSize,
              color: PdfColor.fromHex("#FF0000"),
              fontWeight: pw.FontWeight.bold),
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
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
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
        pw.Text(
          'Education',
          style: pw.TextStyle(
              fontSize: global.headingSize,
              color: PdfColor.fromHex("#FF0000"),
              fontWeight: pw.FontWeight.bold),
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
                                .toUpperCase(),
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                              fontSize: global.fontSize,
                              color: PdfColor.fromInt(
                                  global.font1color?.value ?? 0xff010103),
                            ),
                          ),
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
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
                                    EducationSectionState.eduList[0]
                                        ['end_date'],
                                style: pw.TextStyle(
                                    fontSize: global.fontSize,
                                    color: PdfColor.fromInt(
                                        global.font1color?.value ??
                                            0xff717173)),
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
        pw.Text(
          'Certificate',
          style: pw.TextStyle(
              fontSize: global.headingSize,
              color: PdfColor.fromHex("#FF0000"),
              fontWeight: pw.FontWeight.bold),
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
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      CertificateSectionState.certificateList[index]
                          ['institute'],
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
                      CertificateSectionState.certificateList[index]
                          ['description'],
                      maxLines: 4,
                      style: pw.TextStyle(
                        fontSize: global.fontSize,
                        color: PdfColor.fromInt(
                            global.font1color?.value ?? 0xff010103),
                      ),
                    ),
                  ],
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
        pw.Text(
          'Award',
          style: pw.TextStyle(
              fontSize: global.headingSize,
              color: PdfColor.fromHex("#FF0000"),
              fontWeight: pw.FontWeight.bold),
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
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    AwardsSectionState.awardList[index]['body'],
                    style: pw.TextStyle(
                      fontSize: global.fontSize,
                      color: PdfColor.fromInt(
                          global.font1color?.value ?? 0xff717173),
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

  //Signamtue
  pw.Widget signature() {
    return pw.Column(
      children: [
        pw.Text(
          'Signature',
          style: pw.TextStyle(
            fontSize: global.headingSize,
            color: PdfColor.fromInt(global.heading2color?.value ?? 0xff017197),
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        signLogo != null ? pw.Image(signLogo) : pw.Text("signature issue"),
        pw.SizedBox(height: 10),

        //sign
      ],
    );
  }

  pw.Widget extradetail() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        // Heading(title: "Extra Details"),
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

pw.Widget references() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        pw.Divider(color: PdfColors.black),
        pw.Text(
          'References',
          style: pw.TextStyle(
              fontSize: global.headingSize,
              color: PdfColor.fromHex("#000000"),
              fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(color: PdfColors.black),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            ReferenceSectionState.referenceList.length,
            (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                //references

                pw.Text(
                  ReferenceSectionState
                      .referenceList[index]['name']
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
                  ReferenceSectionState
                      .referenceList[index]['contact_no']
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
}
