import 'package:acctik/model/jornal_entry_model.dart';
import 'package:acctik/model/org_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MasterLedgerSrv {
  Future<List<OrgModel>> fetchOrganizations() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Access the main collection where your organization data is stored
      final snapshot = await _firestore.collection('orgs').get();

      // Extract unique organizations as OrgModel instances
      List<OrgModel> organizations = snapshot.docs.map((doc) {
        return OrgModel(
          org_name: doc['orgname'] as String,
          org_id: doc.id, // Using document ID as org_id
        );
      }).toList();

      // Optionally, you can filter for uniqueness based on org_name if needed
      final uniqueOrganizations = organizations.toSet().toList();

      print(uniqueOrganizations.length);
      return uniqueOrganizations;
    } catch (e) {
      print("Error fetching organizations: $e");
      return [];
    }
  }
Future<List<JornalEntryModel>> fetchJournals(
    DateTime startDate, DateTime endDate, String orgid) async {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    final snapshot = await _firestore
        .collection('journals')
        .where('orgid', isEqualTo: orgid)
        .where('entredDate', isGreaterThanOrEqualTo: startDate)
        .where('entredDate', isLessThanOrEqualTo: endDate)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      
      // Check if data contains the required fields before parsing
      if (data['jornalName'] != null && data['debitVal'] != null && data['creditVal'] != null) {
        return JornalEntryModel.fromJson(data);
      } else {
        print("Missing data in document: ${doc.id}");
        return null;  // Return null for incomplete documents
      }
    }).whereType<JornalEntryModel>().toList(); // Filter out null entries
  } catch (e) {
    print("Error fetching journals: $e");
    return [];
  }
}

Future<List<JornalEntryModel>> fetchAllJournals(String orgid) async {
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('journals')
      .where('orgid', isEqualTo: orgid)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Check if data contains the required fields
    if (data['jornalName'] != null && data['debitVal'] != null && data['creditVal'] != null) {
      return JornalEntryModel.fromJson(data);
    } else {
      print("Missing data in document: ${doc.id}");
      return null;
    }
  }).whereType<JornalEntryModel>().toList(); // Filter out null entries
}

  Future<List<JornalEntryModel>> getJournalSelected(String orgid) async {
  final QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('journals')
      .where('orgid', isEqualTo: orgid)
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Check if data contains the required fields
    if (data['jornalName'] != null && data['debitVal'] != null && data['creditVal'] != null) {
      return JornalEntryModel.fromJson(data);
    } else {
      print("Missing data in document: ${doc.id}");
      return null;
    }
  }).whereType<JornalEntryModel>().toList(); // Filter out null entries
}

}
