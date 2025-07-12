import 'package:acctik/global/master_Ledger_changeMod.dart';
import 'package:acctik/model/jornal_model_details.dart';
import 'package:acctik/model/org_model.dart';
import 'package:acctik/services/account_services.dart';
import 'package:acctik/model/master_ledger_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class ListMainLedger extends StatefulWidget {
  final DateTime from;
  final DateTime to;
  final OrgModel selectedOrganization;

  const ListMainLedger({
    super.key,
    required this.from,
    required this.to,
    required this.selectedOrganization,
  });

  @override
  _ListMainLedgerState createState() => _ListMainLedgerState();
}

class _ListMainLedgerState extends State<ListMainLedger> {
  final AccountServices accs = AccountServices();
  List<bool> selected = [];
  bool selectAll = false;
  bool isLoading = false;
  bool stopProcess = false; // Flag to stop the process
  double mainAccountFetchProgress = 0.0;
  double journalProcessingProgress = 0.0;
  List<String> selectedMainIds = [];

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  void _loadJournals() {
    log('Loading journals...');
    accs.getMainAccounts(widget.selectedOrganization.org_id).listen((snapshot) {
      setState(() {
        selected = List<bool>.filled(snapshot.docs.length, false);
      });
      log('Journals loaded. Total accounts: ${snapshot.docs.length}');
    });
  }

  void _toggleSelectAll(List<DocumentSnapshot> maindata) {
    log('Toggling select all. Current state: $selectAll');
    setState(() {
      selectAll = !selectAll;
      selected = List<bool>.filled(maindata.length, selectAll);
      selectedMainIds = selectAll ? maindata.map((doc) => doc.id).toList() : [];
    });
  }

  Future<List<DocumentSnapshot>> _fetchMainAccounts() async {
    log('Fetching main accounts...');
    try {
      QuerySnapshot snapshot =
          await accs.getMainAccounts(widget.selectedOrganization.org_id).first;

      int totalAccounts = snapshot.docs.length;
      if (totalAccounts == 0) {
        setState(() {
          mainAccountFetchProgress = 1.0; // Set progress to 100% if no accounts
        });
        return [];
      }

      List<DocumentSnapshot> maindata = [];
      for (int i = 0; i < totalAccounts; i++) {
        if (stopProcess) return maindata; // Stop the process if flagged
        maindata.add(snapshot.docs[i]);

        // Update progress incrementally, batched updates for performance
        if (i % 5 == 0 || i == totalAccounts - 1) {
          setState(() {
            mainAccountFetchProgress = (i + 1) / totalAccounts;
          });
        }

        // Allow UI updates
        await Future.delayed(Duration.zero);
      }

      log('Main accounts fetched. Total: $totalAccounts');
      return maindata;
    } catch (e) {
      log('Error fetching main accounts: $e');
      return [];
    }
  }

