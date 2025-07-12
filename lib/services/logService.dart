 
import 'package:cloud_firestore/cloud_firestore.dart';

class Logservice {
 final CollectionReference log =
      FirebaseFirestore.instance.collection("log");

  Future<void> addLog(String edittype, String logDesc, String entredBy , DateTime entredDate ) {
    print("Log Added");
  return  log.add({
      'edittype': edittype,
      'logDesc': logDesc,
      'editedBy': entredBy,
      'editedDay': entredDate,
    });
    
  }
  Stream<QuerySnapshot> getLogs() {
    return log.orderBy("editedDay", descending: true).snapshots();
  }
}
