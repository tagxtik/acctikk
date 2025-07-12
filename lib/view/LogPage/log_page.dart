import 'package:acctik/services/logService.dart';
 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  const LogPage({super.key});

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  Logservice logservice = Logservice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Log Data")),
      ),
      body: SafeArea(
        child: Row(
          children: [
             Expanded(
              flex: 7,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: logservice.getLogs(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Show loading when waiting for the max journal ID
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (snapshot.hasData) {
                                  List orgdata = snapshot.data!.docs;
                                  print(orgdata.length);
                                  return ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const Divider(), // here u can customize the space.

                                    itemCount: orgdata.length,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot doc = orgdata[index];
                                       Map<String, dynamic> data =
                                          doc.data() as Map<String, dynamic>;
                                      String edittype = data["edittype"];
                                      String logDesc = data["logDesc"];
                                      String editedBy = data["editedBy"];
                                      Timestamp jdate = data["editedDay"];
                                      DateTime dateTime = jdate.toDate();
                                      return SingleChildScrollView(
                                          child: ListTile(
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
                                                   
                                                    Text(
                                                      edittype,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                        "Jornal Name : "),
                                                    Text(
                                                      maxLines: 3,
                                                      logDesc,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Entry Date : "),
                                                    Text(
                                                      editedBy.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                        "Total Debit : "),
                                                    Text(
                                                      dateTime.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                    },
                                  );
                                } else {}
                                return const Text("Loading ... ");
                              })
                        ],
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
}
