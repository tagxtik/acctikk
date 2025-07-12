import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> copyCollectionWithSubcollections(
    String sourceCollectionPath, String destinationDocPath, List<String> subcollectionNames) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference sourceCollection = firestore.collection(sourceCollectionPath);
  final CollectionReference destinationCollection = firestore
      .doc(destinationDocPath)
      .collection('journals');

  // Get all documents in the source collection
  final QuerySnapshot snapshot = await sourceCollection.get();

  for (final doc in snapshot.docs) {
    final Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
    if (data != null) {
      // Copy main document data to destination
      await destinationCollection.doc(doc.id).set(data);
      print("Copied document ${doc.id}");

      // Copy specified subcollections for the current document
      for (final subcollectionName in subcollectionNames) {
        await copySubcollection(
          sourceCollection.doc(doc.id).collection(subcollectionName),
          destinationCollection.doc(doc.id).collection(subcollectionName),
        );
      }
    }
  }

  print("Completed copying collection with subcollections.");
}

Future<void> copySubcollection(CollectionReference sourceSubcollection, CollectionReference destinationSubcollection) async {
  final QuerySnapshot subcollectionSnapshot = await sourceSubcollection.get();

  for (final subDoc in subcollectionSnapshot.docs) {
    final Map<String, dynamic>? subDocData = subDoc.data() as Map<String, dynamic>?;
    if (subDocData != null) {
      // Copy each subcollection document to the destination
      await destinationSubcollection.doc(subDoc.id).set(subDocData);
      print("Copied subcollection document ${subDoc.id} in subcollection ${sourceSubcollection.id}");
    }
  }
}
