import 'dart:html' as html;
import 'package:acctik/model/jornal_model_details.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<void> generateArabicPDFReport(
    Map<String, List<JornalModelDetails>> groupedDetails,
    pw.Font? arabicFont,
    String orgname,
    String orgid,
    DateTime startDate,
    DateTime endDate) async {
  final pdf = pw.Document();
  String starstring = DateFormat('yyyy-MM-dd').format(startDate);
  String endstring = DateFormat('yyyy-MM-dd').format(endDate);

  // Prepare processed data
  List<Map<String, dynamic>> processedData = [];
  double totalCumulativeDebit = 0.0;
  double totalCumulativeCredit = 0.0;
  double totalTrialDebit = 0.0;
  double totalTrialCredit = 0.0;
  final JornalService js = JornalService();

  final Map<String, Future<String?>> mainCache = {};
  Future<String?> fetchMainName(String mainid) {
    if (!mainCache.containsKey(mainid)) {
      mainCache[mainid] = js.getMainAccountName(orgid, mainid);
    }
    return mainCache[mainid]!;
  }

  String accounts = "";
  // Process each main account
  for (var entry in groupedDetails.entries) {
    String mainid = entry.key;
    List<JornalModelDetails> details = entry.value;

    // Fetch account name using the provided function
    String? accountName = await fetchMainName(mainid);
    accounts = accounts + accountName! + " - ";
    double cumulativeDebit = 0.0;
    double cumulativeCredit = 0.0;

    // Calculate بالمجاميع
    for (var detail in details) {
      if (detail.type.toLowerCase() == 'debit') {
        cumulativeDebit += detail.value;
      } else if (detail.type.toLowerCase() == 'credit') {
        cumulativeCredit += detail.value;
      }
    }

    // Update overall cumulative totals
    totalCumulativeDebit += cumulativeDebit;
    totalCumulativeCredit += cumulativeCredit;

    // Calculate بالأرصدة
    double trialBalanceDebit = 0.0;
    double trialBalanceCredit = 0.0;
    if (cumulativeDebit > cumulativeCredit) {
      trialBalanceDebit = cumulativeDebit - cumulativeCredit;
      trialBalanceCredit = 0.0;
    } else {
      trialBalanceCredit = cumulativeCredit - cumulativeDebit;
      trialBalanceDebit = 0.0;
    }

    // Update overall trial balances
    totalTrialDebit += trialBalanceDebit;
    totalTrialCredit += trialBalanceCredit;

    processedData.add({
      'accountName': accountName, // Use the account name here
      'cumulativeDebit': cumulativeDebit,
      'cumulativeCredit': cumulativeCredit,
      'trialBalanceDebit': trialBalanceDebit,
      'trialBalanceCredit': trialBalanceCredit,
    });
  }

  // Add page to PDF
  pdf.addPage(
    pw.Page(
      theme: pw.ThemeData.withFont(base: arabicFont),
      textDirection: pw.TextDirection.rtl,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Center(
              child: pw.Text(
                'تقرير ميزان المراجعة بالارصدة والمجاميع',
                style: pw.TextStyle(
                  font: arabicFont,
                  height: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Text(
              ' من تاريخ : $starstring',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              ' الى  تاريخ : $endstring',
              style: pw.TextStyle(
                font: arabicFont,
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                // Header Row
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'بالأرصدة - مدين',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'بالأرصدة - دائن',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'بالمجاميع - مدين',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'بالمجاميع - دائن',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(2),
                      child: pw.Text(
                        'اسم الحساب',
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                  ],
                ),
                // Data Rows
                ...processedData.map((row) {
                  return pw.TableRow(
                    children: [
                      pw.Text(
                        row['trialBalanceDebit'].toStringAsFixed(2),
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        row['trialBalanceCredit'].toStringAsFixed(2),
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        row['cumulativeDebit'].toStringAsFixed(2),
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        row['cumulativeCredit'].toStringAsFixed(2),
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        row['accountName'],
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12,
                        ),
                        textAlign: pw.TextAlign.center,
                      ),
                    ],
                  );
                }).toList(),
                // Totals Row
                pw.TableRow(
                  children: [
                    pw.Text(
                      totalTrialDebit.toStringAsFixed(2),
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      totalTrialCredit.toStringAsFixed(2),
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      totalCumulativeDebit.toStringAsFixed(2),
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      totalCumulativeCredit.toStringAsFixed(2),
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      'الإجمالي',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
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

  // Web: Convert the PDF to bytes and trigger the download
  final pdfBytes = await pdf.save();
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Create an anchor element and simulate a click for downloading
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank' // Optional: opens in a new tab
    ..setAttribute(
        'download', '${accounts} - ميزان المراجعه.pdf') // Dynamic filename
    ..click();

  // Revoke the URL to free resources
  html.Url.revokeObjectUrl(url);

  print("PDF download triggered for: Trial_balance.pdf");
}
