import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintHelper {
  static Future<void> printDocument({required String title, required String content}) async {
    final pdf = pw.Document();

    // Load Arabic font
    final fontData = await rootBundle.load('assets/font/Cairo-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    // Split content into lines or handle paragraphs
    // Note: Simple markdown to PDF conversion for now
    // In a real scenario, we might want a better markdown-to-pdf parser

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: ttf),
        textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                title,
                style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Paragraph(
              text: content,
              style: pw.TextStyle(font: ttf, fontSize: 14),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save(), name: title);
  }
}
