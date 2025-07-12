import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListJournalsWithCheckbox extends StatefulWidget {
  final String selectedOrg;
  final String searchType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String searchText;

  const ListJournalsWithCheckbox({
    super.key,
    required this.selectedOrg,
    required this.searchType,
    this.startDate,
    this.endDate,
    required this.searchText,
  });

  @override
  _ListJournalsWithCheckboxState createState() =>
      _ListJournalsWithCheckboxState();
}

class _ListJournalsWithCheckboxState extends State<ListJournalsWithCheckbox> {
  late List<bool> selected; // Tracks the selected state for each journal
  bool selectAll = false;

  @override
  void initState() {
    print(
        "Selected Org ID: ${widget.selectedOrg}"); // In ListJournalsWithCheckbox

    super.initState();
    selected = []; // Initialize the selection state list
  }

  void _toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      for (int i = 0; i < selected.length; i++) {
        selected[i] = selectAll;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _toggleSelectAll,
              child: Text(selectAll
                  ? 'Deselect All ${selected.length}'
                  : 'Select All ${selected.length}'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Print selected"),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: _getFilteredJournals(), // Get journals with filter
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading .... ");
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List maindata = snapshot.data!.docs;

                if (selected.isEmpty) {
                  selected = List<bool>.filled(maindata.length, false);
                }

                return ListView.separated(
                  itemCount: maindata.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot doc = maindata[index];
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    int jid = data["jornalid"];
                    String jname = data["jornalname"];
                    Timestamp jdate = data["entredDate"];
                    DateTime dateTime = jdate.toDate();
                    double totaldeb = data["totaldeb"];
                    double totalcred = data["totalcred"];

                    return CheckboxListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Jornal ID: $jid"),
                          Text("Jornal Name: $jname"),
                          Text("Entry Date: $dateTime"),
                          Text("Total Debit: $totaldeb"),
                          Text("Total Credit: $totalcred"),
                        ],
                      ),
                      value: selected[index],
                      onChanged: (bool? value) {
                        setState(() {
                          selected[index] = value ?? false;
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Stream<QuerySnapshot> _getFilteredJournals() {
    if (widget.searchType == "all") {
      return FirebaseFirestore.instance
          .collection('journals')
          .where('orgid', isEqualTo: widget.selectedOrg)
          .snapshots();
    } else if (widget.searchType == "date") {
      return FirebaseFirestore.instance
          .collection('journals')
          .where('orgid', isEqualTo: widget.selectedOrg)
          .where('entredDate', isGreaterThanOrEqualTo: widget.startDate)
          .where('entredDate', isLessThanOrEqualTo: widget.endDate)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('journals')
          .where('orgid', isEqualTo: widget.selectedOrg)
          .where('jornalid', isEqualTo: int.parse(widget.searchText))
          .snapshots();
    }
  }
}
