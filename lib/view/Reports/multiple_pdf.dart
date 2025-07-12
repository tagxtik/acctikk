import 'package:acctik/global/reportModDetail.dart';
import 'package:acctik/model/report_jornal_model.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

Future<void> fetchMultiple(
    List<int> journalIds, String orgid, String jname) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Map<String, Future<String?>> mainAccountNamesCache = {};
  final Map<String, Future<String?>> subcatche = {};

  final Map<String, Future<String?>> orgNameCache = {};
  final Map<String, Future<String?>> descCache = {};
  final JornalService js = JornalService();

  Future<String?> fetchMainAccountName(String mainId) {
    if (!mainAccountNamesCache.containsKey(mainId)) {
      mainAccountNamesCache[mainId] = js.getMainAccountName(orgid, mainId);
    }
    return mainAccountNamesCache[mainId]!;
  }

  Future<String?> fetchsub(String mainid, String subid) {
    if (!subcatche.containsKey(subid)) {
      subcatche[subid] = js.getSubname(orgid, mainid, subid);
    }
    return subcatche[subid]!;
  }

  Future<String?> fetchDesc(int jid) async {
    final key = jid.toString();
    if (!descCache.containsKey(key)) {
      descCache[key] = js.getDesc(orgid, jid);
    }
    return await descCache[key] ?? "No description available";
  }

  Future<String?> fetchOrgName(String orgid) {
    if (!orgNameCache.containsKey(orgid)) {
      orgNameCache[orgid] = js.getOrgname(orgid);
    }
    return orgNameCache[orgid]!;
  }

  final orgNameFuture = fetchOrgName(orgid);

  String orgName = await orgNameFuture ?? "N/A";

  Reportmoddetail jmod = Reportmoddetail();
  DateTime lastDate = DateTime.now();
  jmod.clearSharedPreferences();
  List<ReportJornalModel> allJournalItems = [];

  // Loop through each journal ID to fetch its entries
  for (var jid in journalIds) {
    final querySnapshot = await firestore
        .collection('orgs')
        .doc(orgid)
        .collection("journals")
        .doc(jid.toString())
        .collection("jdetails")
        .get();

    final descFuture = fetchDesc(jid);
    String desc = await descFuture ?? "N/A";

    for (var doc in querySnapshot.docs) {
      Timestamp jdate = doc["entredDate"];
      DateTime dateTime = jdate.toDate();
      lastDate = dateTime;

      int journalId;
      if (doc["jornalid"] is String) {
        journalId = int.tryParse(doc["jornalid"]) ?? 0;
      } else if (doc["jornalid"] is int) {
        journalId = doc["jornalid"];
      } else {
        journalId = 0;
      }

      String mainid = doc["mainid"];
      final mainAccountNameFuture = fetchMainAccountName(mainid);
      String mainAccountName = await mainAccountNameFuture ?? "N/A";
      String subid = doc["subid"];

      final subfuture = fetchsub(mainid, subid);

      String subname = await subfuture ?? "N/A";
      final data = doc.data() as Map<String, dynamic>?;

      final newItem = ReportJornalModel(
        jornalId: journalId,
        entredDate: dateTime,
        entredBy: data?["entredby"] ?? "Unknown",
        type: data?["type"] ?? "N/A",
        mainid: data?["mainid"] ?? "N/A",
        subid: data?["subid"] ?? "N/A",
        mainname: mainAccountName,
        subname: subname,
        value: data?["value"]?.toDouble() ?? 0.0,
      );

      allJournalItems.add(newItem);
    }
  }

  // Once all journal entries are fetched, generate a single PDF
  generateMultiple(
      allJournalItems, jname, lastDate, orgName, "Multiple Journal Entries");
  print(
      "All specified journal entries fetched and added to a single PDF successfully.");
}