  Future<void> _processSelectedAccounts() async {
    log('Processing selected accounts...');
    setState(() {
      isLoading = true;
      stopProcess = false;
      mainAccountFetchProgress = 0.0;
      journalProcessingProgress = 0.0;
    });

    try {
      if (selectedMainIds.isEmpty) {
        log('No accounts selected.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      int totalAccounts = selectedMainIds.length;
      int processedAccounts = 0;

      List<MasterLedgerModel> selectedItems = [];
      for (String mainId in selectedMainIds) {
        if (stopProcess) break;

        QuerySnapshot journalsSnapshot = await FirebaseFirestore.instance
            .collection('orgs')
            .doc(widget.selectedOrganization.org_id)
            .collection('journals')
            .where('entredDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(widget.from))
            .where('entredDate',
                isLessThanOrEqualTo: Timestamp.fromDate(widget.to))
            .get();

        int totalJournals = journalsSnapshot.docs.length;
        if (totalJournals == 0) {
          log('No journals found for main ID: $mainId');
          processedAccounts++;
          setState(() {
            journalProcessingProgress =
                processedAccounts / totalAccounts; // Update progress
          });
          continue;
        }

        int processedJournals = 0;
        for (var journalDoc in journalsSnapshot.docs) {
          if (stopProcess) break;

          QuerySnapshot jdetailsSnapshot = await journalDoc.reference
              .collection('jdetails')
              .where('mainid', isEqualTo: mainId)
              .get();

          List<JornalModelDetails> details = jdetailsSnapshot.docs.map((jdoc) {
            Map<String, dynamic> jdata = jdoc.data() as Map<String, dynamic>;
            return JornalModelDetails(
              mainid: jdata['mainid'],
              subid: jdata['subid'],
              value: jdata['value'],
              type: jdata['type'],
              jornalId: int.tryParse(jdata['jornalid'].toString()) ?? 0,
              entredDate: (jdata['entredDate'] as Timestamp).toDate(),
              entredBy: jdata['entredby'],
            );
          }).toList();

          if (details.isNotEmpty) {
            MasterLedgerModel item = MasterLedgerModel(
              jornalId:
                  int.tryParse(journalDoc.get('jornalid').toString()) ?? 0,
              entredDate: (journalDoc.get('entredDate') as Timestamp).toDate(),
              entredBy: journalDoc.get('entredby'),
              totalcred: journalDoc.get('totalcred'),
              totaldeb: journalDoc.get('totaldeb'),
              details: details,
            );
            selectedItems.add(item);
          }

          processedJournals++;
          if (processedJournals % 5 == 0 ||
              processedJournals == totalJournals) {
            setState(() {
              journalProcessingProgress = processedJournals / totalJournals;
            });
          }
          await Future.delayed(Duration.zero); // Yield to UI
        }

        processedAccounts++;
        setState(() {
          mainAccountFetchProgress = processedAccounts / totalAccounts;
          journalProcessingProgress = 0.0; // Reset for next account
        });
      }

      if (selectedItems.isNotEmpty) {
        log('Adding ${selectedItems.length} items to MasterLedgerProvider.');
        final masterLedgerProvider = context.read<MasterLedgerChangemod>();
        await masterLedgerProvider.addSelectedItems(selectedItems);
      }
    } catch (e) {
      log('Error processing selected accounts: $e');
    } finally {
      setState(() {
        isLoading = false;
        mainAccountFetchProgress = 1.0;
        journalProcessingProgress = 1.0;
      });
      log('Processing completed.');
    }
  }

  void _stopProcess() {
    setState(() {
      stopProcess = true;
      isLoading = false;
    });
    final masterLedgerProvider = context.read<MasterLedgerChangemod>();
    masterLedgerProvider.clearSharedPreferences();
    log('Processing stopped.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            accs
                .getMainAccounts(widget.selectedOrganization.org_id)
                .first
                .then((snapshot) {
              _toggleSelectAll(snapshot.docs);
            });
          },
          child: Text(selectAll ? 'Deselect All' : 'Select All'),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? Column(
                  children: [
                    CircularProgressIndicator(
                      value: mainAccountFetchProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    Text(
                      'Fetching Accounts: ${(mainAccountFetchProgress * 100).toStringAsFixed(1)}%',
                    ),
                    CircularProgressIndicator(
                      value: journalProcessingProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                    Text(
                      'Processing Journals: ${(journalProcessingProgress * 100).toStringAsFixed(1)}%',
                    ),
                  ],
                )
              : StreamBuilder<QuerySnapshot>(
                  stream:
                      accs.getMainAccounts(widget.selectedOrganization.org_id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List maindata = snapshot.data!.docs;
                    if (maindata.isEmpty) {
                      return Center(child: Text("No main accounts available."));
                    }
                    return ListView.builder(
                      itemCount: maindata.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = maindata[index];
                        Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                        return CheckboxListTile(
                          title: Text(data["accountname"]),
                          value: selected[index],
                          onChanged: (bool? value) async {
                            setState(() {
                              selected[index] = value ?? false;
                              if (value == true) {
                                selectedMainIds.add(doc.id);
                              } else {
                                selectedMainIds.remove(doc.id);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedMainIds.isNotEmpty) {
              _processSelectedAccounts();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please select at least one account.")),
              );
            }
          },
          child: Text("Process Selected Accounts"),
        ),
        ElevatedButton(
          onPressed: _stopProcess,
          child: Text("Stop Processing"),
        ),
      ],
    );
  }
}
