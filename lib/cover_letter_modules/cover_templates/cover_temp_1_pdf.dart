import 'dart:typed_data';

import 'package:aiproresume/cover_letter_modules/cover_templates/common_cover_text.dart';
import 'package:aiproresume/cover_letter_modules/home_cover_temps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:aiproresume/global.dart' as global;

class CoverTemp1 extends StatefulWidget {
  const CoverTemp1({super.key});

  @override
  State<CoverTemp1> createState() => _CoverTemp1State();
}

class _CoverTemp1State extends State<CoverTemp1> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      generate();
    } catch (e) {
      debugPrint("Error: $e");
    }

    Navigator.pop(context);
  }

  //  final pw.Font ttf = pw.Font.ttf(font);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Demo pdf'),
      ),
    );
  }

  pw.Widget header(pw.Context context) {
    return pw.Container(color: PdfColors.purple, height: 50);
  }

  pw.Widget footer(pw.Context context) {
    return pw.Container(color: PdfColors.purple, height: 20);
  }

  Future<dynamic> generate() async {
    pw.Document pdf = pw.Document();
    final font = await PdfGoogleFonts.poppinsRegular();
    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        // header:header ,
        // footer:footer ,
        build: (pw.Context context) {
          return [
            pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    color: PdfColors.purple,
                    height: 160,
                    width: double.maxFinite,
                    alignment: pw.Alignment.topLeft,
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.all(10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                              TemplateCoverHomeState
                                      .coverTemList['first_name'] +
                                  " " +
                                  TemplateCoverHomeState
                                      .coverTemList['last_name'],
                              style: const pw.TextStyle(
                                  fontSize: 50, color: PdfColors.white)),
                          pw.SizedBox(height: 10),
                          pw.Text(
                              TemplateCoverHomeState.coverTemList['job_title'],
                              style: const pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 25,
                              )),
                          pw.Row(
                            children: [
                              pw.Icon(
                                const pw.IconData(0xe32c),
                                color: PdfColors.white,
                                size: 18,
                              ),
                              pw.SizedBox(width: 5),
                              pw.Text(
                                  TemplateCoverHomeState
                                      .coverTemList['phone_number'],
                                  style: const pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 25,
                                  )),
                              pw.SizedBox(width: 20),
                              pw.Icon(
                                const pw.IconData(0xe158),
                                color: PdfColors.white,
                                size: 18,
                              ),
                              pw.SizedBox(width: 5),
                              pw.Text(
                                  TemplateCoverHomeState
                                      .coverTemList['email_address'],
                                  style: const pw.TextStyle(
                                    color: PdfColors.white,
                                    fontSize: 25,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.Padding(
                      padding: pw.EdgeInsets.all(20),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 30),
                          pw.Text("To"),
                          pw.SizedBox(height: 10),
                          pw.Text("Dear"),
                          pw.SizedBox(height: 10),
                          pw.Text(TemplateCoverHomeState
                                  .coverTemList['employer_name'] ??
                              "Company Name"),
                          CommonCoverText().commonBody(),
                          pw.Text("Sincerely"),
                          pw.SizedBox(height: 30),
                          pw.Text(
                            TemplateCoverHomeState.coverTemList['first_name'] +
                                " " +
                                TemplateCoverHomeState
                                    .coverTemList['last_name'],
                          ),
                        ],
                      )),

                  // pw.Spacer(),
                  //  pw.Container(color: PdfColors.purple, height: 30),
                ],
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
    } catch (e) {
      debugPrint('error');
    }
  }
}