Future<void> generateMultiple(List<ReportJornalModel> journalDetails,
    String jname, DateTime jdate, String orgname, String desc) async {
  String onlyDate = DateFormat('yyyy-MM-dd').format(jdate);

  // Load Arabic font
  pw.Font? arabicFont;
  try {
    final fontData =
        await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
    arabicFont = pw.Font.ttf(fontData);
  } catch (e) {
    print("Error loading font: $e");
    arabicFont = pw.Font.helvetica();
  }

  // Sort the journal entries by Debit value
  journalDetails.sort((a, b) {
    if (a.type == "Debit" && b.type == "Debit") {
      return a.value.compareTo(b.value); // Sort by value in ascending order
    } else if (a.type == "Debit") {
      return -1; // Debit comes before Credit
    } else if (b.type == "Debit") {
      return 1; // Credit comes after Debit
    }
    return 0;
  });

  final pdf = pw.Document();
  const int rowsPerPage = 20;
  final int totalPages = (journalDetails.length / rowsPerPage).ceil();

  // Calculate total Debit and Credit for all entries
  double totalDebit = journalDetails
      .where((item) => item.type == "Debit")
      .fold(0, (sum, item) => sum + item.value);
  double totalCredit = journalDetails
      .where((item) => item.type == "Credit")
      .fold(0, (sum, item) => sum + item.value);

  for (int page = 0; page < totalPages; page++) {
    final startIndex = page * rowsPerPage;
    final endIndex = startIndex + rowsPerPage;
    final pageData = journalDetails.sublist(startIndex,
        endIndex > journalDetails.length ? journalDetails.length : endIndex);

    pdf.addPage(
      pw.Page(
        textDirection: pw.TextDirection.rtl,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                ' صفحة ${page + 1} من $totalPages',
                style: pw.TextStyle(
                  font: arabicFont,
                  fontSize: 9,
                ),
                textAlign: pw.TextAlign.right,
              ),
              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  'قيد اليوميه',
                  style: pw.TextStyle(
                    font: arabicFont,
                    height: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Center(
                child: pw.Text(
                  'اسم المؤسسه: $orgname',
                  style: pw.TextStyle(font: arabicFont, fontSize: 12),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      'رقم القيد:)....................( ',
                      style: pw.TextStyle(font: arabicFont, height: 12),
                      textAlign: pw.TextAlign.right,
                    ),
                  ]),

              pw.SizedBox(height: 10),
              pw.Center(
                child: pw.Text(
                  '  تاريخ القيد  $onlyDate :',
                  style: pw.TextStyle(font: arabicFont, height: 12),
                  textAlign: pw.TextAlign.right,
                ),
              ),

              pw.SizedBox(height: 10),

              // Journal table for the current page
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  // Table header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('دائن',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: arabicFont)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('مدين',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: arabicFont)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('اسم الحساب الفرعي',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: arabicFont)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(2),
                        child: pw.Text('اسم الحساب الرئيسي',
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: arabicFont)),
                      ),
                    ],
                  ),
                  // Table rows for each journal entry
                  for (var detail in pageData)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(
                            detail.type == "Credit"
                                ? detail.value.toString()
                                : "0",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: arabicFont),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(
                            detail.type == "Debit"
                                ? detail.value.toString()
                                : "0",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(font: arabicFont),
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(detail.subname,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(font: arabicFont)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(detail.mainname,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(font: arabicFont)),
                        ),
                      ],
                    ),
                ],
              ),
              // If this is the last page, add a final row for overall totals
              if (page == totalPages - 1) ...[
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(totalCredit.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: arabicFont),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text(totalDebit.toStringAsFixed(2),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: arabicFont),
                              textAlign: pw.TextAlign.center),
                        ),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Text('')),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(2),
                          child: pw.Text('المجموع النهائي',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  font: arabicFont),
                              textAlign: pw.TextAlign.center),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Center(
                  child: pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Column(children: [
                        pw.SizedBox(height: 20),
                        pw.Text(
                          "البيان : ",
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontSize: 14,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          desc,
                          style: pw.TextStyle(
                            font: arabicFont,
                            height: 12,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ])),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // Add a final page with the description paragraph
  // pdf.addPage(
  //   pw.Page(
  //     textDirection: pw.TextDirection.rtl,
  //     pageFormat: PdfPageFormat.a4,
  //     build: (pw.Context context) {
  //       return pw.Center(
  //         child: pw.Padding(
  //             padding: const pw.EdgeInsets.all(20),
  //             child: pw.Column(children: [
  //               pw.Center(
  //                 child: pw.Text(
  //                   'اسم المؤسسه: $orgname',
  //                   style: pw.TextStyle(font: arabicFont,height: 12),
  //                   textAlign: pw.TextAlign.right,
  //                 ),
  //               ),
  //               pw.SizedBox(height: 10),
  //               pw.Row(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.center,
  //                   mainAxisAlignment: pw.MainAxisAlignment.center,
  //                   children: [
  //                     pw.Text(
  //                       'اسم القيد: $jname',
  //                       style: pw.TextStyle(font: arabicFont,height: 12),
  //                       textAlign: pw.TextAlign.right,
  //                     ),
  //                     pw.Text(
  //                       '    -    ',
  //                       style: pw.TextStyle(font: arabicFont,height: 12),
  //                       textAlign: pw.TextAlign.right,
  //                     ),
  //                     pw.Text(
  //                       'رقم القيد:)....................( ',
  //                       style: pw.TextStyle(font: arabicFont,height: 12),
  //                       textAlign: pw.TextAlign.right,
  //                     ),
  //                   ]),
  //               pw.SizedBox(height: 10),
  //               pw.Center(
  //                 child: pw.Text(
  //                   '  تاريخ القيد  $onlyDate :',
  //                   style: pw.TextStyle(font: arabicFont,height: 12),
  //                   textAlign: pw.TextAlign.right,
  //                 ),
  //               ),
  //               pw.Text(
  //                 "البيان : ",
  //                 style: pw.TextStyle(
  //                   font: arabicFont,
  //                   fontSize: 16,
  //                 ),
  //                 textAlign: pw.TextAlign.center,
  //               ),
  //               pw.Text(
  //                 "              ",
  //                 style: pw.TextStyle(
  //                   font: arabicFont,
  //                  height: 12,
  //                 ),
  //                 textAlign: pw.TextAlign.center,
  //               ),
  //               pw.Text(
  //                 desc,
  //                 style: pw.TextStyle(
  //                   font: arabicFont,
  //                  height: 12,
  //                 ),
  //                 textAlign: pw.TextAlign.center,
  //               ),
  //             ])),
  //       );
  //     },
  //   ),
  // );

  // Convert the PDF to bytes and trigger download
  final pdfBytes = await pdf.save();
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', '${jname}.pdf')
    ..click();
  html.Url.revokeObjectUrl(url);
}
