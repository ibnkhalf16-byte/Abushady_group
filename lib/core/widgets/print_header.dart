import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.Widget> getReportHeader(String reportName, {String? subTitle}) async {
  final imageBytes = await rootBundle.load('assets/images/logo.png');
  final logoImage = pw.MemoryImage(imageBytes.buffer.asUint8List());

  return pw.Container(
    padding: const pw.EdgeInsets.only(bottom: 12),
    margin: const pw.EdgeInsets.only(bottom: 16),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.blue900, width: 2)),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              reportName,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
            ),
            if (subTitle != null) ...[
              pw.SizedBox(height: 4),
              pw.Text(subTitle, style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
            ],
            pw.SizedBox(height: 2),
            pw.Text(
              'تاريخ الطباعة: ${DateTime.now().toString().split('.')[0]}',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.Image(logoImage, width: 65, height: 65),
      ],
    ),
  );
}
