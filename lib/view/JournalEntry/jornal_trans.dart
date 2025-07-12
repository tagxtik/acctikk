import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:acctik/view/JournalEntry/edit_jornal.dart';
import 'package:acctik/view/JournalEntry/jornal_images.dart';
import 'package:acctik/view/Reports/multiple_pdf.dart';
import 'package:acctik/view/Reports/single_pdf.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JornalTrans extends StatefulWidget {
  const JornalTrans({super.key});

  @override
  State<JornalTrans> createState() => _JornalTransState();
}

class _JornalTransState extends State<JornalTrans> {
  @override
  void initState() {
    final jornalChangeMod = JornalChangemod();
    jornalChangeMod.loadItems();
    selected = []; // Initialize the selection state list
    super.initState();
  }

  late List<bool> selected; // Tracks the selected state for each journal
  late List<int> jids = [];
  bool selectAll = false;
  String searchtype = "all";
  bool isButtonActive = false;
  DateTime _FromDate = DateTime.now();
  DateTime _ToDate = DateTime.now();
  final searh = TextEditingController();
  JornalService js = JornalService();
  String selectedOrg = "0";
  String? mainid;
  bool _isLoading = false; // Track the loading state

  void _toggleSelectAll() {
    setState(() {
      selectAll = !selectAll;
      if (selectAll) {
        // Select all journals
        jids = List<int>.from(selected); // Use existing 'selected' state
      } else {
        // Deselect all journals
        jids.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => JornalChangemod(), // Provider added here
      child: Form(
        child: Scaffold(
          body: Stack(
            children: [
              buildui(),

              // Show a progress indicator when loading
              if (_isLoading)
                Center(
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildui() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              flex: 9,
              child: Column(
                children: [
                  const SizedBox(
                    height: 18,
                    width: 40,
                  ),
                  const Center(
                    child: Text(
                      "Jornal Entry Transaction",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('orgs')
                              .snapshots(),
                          builder: (BuildContext context, snapshot) {
                            List<DropdownMenuItem> orgsitems = [];
                            if (!snapshot.hasData) {
                              const CircularProgressIndicator();
                            } else {
                              final orgs =
                                  snapshot.data?.docs.reversed.toList();
                              orgsitems.add(const DropdownMenuItem(
                                value: "0",
                                child: Text(
                                  "Select Client",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ));
                              for (var org in orgs!) {
                                orgsitems.add(
                                  DropdownMenuItem(
                                    value: org.id,
                                    child: Text(
                                      org["orgname"],
                                    ),
                                  ),
                                );
                              }
                            }
                            return DropdownButton(
                              items: orgsitems,
                              onChanged: (orgValue) {
                                setState(() {
                                  selectedOrg = orgValue;
                                });
                              },
                              value: selectedOrg,
                              isExpanded: false,
                            );
                          },
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: IconButton(
                              icon: Icon(Icons.search),
                              tooltip: 'All Journals ',
                              onPressed: () async {
                                setState(() {
                                  searchtype = "all";
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searh.text = value;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black45,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(0, 53, 53, 53)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            hintText: 'Search',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            tooltip: 'Search by ID ',
                            onPressed: () async {
                              setState(() {
                                searchtype = "id";
                              });
                            }),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: 200,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height,
                              maxWidth: 20,
                            ),
                            child: SingleChildScrollView(
                              child: ElevatedButton(
                                onPressed: from,
                                child: Column(
                                  children: [
                                    const Text('From : '),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(_FromDate.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 2,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height,
                            maxWidth: 20,
                          ),
                          child: SingleChildScrollView(
                            child: ElevatedButton(
                              onPressed: to,
                              child: Column(
                                children: [
                                  const Text('To : '),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(_ToDate.toString()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: IconButton(
                            icon: Icon(Icons.search),
                            tooltip: 'Search by Date ',
                            onPressed: () async {
                              setState(() {
                                searchtype = "date";
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
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
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          // Fetch and print reports for selected journals only
                          await fetchMultiple(
                              jids, selectedOrg, "Selected Journals Report");

                          setState(() {
                            _isLoading = false;
                          });
                        },
                        child: Text("Print Selected Collected"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          for (var element in jids) {
                            await fetchJournalEntries(element, selectedOrg);

                            setState(() {
                              _isLoading = false;
                            });
                          }
                          // Generate the report
                        },
                        child: Text("Print Seperated "),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 2000,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                          maxWidth: 2000,
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: searchtype == "all"
                              ? js.getJornals(selectedOrg)
                              : searchtype == "date"
                                  ? js.getJornalsByDate(
                                      selectedOrg, _FromDate, _ToDate)
                                  : js.getJornalsByid(
                                      selectedOrg, int.parse(searh.text)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text("Loading .... ");
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List maindata = snapshot.data!.docs;
                              if (selected.isEmpty) {
                                selected =
                                    List<bool>.filled(maindata.length, false);
                              }
                              return ListView.separated(
                                itemCount: maindata.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  DocumentSnapshot doc = maindata[index];
                                  Map<String, dynamic> data =
                                      doc.data() as Map<String, dynamic>;
                                  int jid = data["jornalid"];
                                  String jname = data["jornalname"];
                                  String jdesc = data["jornaldesc"];
                                  Timestamp jdate = data["entredDate"];
                                  DateTime dateTime = jdate.toDate();

                                  double totaldeb = data["totaldeb"];
                                  double totalcred = data["totalcred"];
                                  String entredBy = data["entredby"];
                                  return CheckboxListTile(
                                    title: ListTile(
                                      trailing: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          // Navigate to edit screen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditJornal(
                                                  orgid: selectedOrg,
                                                  jornalname: jname,
                                                  jornaldesc: jdesc,
                                                  jornalid: jid,
                                                  jornaldate: dateTime),
                                            ),
                                          );
                                        },
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Text("Jornal ID : "),
                                                  Text(
                                                    jid.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Jornal Name : "),
                                                  Text(
                                                    jname,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Entry Date : "),
                                                  Text(
                                                    dateTime.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Total Debit : "),
                                                  Text(
                                                    totaldeb.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Total Credit : "),
                                                  Text(
                                                    totalcred.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Entred By : "),
                                                  Text(
                                                    entredBy,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.delete),
                                              tooltip: 'Delete ',
                                              onPressed: () async {
                                                js.deleteJournalWithSubcollections(
                                                    jid, selectedOrg);
                                              }),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.image),
                                              tooltip: 'Modify Attached Images',
                                              onPressed: () async {
                                                final mediaQuery =
                                                    MediaQuery.of(context).size;

                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        Dialog(
                                                          child: Container(
                                                              width: mediaQuery
                                                                      .width *
                                                                  0.9, // 90% of screen width
                                                              height: mediaQuery
                                                                      .height *
                                                                  0.9, // 90% of screen height),
                                                              child:
                                                                  JornalImages(
                                                                jid: jid,
                                                                orgid:
                                                                    selectedOrg,
                                                              )),
                                                        ));
                                              }),
                                          IconButton(
                                            icon: Icon(Icons.print),
                                            tooltip: 'Print',
                                            onPressed: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              // Generate the report
                                              await fetchJournalEntries(
                                                  jid, selectedOrg);

                                              setState(() {
                                                _isLoading = false;
                                              });
                                            },
                                          ),
                                          if (_isLoading) ...[
                                            SizedBox(width: 16), // Add spacing
                                            CircularProgressIndicator(),
                                          ]
                                        ],
                                      ),
                                    ),
                                    value: jids.contains(jid),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          jids.add(jid);
                                        } else {
                                          jids.remove(jid);
                                        }
                                      });
                                    },
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider();
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> from() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _FromDate = pickedDate;
      });
    }
  }

  Future<void> to() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _ToDate = pickedDate;
      });
    }
  }
}
