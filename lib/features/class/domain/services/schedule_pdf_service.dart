import 'package:easy_localization/easy_localization.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SchedulePdfService {
  static Future<void> generateAndPrint({
    required List<ScheduleModel> schedule,
    required String className,
    required int periodsCount,
    required int thursdayPeriodsCount,
    required int breakAfterPeriod,
  }) async {
    final pdf = pw.Document();

    // Load Cairo font for Arabic support
    final arabicFont = await PdfGoogleFonts.cairoMedium();
    final boldFont = await PdfGoogleFonts.cairoBold();

    final days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];

    // Calculate max periods including break
    final maxPeriodsCount =
        (periodsCount > thursdayPeriodsCount ? periodsCount : thursdayPeriodsCount) + 1;
    final periods = List.generate(maxPeriodsCount, (index) => index + 1);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        theme: pw.ThemeData.withFont(base: arabicFont, bold: boldFont),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'الجدول المدرسي - $className',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                textDirection: pw.TextDirection.rtl,
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(80), // Days column
                  for (int i = 1; i <= maxPeriodsCount; i++) i: const pw.FlexColumnWidth(),
                },
                children: [
                  // Header Row
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'اليوم / الحصة',
                          textAlign: pw.TextAlign.center,
                          textDirection: pw.TextDirection.rtl,
                        ),
                      ),
                      for (var p in periods)
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            p == breakAfterPeriod + 1
                                ? 'فسحة'
                                : 'الحصة ${p <= breakAfterPeriod ? p : p - 1}',
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                          ),
                        ),
                    ],
                  ),
                  // Data Rows
                  for (var day in days)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            day.tr(),
                            textAlign: pw.TextAlign.center,
                            textDirection: pw.TextDirection.rtl,
                          ),
                        ),
                        for (var p in periods)
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: _buildTableCell(schedule, day, p, breakAfterPeriod),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Schedule_$className.pdf',
    );
  }

  static pw.Widget _buildTableCell(
    List<ScheduleModel> schedule,
    String day,
    int period,
    int breakAfter,
  ) {
    try {
      final isBreakSlot = period == breakAfter + 1;
      final searchPeriod = isBreakSlot ? 0 : (period > breakAfter + 1 ? period - 1 : period);
      final item = schedule.firstWhere((s) => s.day == day && s.period == searchPeriod);
      return pw.Column(
        children: [
          pw.Text(
            item.subjectName,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
            textDirection: pw.TextDirection.rtl,
          ),
          pw.Text(
            item.teacherName,
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.center,
            textDirection: pw.TextDirection.rtl,
          ),
        ],
      );
    } catch (_) {
      return pw.Text('');
    }
  }
}
