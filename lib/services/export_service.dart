import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../models/debt_model.dart';

class ExportService {
  // دالة لتصدير قائمة الديون إلى PDF
  static Future<void> exportToPdf(List<Debt> debts, String title) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.cairoRegular(); // استخدام خط يدعم العربية

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text(title, style: pw.TextStyle(font: font, fontSize: 24)),
            ),
          ),
          pw.Table.fromTextArray(
            headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey),
            cellStyle: pw.TextStyle(font: font),
            cellAlignment: pw.Alignment.center,
            headerDirection: pw.TextDirection.rtl,
            cellDirection: pw.TextDirection.rtl,
            context: context,
            data: <List<String>>[
              <String>['الحالة', 'التاريخ', 'الفئة', 'المبلغ', 'الاسم'],
              ...debts.map((debt) => [
                debt.isPaid ? 'مسدد' : 'غير مسدد',
                DateFormat('yyyy-MM-dd').format(debt.date),
                categoryToString(debt.category),
                debt.amount.toStringAsFixed(2),
                debt.name,
              ]),
            ],
          ),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'debts_report.pdf');
  }

  // دالة لتصدير قائمة الديون إلى Excel (CSV)
  static Future<void> exportToCsv(List<Debt> debts, String title) async {
    List<List<dynamic>> rows = [];
    // إضافة رؤوس الأعمدة
    rows.add(['الاسم', 'المبلغ', 'الفئة', 'التاريخ', 'الحالة']);
    for (var debt in debts) {
      rows.add([
        debt.name,
        debt.amount,
        categoryToString(debt.category),
        DateFormat('yyyy-MM-dd').format(debt.date),
        debt.isPaid ? 'مسدد' : 'غير مسدد'
      ]);
    }

    String csv = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/debts_report.csv";
    final file = File(path);
    // BOM for UTF-8 to make arabic characters readable in Excel
    await file.writeAsBytes([0xEF, 0xBB, 0xBF]);
    await file.writeAsString(csv, mode: FileMode.append);

    await Share.shareXFiles([XFile(path)], text: title);
  }
}
