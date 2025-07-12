import 'package:acctik/services/account_services.dart';
import 'package:acctik/view/Widgets/PopUpFourText.dart';
import 'package:acctik/view/Widgets/accordion_sub_account.dart';
import 'package:acctik/view/Widgets/account_card.dart';
import 'package:acctik/view/Widgets/popup_one_text.dart';
import 'package:acctik/view/Widgets/sub_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllMain extends StatelessWidget {
  final String org_id;

  AllMain({super.key, required this.org_id});
  final AccountServices accs = AccountServices();
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

  final TextEditingController _mainname = TextEditingController();
  final TextEditingController _descname = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  void _addSubAccount(BuildContext context, String orgid, String mainid) {
    String email = getUser();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUpFourText(
          title: 'Add Sub Account',
          message: '',
          orgname: _nameController,
          orgDesc: _descController,
      
          onConfirm: (text) {
            // Handle the confirmed text here
            accs.addSubAccount(org_id, mainid, _nameController.text,
                _descController.text, email, );
          },
        );
      },
    );
  }

  void _showSub(BuildContext context, String orgid, String mainid) {
    showDialog(
      context: context,
      builder: (context) {
        print("This info Belong to $mainid");
        return Dialog(
          child: StreamBuilder<QuerySnapshot>(
              stream: accs.getSubAccounts(orgid, mainid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List maindata = snapshot.data!.docs;
                  print("This info Belong to $mainid with data length : ${maindata.length}");
                  return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const Divider(), // here u can customize the space.

                      itemCount: maindata.length,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = maindata[index];
                         Map<String, dynamic> data =
                            doc.data() as Map<String, dynamic>;
                       TextEditingController subnameController = TextEditingController();
                      TextEditingController  subdescController =  TextEditingController();
 
                        subnameController.text = data["accountname"];
                         subdescController.text = data["accountdesc"];
 
                        return AccordionSubAccount(
                          title: data["accountname"],
                          children: [
                            SubCard(
                              accname: subnameController,
                              accdesc: subdescController,
 
                              onConfirm: (text) {
                                // Handle the confirmed text here
                              },
                            )
                          ],
                        );
                      });
                } else {
                  const Text("No Data To Preview");
                }
                return const Text("Loading ... ");
              }),
        );
      },
    );
  }

  void _updateMain(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopUpOneText(
          title: 'Add Organization',
          message: '',
          orgname: _nameController,
          orgDesc: _descController,
          onConfirm: (text) {
            // Handle the confirmed text here
          },
        );
      },
    );
  }

  void updateMainAccount(BuildContext context, String orgid, String mainid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final documentSnapshot = accs.fetchMainData(orgid, mainid);
        documentSnapshot.asStream().forEach(
          (element) {
            _mainname.text = element.get("accountname");
            _descname.text = element.get("accountdesc");
          },
        );

        return PopUpOneText(
          title: 'Edit Organization',
          message: '',
          orgname: _mainname,
          orgDesc: _descname,
          onConfirm: (text) {
            accs.updateMainAccount(
                orgid, mainid, _mainname.text, _descname.text);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: accs.getMainAccounts(org_id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List maindata = snapshot.data!.docs;
            print(maindata.length);
            return ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(), // here u can customize the space.

                itemCount: maindata.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = maindata[index];
                  String mainid = doc.id;
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String accname = data["accountname"];
                  String accdesc = data["accountdesc"];
                  return SingleChildScrollView(
                    child: InkWell(
                      child: AccountCard(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 9, bottom: 4),
                              child: Text(
                                accname,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9, bottom: 4),
                              child: Text(
                                accdesc,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: 'Delete Organization',
                              onPressed: () {
                                accs.deleteOrg(org_id, mainid);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.update),
                              tooltip: 'Update Organization',
                              onPressed: () {
                                updateMainAccount(context, org_id, mainid);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'Add Sub Account',
                              onPressed: () {
                                _addSubAccount(context, org_id, mainid);
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _showSub(context, org_id, mainid);
                      },
                    ),
                  );
                });
          } else {
            const Text("No Data To Preview");
          }
          return const Text("Loading ... ");
        });
  }
}
