import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get Collection
  final CollectionReference org = FirebaseFirestore.instance.collection("orgs");
  //Create
  Future<void> AddOrg(String orgname, String orgDesc, String entredBy) {
    return org.add({
      'orgname': orgname,
      'orgDesc': orgDesc,
      "entredby": entredBy,
      'entredDate': Timestamp.now()
    });
  }
  //Read

  Stream<QuerySnapshot> getOrgs() {
    return org.orderBy("entredby", descending: true).snapshots();
  }
Future<DocumentSnapshot> fetchOrgData(String documentId) async {
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('orgs')
      .doc(documentId)
      .get();
  return documentSnapshot;
}
  //Update
  Future<void> updateOrg(String id, String orgname, String orgDesc) {
    return org.doc(id).update({
      'orgname': orgname,
      'orgDesc': orgDesc,
    });
  }
  //Delete

  Future<void> deleteOrg(String id){
    return  org.doc(id).delete();
  }
  

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> searchByName(String documentId) async {
  final documentSnapshot = FirebaseFirestore.instance
      .collection('org')
      .where('Subdomain', isEqualTo: documentId)
      .snapshots();
  return documentSnapshot;
}
}
