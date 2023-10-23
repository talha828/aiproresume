import 'dart:typed_data';

import 'package:aiproresume/cover_letter_modules/cover_templates/common_cover_text.dart';
import 'package:aiproresume/cover_letter_modules/home_cover_temps.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:aiproresume/global.dart' as global;

class CoverTemp3 extends StatefulWidget {
  const CoverTemp3({super.key});

  @override
  State<CoverTemp3> createState() => _CoverTemp3State();
}

class _CoverTemp3State extends State<CoverTemp3> {
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
              padding: pw.EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                              TemplateCoverHomeState
                                      .coverTemList['first_name'] +
                                  " " +
                                  TemplateCoverHomeState
                                      .coverTemList['last_name'] +
                                  "\n" +
                                  TemplateCoverHomeState
                                      .coverTemList['job_title'],
                              style: const pw.TextStyle(
                                fontSize: 50,
                              )),

                          // pw.Column(
                          //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                          //   children: [
                          //     pw.Text(
                          //         TemplateCoverHomeState
                          //                 .coverTemList['first_name'] +
                          //             " " +
                          //             TemplateCoverHomeState
                          //                 .coverTemList['last_name']+ " \n"+TemplateCoverHomeState
                          //             .coverTemList['job_title'],
                          //         style: const pw.TextStyle(
                          //           fontSize: 50,
                          //         )),
                          //     pw.SizedBox(height: 10),
                          //     pw.Text(
                          //         TemplateCoverHomeState
                          //             .coverTemList['job_title'],
                          //         style: const pw.TextStyle(
                          //           fontSize: 40,
                          //         )),
                          //   ],
                          // ),

                          pw.Text(
                              TemplateCoverHomeState
                                      .coverTemList['phone_number'] +
                                  "\n" +
                                  TemplateCoverHomeState
                                      .coverTemList['email_address'],
                              style: const pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 25,
                              )),
                          // pw.Expanded(
                          //   child: pw.Column(
                          //     children: [
                          //       pw.Text(
                          //           TemplateCoverHomeState
                          //               .coverTemList['phone_number']+"\n"+TemplateCoverHomeState
                          //               .coverTemList['email_address'],
                          //           style: const pw.TextStyle(
                          //             color: PdfColors.white,
                          //             fontSize: 25,
                          //           )),
                          //       pw.SizedBox(height: 10),
                          //       pw.Text(
                          //           TemplateCoverHomeState
                          //               .coverTemList['email_address'],
                          //           style: const pw.TextStyle(
                          //             color: PdfColors.white,
                          //             fontSize: 25,
                          //           )),
                          //     ],
                          //   ),
                          // ),
                        ]),
                    pw.Container(
                      child: pw.Column(
                        children: [
                          pw.Padding(
                              padding: pw.EdgeInsets.all(20),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.SizedBox(height: 30),
                                  pw.Text(TemplateCoverHomeState
                                          .coverTemList['employer_name'] ??
                                      "Company Name"),
                                  pw.SizedBox(height: 10),
                                  pw.Text(TemplateCoverHomeState
                                          .coverTemList['street_address'] ??
                                      "Street Address"),
                                  pw.SizedBox(height: 10),
                                  pw.Text(TemplateCoverHomeState
                                          .coverTemList['zip_code'] ??
                                      "Zip code"),
                                  pw.SizedBox(height: 30),
                                  pw.Text("Dear Sir/Madam"),
                                  pw.SizedBox(height: 10),
                                  CommonCoverText().commonBody(),
                                  pw.SizedBox(height: 30),
                                  pw.Text("Kind Regards"),
                                  pw.SizedBox(height: 10),
                                  pw.Text(
                                    TemplateCoverHomeState
                                            .coverTemList['first_name'] +
                                        " " +
                                        TemplateCoverHomeState
                                            .coverTemList['last_name'],
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ]),

              // pw.Spacer(),
              //  pw.Container(color: PdfColors.purple, height: 30),
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
