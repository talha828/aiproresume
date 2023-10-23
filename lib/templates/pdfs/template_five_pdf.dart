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

class TemplateFivePdf extends StatefulWidget {
  TemplateFivePdf({super.key});

  @override
  State<TemplateFivePdf> createState() => _TemplateFivePdfState();
}

const PdfColor cream = PdfColor.fromInt(0xffd9d6cd);
const PdfColor lightcream = PdfColor.fromInt(0xffEFEDE8);
const PdfColor orange = PdfColor.fromInt(0xffc7784d);
const PdfColor grey = PdfColors.grey700;

class _TemplateFivePdfState extends State<TemplateFivePdf> {
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
          ImagesectionState.img,
    );
    signLogo = await networkImage(
        'http://resume.cognitiveitsolutions.ca/public/images/${SignatureSectionState.signList['image']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("template Five")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generate();
        },
        child: const Icon(Icons.picture_as_pdf_outlined),
      ),
    );
  }

  //header
  pw.Widget header(pw.Context context) {
    return pw.Container(
      height: 140,
      width: double.infinity,
      color: cream,
      child: pw.Center(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            //Name & Designation
            nameDesignation(),
            pw.SizedBox(height: 10),

            //Contact
            contact(),
          ],
        ),
      ),
    );
  }

  //pdf generate
  Future<dynamic> generate() async {
    pw.Document pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.barlowRegular(),
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
            pw.Container(
              color: cream,
              child: pw.Padding(
                padding:
                    const pw.EdgeInsets.only(left: 20, right: 20, bottom: 25),
                child: pw.Partitions(
                  children: [
                    //side One
                    pw.Partition(
                      child: pw.Padding(
                        padding: pw.EdgeInsets.only(right: 5),
                        child: pw.Container(
                          height: 676,
                          color: lightcream,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //about me
                                if (global.showsummary)
                                  pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      Heading(title: 'about me'),
                                      pw.SizedBox(height: 10),
                                      pw.Padding(
                                        padding: pw.EdgeInsets.all(10),
                                        child: summary(),
                                      ),
                                    ],
                                  ),

                                //certificates
                                if (global.showCertificates) certificate(),
                                pw.SizedBox(height: 10),

                                //awards
                                if (global.showAwards) award(),
                                pw.SizedBox(height: 10),

                                //languages
                                if (global.showLanguages) language(),

                                pw.SizedBox(height: 10),
                                //extradetails
                                if (global.showExtarDetail) extradetail(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    //side two
                    pw.Partition(
                      child: pw.Padding(
                        padding: pw.EdgeInsets.only(left: 5),
                        child: pw.Container(
                          color: lightcream,
                          height: 676,
                          child: pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 10),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              mainAxisSize: pw.MainAxisSize.min,
                              children: [
                                //Education
                                if (global.showEducation) education(),
                                pw.SizedBox(height: 14),

                                //Experiene
                                if (global.showExperience) experience(),

                                //Tech Skills
                                if (global.showSkill) skill(),
                                //Soft Skills
                                if (global.showSoftSkill) softskill(),
                                //reference
                                if (global.showReference) references(),

                                //signs
                                if (global.showSignature) signature(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
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
            color: PdfColor.fromInt(global.heading1color?.value ?? 0xB7410E),
          ),
        ),

        //designation
        pw.Text(
          NameDesignationSectionState.jobTitleNM,
          style: pw.TextStyle(
            fontSize: 25,
            color: PdfColor.fromInt(global.heading1color?.value ?? 0xB7410E),
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
        color: PdfColor.fromInt(global.font1color?.value ?? 0xff98958C),
      ),
    );
  }

  //Experience
  pw.Widget experience() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //Heading

        Heading(title: "Experience"),
        pw.SizedBox(height: 10),
        pw.ListView(
            children: List.generate(
          ExperienceSectionState.expList.length,
          (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                        child: CustomTextPdf5(
                      text: ExperienceSectionState.expList[index]
                              ['start_date'] +
                          " - " +
                          ExperienceSectionState.expList[index]['end_date'],
                    )),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: CustomTextPdf5(
                          text: ExperienceSectionState.expList[index]
                              ['job_position'],
                          fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Expanded(
                        child: CustomTextPdf5(
                      text: ExperienceSectionState.expList[index]
                          ['company_name'],
                    ))
                    // pw.Expanded(
                    //   child:
                    // ),
                  ],
                ),
                CustomTextPdf5(
                    text: ExperienceSectionState.expList[index]
                        ['job_description'],
                    fontWeight: pw.FontWeight.bold),
                pw.Divider(color: grey),

                //Experience
                // pw.Text(
                //   ExperienceSectionState.expList[index]['job_position']
                //       .toUpperCase(),
                //   style: pw.TextStyle(
                //     fontWeight: pw.FontWeight.bold,
                //     fontSize: global.fontSize,
                //     color: PdfColor.fromInt(
                //         global.font1color?.value ?? 0xff010103),
                //   ),
                // ),
                // pw.Text(
                //   ExperienceSectionState.expList[index]['company_name'],
                //   style: pw.TextStyle(
                //     fontSize: global.fontSize,
                //     color: PdfColor.fromInt(
                //         global.font1color?.value ?? 0xff717173),
                //   ),
                // ),
                // pw.Text(
                //   ExperienceSectionState.expList[index]['start_date'] +
                //       " - " +
                //       ExperienceSectionState.expList[index]['end_date'],
                //   style: pw.TextStyle(
                //       fontSize: global.fontSize,
                //       color: PdfColor.fromInt(
                //           global.font1color?.value ?? 0xff717173)),
                // ),

                // pw.SizedBox(height: 5),
                // pw.Text(
                //   ExperienceSectionState.expList[index]['company_description'] +
                //       "\n" +
                //       ExperienceSectionState.expList[index]['job_description'],
                //   maxLines: 4,
                //   style: pw.TextStyle(
                //       fontSize: global.fontSize,
                //       color: PdfColor.fromInt(
                //           global.font1color?.value ?? 0xff010103)),
                // ),
                // pw.SizedBox(height: 5),
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
        Heading(title: "Education"),
        pw.SizedBox(height: 10),

        pw.ListView(
            children: List.generate(
                EducationSectionState.eduList.length,
                (index) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
//education

                          pw.Row(
                            children: [
                              pw.Expanded(
                                  child: CustomTextPdf5(
                                text: EducationSectionState.eduList[0]
                                        ['start_date'] +
                                    " - " +
                                    EducationSectionState.eduList[0]
                                        ['end_date'],
                              )),
                            ],
                          ),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: CustomTextPdf5(
                                    text: EducationSectionState.degreeName ??
                                        "None",
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(height: 5),
                              pw.Expanded(
                                  child: CustomTextPdf5(
                                      text: EducationSectionState.eduList[0]
                                          ['field']))
                              // pw.Expanded(
                              //   child:
                              // ),
                            ],
                          ),
                          CustomTextPdf5(
                              text: EducationSectionState.eduList[0]
                                      ['institution']
                                  .toUpperCase(),
                              fontWeight: pw.FontWeight.bold),
                          pw.Divider(color: grey),

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

        Heading(title: "Certificate"),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            CertificateSectionState.certificateList.length,
            (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                //certificate
                pw.Row(
                  children: [
                    pw.Expanded(
                        child: CustomTextPdf5(
                      text: CertificateSectionState.certificateList[index]
                          ['date'],
                    )),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: CustomTextPdf5(
                          text: CertificateSectionState.certificateList[index]
                              ['title'],
                          fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Expanded(
                        child: CustomTextPdf5(
                      text: CertificateSectionState.certificateList[index]
                          ['institute'],
                    ))
                    // pw.Expanded(
                    //   child:
                    // ),
                  ],
                ),
                CustomTextPdf5(
                    text: CertificateSectionState.certificateList[index]
                        ['description'],
                    fontWeight: pw.FontWeight.bold),
                pw.Divider(color: grey),

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

        Heading(title: "Awards"),
        pw.SizedBox(height: 10),
        pw.ListView(
            children: List.generate(
          AwardsSectionState.awardList.length,
          (index) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              //award
              pw.Row(
                children: [
                  pw.Expanded(
                      child: CustomTextPdf5(
                    text: AwardsSectionState.awardList[index]['date'],
                  )),
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: CustomTextPdf5(
                        text: AwardsSectionState.awardList[index]['name']
                            .toUpperCase(),
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Expanded(
                      child: CustomTextPdf5(
                    text: AwardsSectionState.awardList[index]['body'],
                  ))
                  // pw.Expanded(
                  //   child:
                  // ),
                ],
              ),
              CustomTextPdf5(
                  text: AwardsSectionState.awardList[index]['description'],
                  fontWeight: pw.FontWeight.bold),
              pw.Divider(color: grey),

              pw.SizedBox(height: 5),

              pw.SizedBox(height: 5),
            ],
          ),
        )),
      ],
    );
  }

  //Contact
  pw.Widget contact() {
    return pw.Row(
      // crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        //Number
        pw.Icon(
          const pw.IconData(0xe32c),
          color: PdfColor.fromInt(global.iconColor?.value ?? 0xff017197),
          size: 18,
        ),

        pw.Text(
          ContactSectionState.contactCS.toString(),
          style: pw.TextStyle(
            color: PdfColor.fromInt(global.font2color?.value ?? 0xB7410E),
            fontSize: global.fontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: 5),

        //Email
        pw.Icon(
          const pw.IconData(0xe158),
          color: PdfColor.fromInt(global.iconColor?.value ?? 0xff017197),
          size: 18,
        ),

        pw.Text(
          ContactSectionState.emailCS.toString(),
          style: pw.TextStyle(
            color: PdfColor.fromInt(global.font2color?.value ?? 0xB7410E),
            fontSize: global.fontSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(width: 5),

        //Website
        pw.Icon(
          const pw.IconData(0xe894),
          color: PdfColor.fromInt(global.iconColor?.value ?? 0xff017197),
          size: 18,
        ),

        // pw.Text(
        //   ContactSectionState.contactList[index]["personal_information"]
        //               [index]['website'] !=
        //           null
        //       ? ContactSectionState.contactList[index]
        //               ["personal_information"][index]['website']
        //           .toString()
        //       : "---",
        //   style: pw.TextStyle(
        //     color: PdfColor.fromInt(global.font2color?.value ?? 0xB7410E),
        //     fontSize: global.fontSize,
        //     fontWeight: pw.FontWeight.bold,
        //   ),
        // ),
      ],
    );
  }

  //Skill
  pw.Widget skill() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        //heading
        Heading(title: "Technical Skills"),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            SkillSectionState.techskillsList.length,
            (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextPdf5(
                      text: SkillSectionState.techskillsList[index]['body'] +
                          "\n",
                    ),
                    pw.Container(
                      width: 160,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: grey, width: 2),
                      ),
                      child: pw.LinearProgressIndicator(
                          value: 0.40,
                          valueColor: orange,
                          minHeight: 6,
                          backgroundColor: lightcream),
                    )
                  ],
                ),
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
        Heading(title: "Soft Skills"),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            SoftskillSectionState.sslList.length,
            (index) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextPdf5(
                      text: SoftskillSectionState.sslList[index]['body'] + "\n",
                    ),
                    pw.Container(
                      width: 160,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: grey, width: 2),
                      ),
                      child: pw.LinearProgressIndicator(
                          value: 0.40,
                          valueColor: orange,
                          minHeight: 6,
                          backgroundColor: lightcream),
                    )
                  ],
                ),
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
        Heading(title: "Languages"),
        pw.SizedBox(height: 10),
        pw.ListView(
          children: List.generate(
            LanguagesSectionState.languageList.length,
            (index) => pw.Padding(
              padding: pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  //language
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextPdf5(
                        text: LanguagesSectionState.languageList[index]
                            ['language'],
                      ),
                      pw.Container(
                        width: 160,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: grey, width: 2),
                        ),
                        child: pw.LinearProgressIndicator(
                            value: 0.40,
                            valueColor: orange,
                            minHeight: 6,
                            backgroundColor: lightcream),
                      )
                    ],
                  ),

                  //
                ],
              ),
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
        Heading(title: "Hobbies"),
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
        Heading(title: "Extra Details"),
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

        Heading(title: "References"),

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

  //Signature
  pw.Widget signature() {
    return pw.Column(
      children: [
        Heading(title: "Signature"),
        signLogo != null ? pw.Image(signLogo) : pw.Text("issue"),
        pw.SizedBox(height: 10),

        //sign
      ],
    );
  }
}

class Heading extends pw.StatelessWidget {
  Heading({
    required this.title,
  });
  final String title;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Container(
      height: 30,
      width: 120,
      color: orange,
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(left: 12, top: 4),
        child: pw.Text(
          title.toUpperCase(),
          style: const pw.TextStyle(color: PdfColors.white, fontSize: 18),
        ),
      ),
    );
  }
}

class CustomTextPdf5 extends pw.StatelessWidget {
  CustomTextPdf5({
    required this.text,
    this.textColor,
    this.maxline,
    this.textAlign,
    this.fontWeight,
  });
  final String text;
  final PdfColor? textColor;
  final int? maxline;
  final pw.TextAlign? textAlign;
  final pw.FontWeight? fontWeight;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      text,
      textAlign: textAlign,
      maxLines: maxline,
      style: pw.TextStyle(
        color: textColor ?? grey,
        fontWeight: fontWeight,
      ),
    );
  }
}
