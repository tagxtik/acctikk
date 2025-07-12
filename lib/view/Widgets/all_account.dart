import 'package:acctik/functions.dart';
import 'package:acctik/global/jornal_changeMod.dart';
import 'package:acctik/model/jornal_entry_model.dart';
import 'package:acctik/services/jornal_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllAccount extends StatefulWidget {
  final String org_id;
  final String jornalname;
  final String jornaldesc;
  final int jornalid;
  final DateTime jornaldate;
  AllAccount({
    super.key,
    required this.org_id,
    required this.jornalname,
    required this.jornaldesc,
    required this.jornalid,
    required this.jornaldate,
  });

  @override
  State<AllAccount> createState() => _AllAccountState();
}

class _AllAccountState extends State<AllAccount> {
  final TextEditingController searchController = TextEditingController();
  final Map<int, int> selectedRadioIndexes = {};
  final Map<int, TextEditingController> textControllers = {};
  final JornalService js = JornalService();
  final Map<String, Future<String?>> mainAccountNamesCache = {};

  Future<String?> fetchMainAccountName(String mainId) {
    // Use a cached Future to prevent duplicate fetches
    if (!mainAccountNamesCache.containsKey(mainId)) {
      mainAccountNamesCache[mainId] =
          js.getMainAccountName(widget.org_id, mainId);
    }
    return mainAccountNamesCache[mainId]!;
  }

  @override
  void dispose() {
    for (var controller in textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jornalChangeMod = Provider.of<JornalChangemod>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            // style: TextStyle(color: Colors.black),
            controller: searchController,
            onChanged: (value) {
              setState(() {
                js.getFilteredResults(widget.org_id, searchController.text);
              });
            },
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              // fillColor: const Color.fromARGB(255, 231, 228, 228),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
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
                stream:
                    js.getFilteredResults(widget.org_id, searchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No entries found."));
                  } else {
                    final data = snapshot.data!.docs;
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: data.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final ledgerData =
                            data[index].data() as Map<String, dynamic>;
                        final accountName = ledgerData['accountname'];
                        final mainid = ledgerData['mainid'];
                        final subid = data[index].id;

                        // Cache the future for the main account name
                        final mainAccountNameFuture =
                            fetchMainAccountName(mainid);

                        selectedRadioIndexes.putIfAbsent(index, () => 0);
                        textControllers.putIfAbsent(
                            index, () => TextEditingController());

                        return ListTile(
                          key: ValueKey(data[index].id),
                          title: Center(
                              child:
                                  Text(" الفرعي : $accountName" ?? "No Name")),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder<String?>(
                                future: mainAccountNameFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text("Loading...");
                                  } else if (snapshot.hasError) {
                                    return Text("Error loading main account");
                                  } else {
                                    return Text(
                                        " الرئيسي : ${snapshot.data ?? "No main account"}");
                                  }
                                },
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: TextField(
                                      controller: textControllers[index],
                                      decoration: const InputDecoration(
                                        labelText: "Amount",
                                      ),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      onChanged: (value) {
                                        jornalChangeMod.setTextValue(
                                            index, value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Debit',
                                          style: TextStyle(fontSize: 10)),
                                      Radio<int>(
                                        value: 0,
                                        groupValue: selectedRadioIndexes[index],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRadioIndexes[index] =
                                                value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Credit',
                                          style: TextStyle(fontSize: 10)),
                                      Radio<int>(
                                        value: 1,
                                        groupValue: selectedRadioIndexes[index],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedRadioIndexes[index] =
                                                value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final text = textControllers[index]!.text;
                                      if (text.isNotEmpty) {
                                        final value = double.tryParse(text);
                                        print("Value ${value}");
                                        if (value != null) {
                                          final entry = selectedRadioIndexes[
                                                      index] ==
                                                  0
                                              ? JornalEntryModel(
                                                  userValue: getUser(),
                                                  accountType: "Debit",
                                                  debitVal: value,
                                                  creditVal: 0,
                                                  jornalName: widget.jornalname,
                                                  jornalId: widget.jornalid,
                                                  jornalDate: widget.jornaldate,
                                                  accName: accountName,
                                                  jornalDesc: widget.jornaldesc,
                                                  orgId: widget.org_id,
                                                  mainId: mainid,
                                                  subId: subid,
                                                )
                                              : JornalEntryModel(
                                                  userValue: getUser(),
                                                  accountType: "Credit",
                                                  debitVal: 0,
                                                  creditVal: value,
                                                  jornalName: widget.jornalname,
                                                  jornalId: widget.jornalid,
                                                  jornalDate: widget.jornaldate,
                                                  accName: accountName,
                                                  jornalDesc: widget.jornaldesc,
                                                  orgId: widget.org_id,
                                                  mainId: mainid,
                                                  subId: subid,
                                                );
                                          jornalChangeMod.addJornalItem(entry);
                                          jornalChangeMod.loadItems();
                                        } else {
                                          // Show error if parsing fails
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Please enter a valid number.")),
                                          );
                                        }
                                      } else {
                                        // Show error if the text field is empty
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Amount cannot be empty.")),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
