 
import 'package:acctik/services/account_services.dart';
import 'package:acctik/services/firestore.dart';
import 'package:acctik/view/Widgets/all_main.dart';
import 'package:acctik/view/Widgets/popup_one_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

String getUser() {
  String email; // <-- Their email

  User? user = FirebaseAuth.instance.currentUser;

// Check if the user is signed in
  if (user != null) {
    email = user.email!; // <-- Their email
  } else {
    email = "Null";
  }
  return email;
}

bool isButtonActive = false;

void _addMainPop(BuildContext context) {
  String email = getUser();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PopUpOneText(
        title: 'Add Main Account',
        message: '',
        orgname: _nameController,
        orgDesc: __descController,
        onConfirm: (text) {
          // Handle the confirmed text here
          accs.addMainAccount(
              selectedOrg, _nameController.text, __descController.text, email);
        },
      );
    },
  );
}

String selectedOrg = "0";
final FirestoreService fbs = FirestoreService();
final AccountServices accs = AccountServices();
final TextEditingController _nameController = TextEditingController();
final TextEditingController __descController = TextEditingController();
List<Map<String, dynamic>> _data = [];

class _AccountsState extends State<Accounts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 18,),
                      const Center(
                        child: Text(
                          "Accounts",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                        const SizedBox(height: 18,),
                       const Text(
                        "Choose organization",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("orgs")
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          List<DropdownMenuItem> orgsitems = [];
                          if (!snapshot.hasData) {
                            const CircularProgressIndicator();
                          } else {
                            final orgs = snapshot.data?.docs.reversed.toList();
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
                              if (orgValue != "0") {
                                setState(() {
                                  isButtonActive = true;
                                });
                              }else if (orgValue == "0" ) {
                                setState(() {
                                  isButtonActive = false;
                                });
                              }
                              setState(() {
                                selectedOrg = orgValue;
                              });
                              print(orgValue);
                            },
                            value: selectedOrg,
                            isExpanded: false,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add Account',
                        onPressed: isButtonActive
                            ? () {
                                _addMainPop(context);
                              }
                            : null,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 7,
                            child: AllMain(
                              org_id: selectedOrg,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
