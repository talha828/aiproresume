import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart%20';
import 'package:printing/printing.dart';

import '../home_cover_temps.dart';

class CommonCoverText {
  pw.Widget commonBody() {
    return pw.Column(children: [
      pw.SizedBox(height: 30),
      pw.Text(TemplateCoverHomeState.coverTemList['opener_detail']),
      pw.SizedBox(height: 10),
      pw.Text(TemplateCoverHomeState.coverTemList['body_detail']),
      pw.SizedBox(height: 10),
      pw.Text(TemplateCoverHomeState.coverTemList['closer_detail']),
      pw.SizedBox(height: 30),
    ]);
  }
}
