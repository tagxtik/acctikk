import 'package:acctik/view/Reports/trial_balance.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:acctik/model/org_model.dart';
import 'package:acctik/model/jornal_model_details.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:acctik/global/master_Ledger_changeMod.dart';
import 'package:acctik/view/MasterLedger/accordion_main_ledger.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class MasterLedgerDetail extends StatefulWidget {
  final OrgModel selectedOrganization;
  final DateTime startDate;
  final DateTime endDate;

  const MasterLedgerDetail(
      {super.key,
      required this.selectedOrganization,
      required this.startDate,
      required this.endDate});

  @override
  State<MasterLedgerDetail> createState() => _MasterLedgerDetailState();
}

class _MasterLedgerDetailState extends State<MasterLedgerDetail> {
  final JornalService js = JornalService();
  final Map<String, Future<String?>> subCache = {};
  final Map<String, Future<String?>> mainCache = {};

  pw.Font? arabicFont;

  @override
  void initState() {
    super.initState();
    _loadArabicFont();
  }

  Future<void> _loadArabicFont() async {
    try {
      final fontData =
          await rootBundle.load('assets/fonts/NotoNaskhArabic-Regular.ttf');
      arabicFont = pw.Font.ttf(fontData);
    } catch (e) {
      print("Error loading Arabic font: $e");
      arabicFont = pw.Font.helvetica();
    }
  }

  Future<String?> fetchSub(String mainid, String subid) {
    if (!subCache.containsKey(subid)) {
      subCache[subid] =
          js.getSubname(widget.selectedOrganization.org_id, mainid, subid);
    }
    return subCache[subid]!;
  }

  Future<String?> fetchMainName(String mainid) {
    if (!mainCache.containsKey(mainid)) {
      mainCache[mainid] =
          js.getMainAccountName(widget.selectedOrganization.org_id, mainid);
    }
    return mainCache[mainid]!;
  }

  @override
  Widget build(BuildContext context) {
    final jdetailmod = Provider.of<MasterLedgerChangemod>(context);

    if (jdetailmod.allItems.isEmpty) {
      return Center(
        child: Text(
          "No processed accounts available. Please process accounts to preview details.",
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    // Group operations by `mainid`
    Map<String, List<JornalModelDetails>> groupedDetails = {};
    for (var item in jdetailmod.allItems) {
      for (var detail in item.details) {
        groupedDetails.putIfAbsent(detail.mainid, () => []).add(detail);
      }
    }

    // Calculate overall totals
    double overallTotalDebit = 0.0;
    double overallTotalCredit = 0.0;

    groupedDetails.forEach((mainid, operations) {
      overallTotalDebit += operations
          .where((detail) => detail.type == 'Debit')
          .fold(0.0, (sum, detail) => sum + detail.value);
      overallTotalCredit += operations
          .where((detail) => detail.type == 'Credit')
          .fold(0.0, (sum, detail) => sum + detail.value);
    });
    double overallDifference = 0;
    if (overallTotalCredit > overallTotalDebit) {
      overallDifference = overallTotalCredit - overallTotalDebit;
    } else {
      overallDifference = overallTotalDebit - overallTotalCredit;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          ...groupedDetails.entries.map((entry) {
            String mainid = entry.key;
            List<JornalModelDetails> operations = entry.value;

            // Calculate totals for the current mainid
            double totalDebit = operations
                .where((detail) => detail.type == 'Debit')
                .fold(0.0, (sum, detail) => sum + detail.value);
            double totalCredit = operations
                .where((detail) => detail.type == 'Credit')
                .fold(0.0, (sum, detail) => sum + detail.value);
            double difference = totalCredit - totalDebit;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              jdetailmod.addSummary(
                  mainid, totalDebit, totalCredit, difference);
            });

            return FutureBuilder<String?>(
              future: fetchMainName(mainid),
              builder: (context, snapshot) {
                String mainAccountName =
                    snapshot.data ?? 'Main Account: $mainid';

                return AccordionMainLedger(
                  title: mainAccountName,
                  children: [
                    ...operations.map((detail) {
                      Color typeColor = detail.type == 'Credit'
                          ? const Color.fromARGB(255, 11, 9, 133)
                          : const Color.fromARGB(255, 92, 1, 1);

                      return FutureBuilder<String?>(
                        future: fetchSub(detail.mainid, detail.subid),
                        builder: (context, snapshot) {
                          String subname =
                              snapshot.data ?? 'Sub Account: ${detail.subid}';

                          return Card(
                            color: typeColor,
                            child: ListTile(
                              title: Text(
                                "Sub Account: $subname",
                              ),
                              subtitle: Text(
                                "Value: ${detail.value}, Type: ${detail.type}",
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),

                    // Summary Card
                    Card(
                      color: const Color.fromRGBO(255, 237, 186, 1),
                      child: ListTile(
                        title: Text(
                          "Summary for $mainAccountName",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Debit: $totalDebit",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "Total Credit: $totalCredit",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text("Difference: $difference",
                                style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }).toList(),

          // Overall Summary Card
          Card(
            color: const Color.fromRGBO(250, 224, 208, 1),
            child: ListTile(
              title: const Text("Overall Summary",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Debit: $overallTotalDebit",
                      style: TextStyle(color: Colors.black)),
                  Text("Total Credit: $overallTotalCredit",
                      style: TextStyle(color: Colors.black)),
                  Text("Difference: $overallDifference",
                      style: TextStyle(color: Colors.black)),
                  ElevatedButton(
                    onPressed: () async {
                      generateArabicPDFReport(
                          groupedDetails,
                          arabicFont,
                          widget.selectedOrganization.org_name,
                          widget.selectedOrganization.org_id,
                          widget.startDate,
                          widget.endDate);
                    },
                    child: const Text("Trial Balance Report"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
