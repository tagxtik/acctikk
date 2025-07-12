import 'package:cloud_firestore/cloud_firestore.dart';

class AccountServices {
  final CollectionReference main =
      FirebaseFirestore.instance.collection("orgs");

  // Get Collection
  Future<void> addMainAccount(String docid, String accountname,
      String accountdesc, String entredBy) async {
    final CollectionReference org =
        FirebaseFirestore.instance.collection("orgs");

    // final DocumentReference document = firestore.collection('orgs').doc('user1');
    org.doc(docid).collection("main").add({
      'orgid': docid,
      'accountname': accountname,
      'accountdesc': accountdesc,
      "entredby": entredBy,
      'entredDate': Timestamp.now()
    });
  }

  Future<void> addSubAccount(String orgId, String mainId, String accountname,
      String accountdesc, String entredBy) async {
    final CollectionReference main = FirebaseFirestore.instance
        .collection("orgs")
        .doc(orgId)
        .collection("main");
    // final DocumentReference document = firestore.collection('orgs').doc('user1');
    main.doc(mainId).collection("sub").add({
      'orgid': orgId,
      'mainid': mainId,
      'accountname': accountname,
      'accountdesc': accountdesc,
      "entredby": entredBy,
      'entredDate': Timestamp.now(),
 
    });
  }

  Stream<QuerySnapshot> getMainAccounts(String docId) {
    return FirebaseFirestore.instance
        .collection("orgs")
        .doc(docId)
        .collection("main")
        .snapshots();
  }

  Stream<QuerySnapshot> getSubAccounts(String orgid, String mainid) {
    return FirebaseFirestore.instance
        .collection("orgs")
        .doc(orgid)
        .collection("main")
        .doc(mainid)
        .collection("sub")
        .snapshots();
    // final DocumentReference document = firestore.collection('orgs').doc('user1');
  }

  Stream<QuerySnapshot> getallsub(String orgid, String query) {
    if (query.isEmpty) {
      return FirebaseFirestore.instance
          .collectionGroup('sub')
          .where("orgid", isEqualTo: orgid)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collectionGroup('sub')
          .where("accountname", isEqualTo: query)
          .where("orgid", isEqualTo: orgid)
          .snapshots();
    }
  }

  Future<void> deleteOrg(String docId, String id) {
    final CollectionReference org =
        FirebaseFirestore.instance.collection("orgs");

    // final DocumentReference document = firestore.collection('orgs').doc('user1');
    org.doc(id).collection("main").doc;

    return FirebaseFirestore.instance
        .collection("orgs")
        .doc(docId)
        .collection("main")
        .doc(id)
        .delete();
  }

  Future<DocumentSnapshot> fetchMainData(String orgid, String mainid) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('orgs')
        .doc(orgid)
        .collection("main")
        .doc(mainid)
        .get();
    return documentSnapshot;
  }

  Future<void> updateMainAccount(
      String orgid, String mainid, String accname, String accdesc) {
    return FirebaseFirestore.instance
        .collection("orgs")
        .doc(orgid)
        .collection("main")
        .doc(mainid)
        .update({
      'accountname': accname,
      'accountdesc': accdesc,
    });
  }

  

  Future<int> getMaxSubid() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('journals')
        .orderBy('jornalid', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final document = querySnapshot.docs.first;
      final maximumValue = document.data()['jornalid'] as int?;
      return maximumValue ?? 0; // Return 0 if the field is null
    } else {
      return 0; // Return 0 if the collection is empty
    }
  }

  Future<int> getMaxMainid() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('journals')
        .orderBy('jornalid', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final document = querySnapshot.docs.first;
      final maximumValue = document.data()['jornalid'] as int?;
      return maximumValue ?? 0; // Return 0 if the field is null
    } else {
      return 0; // Return 0 if the collection is empty
    }
  }
}
