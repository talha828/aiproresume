import 'package:aiproresume/common/app_utils.dart';
import 'package:aiproresume/templates/pdfs/common_sections_pdf.dart';
import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:aiproresume/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../common_temp/image_section.dart';

import '../common_temp/signature_section.dart';

class TemplateOnePdf extends StatefulWidget {
  const TemplateOnePdf({super.key});

  @override
  State<TemplateOnePdf> createState() => _TemplateOnePdfState();
}

class _TemplateOnePdfState extends State<TemplateOnePdf> {
  @override
  void initState() {
    // TODO: implement initState
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
          'http://resume.cognitiveitsolutions.ca/public/images/' +
              SignatureSectionState.signList['image']);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save CV"),
        actions: [
          IconButton(
              onPressed: () {
                print("Called");
              },
              icon: Icon(Icons.upload_file)),
        ],
      ),
      body: Center(
        child: Text('Templete Two'),
      ),
    );
  }

  //pdf generate
  Future<dynamic> generate() async {
    pw.Document pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        icons: await PdfGoogleFonts.materialIcons(),
      ),
    );
    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Partitions(
              children: [
                //Side one
                pw.Partition(
                  width: 348,
                  child: pw.Container(
                    color:
                        PdfColor.fromInt(global.bg1color?.value ?? 0xFFFFFFFF),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 25,
                        horizontal: 15,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              if (global.showImage)
                                CommonPdfSections().profileWidget(imageLogo),
                              CommonPdfSections().nameDesignation(),
                            ],
                          ),
                          //summary
                          if (global.showsummary)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Objective',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 5),
                                //summary(),
                                CommonPdfSections().summary(),
                              ],
                            ),
                          pw.SizedBox(height: 10),
                          //work experience
                          if (global.showExperience)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //Heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Work Experience',
                                  style: pw.TextStyle(
                                      fontSize: global.headingSize,
                                      color: PdfColor.fromHex("#000000"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().experience(),
                              ],
                            ),

                          pw.SizedBox(height: 10),

                          //Education
                          if (global.showEducation)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //Heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Education',
                                  style: pw.TextStyle(
                                      fontSize: global.headingSize,
                                      color: PdfColor.fromHex("#000000"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().education(),
                              ],
                            ),
                          pw.SizedBox(height: 10),
                          //Awards
                          if (global.showAwards)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Award',
                                  style: pw.TextStyle(
                                      fontSize: global.headingSize,
                                      color: PdfColor.fromHex("#000000"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().award(),
                              ],
                            ),

                          pw.SizedBox(height: 10),
    //certificate
                          if (global.showCertificates)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Certificate',
                                  style: pw.TextStyle(
                                      fontSize: global.headingSize,
                                      color: PdfColor.fromHex("#000000"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().certificate(),
                              ],
                            ),

                          pw.SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),

                //Side two
                pw.Partition(
                  child: pw.Container(
                    color:
                        PdfColor.fromInt(global.bg2color?.value ?? 0xffffffff),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 25,
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          //Contact Details
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(horizontal: 10),
                            child: CommonPdfSections().contact(),
                          ),
                          pw.SizedBox(height: 50),

                          //SoftSkills
                          if (global.showSoftSkill)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Soft Skills ',
                                  style: pw.TextStyle(
                                    fontSize: global.headingSize,
                                    color: PdfColor.fromInt(
                                        global.heading2color?.value ??
                                            0x000000),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().softskill(),
                              ],
                            ),

                          pw.SizedBox(height: 10),

                          //Tech Skills
                          if (global.showSkill)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Technical Skills  ',
                                  style: pw.TextStyle(
                                    fontSize: global.headingSize,
                                    color: PdfColor.fromInt(
                                        global.heading2color?.value ??
                                            0x000000),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().skill(),
                              ],
                            ),

                          pw.SizedBox(height: 10),
                          //Language
                          if (global.showLanguages)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Language ',
                                  style: pw.TextStyle(
                                    fontSize: global.headingSize,
                                    color: PdfColor.fromInt(
                                        global.heading2color?.value ??
                                            0x000000),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().language(),
                              ],
                            ),

                          pw.SizedBox(height: 10),
                   //reference
                          if (global.showReference)
                            pw.Column(
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
                                CommonPdfSections().references(),
                              ],
                            ),
                          pw.SizedBox(height: 10),

                          //extra detail
                          if (global.showExtarDetail)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                //heading
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Extra Details',
                                  style: pw.TextStyle(
                                      fontSize: global.headingSize,
                                      color: PdfColor.fromHex("#000000"),
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.Divider(color: PdfColors.black),
                                pw.SizedBox(height: 10),
                                CommonPdfSections().extradetail(),
                              ],
                            ),
                          pw.SizedBox(height: 10),
                          //signature
                          if (global.showSignature)
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Divider(color: PdfColors.black),
                                pw.Text(
                                  'Signature',
                                  style: pw.TextStyle(
                                    fontSize: global.headingSize,
                                    color: PdfColor.fromInt(
                                        global.heading2color?.value ??
                                            0x000000),
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                                pw.Divider(color: PdfColors.black),
                                CommonPdfSections().signature(signLogo),
                              ],
                            ),
                        ],
                      ),
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
      // Printing.layoutPdf(
      //   onLayout: (PdfPageFormat format) async => pdf.save(),
      // );
      savePdf(pdf);
      // ignore: use_build_context_synchronously
      showPrintedMessage("Success Save to doucment", context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showPrintedMessage("Error Something Wrong", context);
    }
  }

  savePdf(pdf) async {
    final List<int> bytes = await pdf.save();
    await AppUtils().saveAndLaunchFile(bytes, 'MyCV.pdf', context);
    pdf.dispose();
  }

  //Msg
  showPrintedMessage(String title, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(title),
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
