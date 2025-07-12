import 'package:acctik/services/firestore.dart';
import 'package:acctik/view/Widgets/org_card.dart';
import 'package:acctik/view/Widgets/popup_one_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllOrg extends StatefulWidget {
  const AllOrg({super.key});

  @override
  State<AllOrg> createState() => _AllOrgState();
}

final FirestoreService fbs = FirestoreService();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _orgController = TextEditingController();
void update(BuildContext context, String docId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final documentSnapshot = fbs.fetchOrgData(docId);
      documentSnapshot.asStream().forEach(
        (element) {
          _nameController.text = element.get("orgname");
          _orgController.text = element.get("orgDesc");
        },
      );

      return PopUpOneText(
        title: 'Edit Organization',
        message: '',
        orgname: _nameController,
        orgDesc: _orgController,
        onConfirm: (text) {
          fbs.updateOrg(docId, _nameController.text, _orgController.text);
        },
      );
    },
  );
}

class _AllOrgState extends State<AllOrg> {
  FirestoreService fbs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: fbs.getOrgs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                  String docid = doc.id;
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  String orgname = data["orgname"];
                  String orgdesc = data["orgDesc"];
                  return SingleChildScrollView(
                    child: OrgCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 9, bottom: 4),
                                child: Text(
                                  orgname,
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
                           
                              IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete Organization',
                                onPressed: () {
                                  fbs.deleteOrg(docid);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.update),
                                tooltip: 'Update Organization',
                                onPressed: () {
                                  update(context, docid);
                                },
                              ),
                            ],
                          ),
                             Padding(
                                padding: const EdgeInsets.only(top: 9, bottom: 4),
                                child: Text(
                                  orgdesc,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  );
                });
          } else {}
          return const Text("Loading ... ");
        });
  }
}






// GridView.builder(
//       itemCount: cd.carddata.length,
//       shrinkWrap: true,
//       physics: const ScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 5, crossAxisSpacing: 15, mainAxisSpacing: 12.0),
//       itemBuilder: (context, index) => OrgCard(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 9, bottom: 4),
//                 child: Text(
//                   cd.carddata[index].org_name,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//               Text(
//                 cd.carddata[index].org_id,
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               const SizedBox(
//                 height: 10,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Edit Name',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Enter valid name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Container(
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.delete),
//                       tooltip: 'Delete Organization',
//                       onPressed: () {
//                         setState(() {});
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.update),
//                       tooltip: 'Update Organization',
//                       onPressed: () {
//                         setState(() {});
//                       },
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );